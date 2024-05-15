// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract GovManager is Ownable, FirewallConsumer {
    event GovernorUpdated(address indexed oldGovernor, address indexed newGovernor);

    error AuthorizationError();

    address public GovernorContract;

    modifier onlyOwnerOrGov() {
        if (msg.sender != owner() && msg.sender != GovernorContract) {
            revert AuthorizationError();
        }
        _;
    }

    function setGovernorContract(address _address) external firewallProtected onlyOwnerOrGov {
        address oldGov = GovernorContract;
        GovernorContract = _address;
        emit GovernorUpdated(oldGov, GovernorContract);
    }

    constructor() Ownable(_msgSender()) {
        GovernorContract = address(0);
    }
}
