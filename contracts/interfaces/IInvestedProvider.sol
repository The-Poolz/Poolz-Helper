// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IProvider.sol";

interface IInvestedProvider is IProvider {
    function onCreation(uint256 poolId, bytes calldata data) external;

    function onInvest(
        uint256 poolId,
        uint256 amount,
        bytes calldata data
    ) external;
}
