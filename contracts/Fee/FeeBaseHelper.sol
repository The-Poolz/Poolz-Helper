// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20Helper.sol";
import "./WhiteListHelper.sol";

abstract contract FeeBaseHelper is ERC20Helper, WhiteListHelper {
    event TransferInETH(uint256 amount, address from);
    event NewFeeAmount(uint256 newFeeAmount, uint256 oldFeeAmount);
    event NewFeeToken(address newFeeToken, address oldFeeToken);

    error NotEnoughFeeProvided();
    error FeeAmountIsZero();
    error TransferFailed();

    uint256 public feeAmount;
    address public feeToken;

    mapping(address => uint256) public feeReserve;

    function takeFee() internal virtual firewallProtected returns (uint256 feeToPay) {
        feeToPay = feeAmount;
        if (feeToPay == 0) return 0;
        uint256 credits = getCredits(msg.sender);
        if (credits > 0) {
            _whiteListRegister(msg.sender, credits < feeToPay ? credits : feeToPay);
            if (credits < feeToPay) {
                feeToPay -= credits;
            } else {
                return 0;
            }
        }
        _takeFee(feeToPay);
    }

    function _takeFee(uint _fee) private {
        address _feeToken = feeToken; // cache storage reads
        if (_feeToken == address(0)) {
            if (msg.value < _fee) revert NotEnoughFeeProvided();
            emit TransferInETH(msg.value, msg.sender);
        } else {
            transferInToken(IERC20(_feeToken), _fee);
        }
        feeReserve[_feeToken] += _fee;
    }

    function setFee(address _token, uint _amount) external firewallProtected onlyOwnerOrGov {
        feeToken = _token;
        feeAmount = _amount;
    }

    function withdrawFee(address _token, address _to) external firewallProtected onlyOwnerOrGov {
        if (feeReserve[_token] == 0) revert FeeAmountIsZero();
        uint256 amount = feeReserve[_token];
        feeReserve[_token] = 0;
        if (_token == address(0)) {
            (bool success, ) = _to.call{value: amount}("");
            if (!success) revert TransferFailed();
        } else {
            transferToken(IERC20(_token), _to, amount);
        }
    }
}
