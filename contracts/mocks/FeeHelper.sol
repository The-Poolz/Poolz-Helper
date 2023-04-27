// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../GovManager.sol";
import "../FeeBaseHelper.sol";

// example to use FeeBaseHelper
contract FeeHelper is GovManager, ERC20Helper {
    FeeBaseHelper public BaseFee;

    constructor() {
        BaseFee = new FeeBaseHelper();
    }

    function PayFee() public payable {
        if (BaseFee.FeeToken() != address(0)) {
            TransferInToken(BaseFee.FeeToken(), msg.sender, BaseFee.Fee());
            IERC20(BaseFee.FeeToken()).approve(address(BaseFee), BaseFee.Fee());
        }
        BaseFee.PayFee{value: msg.value}(BaseFee.Fee());
    }

    function WithdrawFee(address payable _to) public onlyOwnerOrGov {
        BaseFee.WithdrawFee(BaseFee.FeeToken(), _to);
    }

    function SetFee(uint256 _amount) public onlyOwnerOrGov {
        BaseFee.SetFeeAmount(_amount);
    }

    function SetToken(address _token) public onlyOwnerOrGov {
        BaseFee.SetFeeToken(_token);
    }
}
