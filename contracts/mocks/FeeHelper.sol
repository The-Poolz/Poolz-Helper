// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Fee/FeeBaseHelper.sol";

contract FeeHelper is FeeBaseHelper {
    function MethodWithFee() public payable returns (uint) {
        return takeFee();
    }
}
