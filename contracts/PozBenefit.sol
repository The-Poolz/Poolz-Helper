// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./GovManager.sol";

contract PozBenefit is GovManager {
    error NotInRange();
    error NotBigger();

    constructor() {
        PozFee = 15; // *10000
        PozTimer = 1000; // *10000

        // POZ_Address = address(0x0);
        // POZBenefit_Address = address(0x0);
    }

    uint256 public PozFee; // the fee for the first part of the pool
    uint256 public PozTimer; //the timer for the first part fo the pool

    modifier PercentCheckOk(uint256 _percent) {
        if (_percent >= 10000) revert NotInRange();
        _;
    }
    modifier LeftIsBigger(uint256 _left, uint256 _right) {
        if (_left <= _right) revert NotBigger();
        _;
    }

    function SetPozTimer(uint256 _pozTimer) public onlyOwnerOrGov PercentCheckOk(_pozTimer) {
        PozTimer = _pozTimer;
    }
}
