// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GovManager is Ownable {
    address public GovernerContract;

    modifier onlyOwnerOrGov() {
        require(
            msg.sender == owner() || msg.sender == GovernerContract,
            "Authorization Error"
        );
        _;
    }

    function setGovernerContract(address _address) external onlyOwnerOrGov {
        GovernerContract = _address;
    }

    constructor() {
        GovernerContract = address(0);
    }
}
