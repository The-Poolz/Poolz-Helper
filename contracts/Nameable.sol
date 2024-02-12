// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Nameable Helper Contract
 * @dev Abstract contract defines functions to retrieve the name and version of a contract.
 */
abstract contract Nameable {
    /**
     * @dev Returns the name of the contract.
     * @return A string representing the name of the contract.
     */
    function name() external virtual pure returns(string memory);

    /**
     * @dev Returns the version of the contract.
     * @return A string representing the version of the contract.
     */
    function version() external virtual pure returns(string memory);
}
