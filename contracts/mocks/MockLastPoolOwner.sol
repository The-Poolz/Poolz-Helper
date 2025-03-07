// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../LastPoolOwnerState.sol";

/**
 * @title MockLastPoolOwner
 * @dev Mock contract to keep track of the last owner of a Provider pool before a transfer.
 */
contract MockLastPoolOwner is LastPoolOwnerState {
    /**
     * @dev Function to be called before a transfer.
     * @param from Address from which the transfer is initiated.
     * @param poolId Identifier of the Provider pool.
     */
    function beforeTransfer(address from, address, uint256 poolId) external override {
        lastPoolOwner[poolId] = from;
    }

    /**
     * @dev Function to get the last owner of a Provider pool.
     * @param poolId Identifier of the Provider pool.
     * @return Address of the last owner of the Provider pool.
     */
    function getLastPoolOwner(uint256 poolId) external view returns (address) {
        return lastPoolOwner[poolId];
    }
}
