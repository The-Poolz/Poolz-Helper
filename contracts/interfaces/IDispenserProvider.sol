// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ISimpleProvider.sol";

interface IDispenserProvider is ISimpleProvider {
    function dispenseLock(
        uint256 poolId,
        uint256 validUntil,
        address owner,
        Builder[] calldata data,
        bytes calldata signature
    ) external;

    struct Builder {
        ISimpleProvider simpleProvider;
        uint256[] params;
    }

    event TokensDispensed(uint256 poolId, address user, uint256 amountTaken, uint256 leftAmount);
}
