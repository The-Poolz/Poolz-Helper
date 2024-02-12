// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Nameable.sol";

contract NameableMock is Nameable {
    constructor(string memory name, string memory version) Nameable(name, version){
    }
}
