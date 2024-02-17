// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library CalcUtils {
    function calcAmount(uint256 amount, uint256 rate) internal pure returns (uint256 tokenA) {
        return (amount * rate) / 1e21;
    }

    function calcRate(uint256 tokenAValue, uint256 tokenBValue) internal pure returns (uint256 rate) {
        return (tokenAValue * 1e21) / tokenBValue;
    }
}
