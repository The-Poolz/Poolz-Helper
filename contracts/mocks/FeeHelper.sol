// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../FeeBaseHelper.sol";

contract FeeHelper is FeeBaseHelper {

    function MethodWithFee() public payable {
        TakeFee();
    }
}
