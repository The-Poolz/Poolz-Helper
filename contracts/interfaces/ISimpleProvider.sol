// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IProvider.sol";

///@dev Interface for the simple providers
interface ISimpleProvider is IProvider {
    function withdraw(uint256 poolId, uint256 amount) external returns (uint256 withdrawnAmount, bool isFinal);
}