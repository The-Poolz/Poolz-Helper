// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Helper.sol";
import "./GovManager.sol";

contract FeeBaseHelper is ERC20Helper, GovManager {
    event TransferInETH(uint256 Amount, address From);
    event NewFeeAmount(uint256 NewFeeAmount, uint256 OldFeeAmount);
    event NewFeeToken(address NewFeeToken, address OldFeeToken);

    uint256 public Fee;
    address public FeeToken;
    uint256 public Reserve;

    function PayFee(uint256 _fee) public payable {
        if (_fee == 0) return;
        if (FeeToken == address(0)) {
            require(msg.value >= _fee, "Not Enough Fee Provided");
            emit TransferInETH(msg.value, tx.origin);
        } else {
            TransferInToken(FeeToken, tx.origin, _fee);
        }
        Reserve += _fee;
    }

    function SetFeeAmount(uint256 _amount) public onlyOwnerOrGov {
        require(Fee != _amount, "Can't swap to same fee value");
        emit NewFeeAmount(_amount, Fee);
        Fee = _amount;
    }

    function SetFeeToken(address _token) public onlyOwnerOrGov {
        require(FeeToken != _token, "Can't swap to same token");
        if (Reserve > 0) {
            WithdrawFee(payable(tx.origin)); // If the admin tries to set a new token without withrowing the old one
        }
        emit NewFeeToken(_token, FeeToken);
        FeeToken = _token; // set address(0) to use ETH/BNB as main coin
    }

    function WithdrawFee(address payable _to) public onlyOwnerOrGov {
        require(Reserve > 0, "Fee amount is zero");
        if (FeeToken == address(0)) {
            _to.transfer(Reserve);
        } else {
            TransferToken(FeeToken, _to, Reserve);
        }
        Reserve = 0;
    }
}
