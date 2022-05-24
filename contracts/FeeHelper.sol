// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GovManager.sol";
import "./FeeBaseHelper.sol";
import "./ERC20Helper.sol";

contract FeeHelper is GovManager {
    FeeBaseHelper public BaseFee;

    constructor() {
        BaseFee = new FeeBaseHelper();
    }

    function PayFee() public payable {
        BaseFee.PayFee{value: msg.value}();
    }

    function WithdrawFee(address payable _to) public onlyOwnerOrGov {
        BaseFee.WithdrawFee(_to, BaseFee.Reserve());
    }

    function SetFee(address _token, uint256 _amount) public onlyOwnerOrGov {
        BaseFee.SetFeeToken(_token);
        BaseFee.SetFeeAmount(_amount);
    }
}
