// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./GovManager.sol";

contract PozBenefit is GovManager {
    error NotInRange();
    error NotBigger();

    constructor() {
        pozFee = 15; // *10000
        pozTimer = 1000; // *10000

        // POZ_Address = address(0x0);
        // POZBenefit_Address = address(0x0);
    }

    uint256 public immutable pozFee; // the fee for the first part of the pool
    uint256 public pozTimer; //the timer for the first part fo the pool

    modifier percentCheckOk(uint256 percent) {
        if (percent >= 10000) revert NotInRange();
        _;
    }
    modifier leftIsBigger(uint256 left, uint256 right) {
        if (left <= right) revert NotBigger();
        _;
    }

    function setPozTimer(uint256 _pozTimer) public onlyOwnerOrGov percentCheckOk(_pozTimer) {
        pozTimer = _pozTimer;
    }
}
