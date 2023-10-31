// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../GovManager.sol";
import "../FeeBaseHelper.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

// example to use FeeBaseHelper
contract FeeHelper is GovManager, ERC20Helper {
    FeeBaseHelper public BaseFee;

    constructor() {
        BaseFee = new FeeBaseHelper();
    }

    function PayFee() public payable sphereXGuardPublic(0x77a7e7b2, 0xca4dc3f5) {
        if (BaseFee.FeeToken() != address(0)) {
            TransferInToken(BaseFee.FeeToken(), msg.sender, BaseFee.Fee());
            IERC20(BaseFee.FeeToken()).approve(address(BaseFee), BaseFee.Fee());
        }
        BaseFee.PayFee{value: msg.value}(BaseFee.Fee());
    }

    function WithdrawFee(address payable _to) public onlyOwnerOrGov sphereXGuardPublic(0xe18fc262, 0x3aa0d15d) {
        BaseFee.WithdrawFee(BaseFee.FeeToken(), _to);
    }

    function SetFee(uint256 _amount) public onlyOwnerOrGov sphereXGuardPublic(0x876b48a2, 0x00172ddf) {
        BaseFee.SetFeeAmount(_amount);
    }

    function SetToken(address _token) public onlyOwnerOrGov sphereXGuardPublic(0xbbbc7ff1, 0xefc1fd16) {
        BaseFee.SetFeeToken(_token);
    }
}
