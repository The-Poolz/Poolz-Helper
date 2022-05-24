// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Helper.sol";

contract FeeBaseHelper is ERC20Helper {
    uint256 public Fee;
    address public FeeToken;
    uint256 public Reserve;

    event TransferInETH(uint256 Amount, address From);

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

    function SetFeeAmount(uint256 _amount) public {
        require(Fee != _amount, "Can't swap to same fee value");
        Fee = _amount;
    }

    function SetFeeToken(address _token) public {
        require(FeeToken != _token, "Can't swap to same token");
        if (Reserve > 0) {
            WithdrawFee(payable(tx.origin), Reserve); // If the admin tries to set a new token without withrowing the old one
        }
        FeeToken = _token; // set address(0) to use ETH/BNB as main coin
    }

    function WithdrawFee(address payable _to, uint256 _amount) public {
        require(_amount > 0, "Fee amount is zero");
        if (FeeToken == address(0)) {
            _to.transfer(_amount);
        } else {
            TransferToken(FeeToken, _to, _amount);
        }
        Reserve -= _amount;
    }
}
