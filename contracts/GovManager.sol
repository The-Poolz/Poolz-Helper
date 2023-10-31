// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

contract GovManager is SphereXProtected, Ownable {
    event GovernorUpdated (
        address indexed oldGovernor,
        address indexed newGovernor
    );

    address public GovernorContract;

    modifier onlyOwnerOrGov() {
        require(
            msg.sender == owner() || msg.sender == GovernorContract,
            "Authorization Error"
        );
        _;
    }

    function setGovernorContract(address _address) external onlyOwnerOrGov sphereXGuardExternal(0xecf5f0e5) {
        address oldGov = GovernorContract;
        GovernorContract = _address;
        emit GovernorUpdated(oldGov, GovernorContract);
    }

    constructor() {
        GovernorContract = address(0);
    }
}
