// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Nameable Helper Contract
 * @dev Abstract contract defines functions to retrieve the name and version of a contract.
 */
abstract contract Nameable {
    string private _name;
    string private _version;

    /// @dev Constructor to initialize the name and version of the contract.
    constructor(string memory newName, string memory newVersion) {
        _name = newName;
        _version = newVersion;
    }

    /**
     * @dev Returns the name of the contract.
     * @return A string representing the name of the contract.
     */
    function name() external view returns(string memory) {
        return _name;
    }

    /**
     * @dev Returns the version of the contract.
     * @return A string representing the version of the contract.
     */
    function version() external view returns(string memory) {
        return _version;
    }
}
