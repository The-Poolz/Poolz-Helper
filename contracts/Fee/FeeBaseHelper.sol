// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20Helper.sol";
import "./WhiteListHelper.sol";

abstract contract FeeBaseHelper is ERC20Helper, WhiteListHelper {
    event TransferInETH(uint Amount, address From);
    event NewFeeAmount(uint NewFeeAmount, uint OldFeeAmount);
    event NewFeeToken(address NewFeeToken, address OldFeeToken);

    error NotEnoughFeeProvided();
    error FeeAmountIsZero();
    error TransferFailed();

    uint public FeeAmount;
    address public FeeToken;
    
    mapping(address => uint) public FeeReserve;

    function TakeFee() internal virtual firewallProtected returns(uint feeToPay){
        feeToPay = FeeAmount;
        if(feeToPay == 0) return 0;
        uint credits = getCredits(msg.sender);
        if(credits > 0) {
            _whiteListRegister(msg.sender, credits < feeToPay ? credits : feeToPay);
            if(credits < feeToPay) {
                feeToPay -= credits;
            } else {
                return 0;
            }
        }
        _TakeFee(feeToPay);
    }

    function _TakeFee(uint _fee) private {
        address _feeToken = FeeToken;   // cache storage reads
        if (_feeToken == address(0)) {
            if (msg.value < _fee) revert NotEnoughFeeProvided();
            emit TransferInETH(msg.value, msg.sender);
        } else {
            TransferInToken(_feeToken, msg.sender, _fee);
        }
        FeeReserve[_feeToken] += _fee;
    }

    function setFee(address _token, uint _amount) external firewallProtected onlyOwnerOrGov {
        FeeToken = _token;
        FeeAmount = _amount;
    }

    function WithdrawFee(address _token, address _to) external firewallProtected onlyOwnerOrGov {
        if (FeeReserve[_token] == 0) revert FeeAmountIsZero();
        if (_token == address(0)) {
            (bool success, ) = _to.call{value: FeeReserve[_token]}("");
            if (!success) revert TransferFailed();
        } else {
            TransferToken(_token, _to, FeeReserve[_token]);
        }
        FeeReserve[_token] = 0;
    }
}
