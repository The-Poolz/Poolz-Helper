// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBeforeTransfer {
    function beforeTransfer(address from, address to, uint256 poolId) external;
}