// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IInnerWithdraw {
    function getInnerIdsArray(uint256 poolId) external returns (uint256[] calldata ids);
}