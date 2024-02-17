// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../CalcUtils.sol";

contract CalcUtilsMock {
    using CalcUtils for uint256;
    
    function calcAmount(uint256 amount, uint256 rate) external pure returns (uint256 tokenA) {
        return amount.calcAmount(rate);
    }

    function calcRate(uint256 tokenAValue, uint256 tokenBValue) external pure returns (uint256 rate) {
        return tokenAValue.calcRate(tokenBValue);
    }
}
