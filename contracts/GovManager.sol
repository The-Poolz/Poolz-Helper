// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GovManager is Ownable {
    address public GovernorContract;

    modifier onlyOwnerOrGov() {
        require(
            msg.sender == owner() || msg.sender == GovernorContract,
            "Authorization Error"
        );
        _;
    }

    function setGovernorContract(address _address) external onlyOwnerOrGov {
        GovernorContract = _address;
    }

    constructor() {
        GovernorContract = address(0);
    }
}
