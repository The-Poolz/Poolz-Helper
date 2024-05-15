// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IWhiteList.sol";
import "../GovManager.sol";

abstract contract WhiteListHelper is GovManager {
    error WhiteListNotSet();

    uint public whiteListId;
    address public whiteListAddress;

    modifier whiteListSet() {
        if (whiteListAddress == address(0) || whiteListId == 0) revert WhiteListNotSet();
        _;
    }

    function getCredits(address user) public view returns (uint) {
        if (whiteListAddress == address(0) || whiteListId == 0) return 0;
        return IWhiteList(whiteListAddress).Check(user, whiteListId);
    }

    function setupNewWhitelist(address _whiteListAddress) external firewallProtected onlyOwnerOrGov {
        whiteListAddress = _whiteListAddress;
        whiteListId = IWhiteList(_whiteListAddress).CreateManualWhiteList(type(uint256).max, address(this));
    }

    function addUsers(
        address[] calldata users,
        uint256[] calldata credits
    ) external firewallProtected onlyOwnerOrGov whiteListSet {
        IWhiteList(whiteListAddress).AddAddress(whiteListId, users, credits);
    }

    function removeUsers(address[] calldata users) external firewallProtected onlyOwnerOrGov whiteListSet {
        IWhiteList(whiteListAddress).RemoveAddress(whiteListId, users);
    }

    function _whiteListRegister(address user, uint credits) internal {
        IWhiteList(whiteListAddress).Register(user, whiteListId, credits);
    }
}
