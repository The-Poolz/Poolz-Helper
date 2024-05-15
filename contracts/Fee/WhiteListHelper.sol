// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IWhiteList.sol";
import "../GovManager.sol";

abstract contract WhiteListHelper is GovManager {
    error WhiteListNotSet();

    uint public whiteListId;
    address public whiteListAddress;

    modifier WhiteListSet() {
        if (whiteListAddress == address(0) || whiteListId == 0) revert WhiteListNotSet();
        _;
    }

    function getCredits(address _user) public view returns (uint) {
        if (whiteListAddress == address(0) || whiteListId == 0) return 0;
        return IWhiteList(whiteListAddress).Check(_user, whiteListId);
    }

    function setupNewWhitelist(address _whiteListAddress) external firewallProtected onlyOwnerOrGov {
        whiteListAddress = _whiteListAddress;
        whiteListId = IWhiteList(_whiteListAddress).CreateManualWhiteList(type(uint256).max, address(this));
    }

    function addUsers(
        address[] calldata _users,
        uint256[] calldata _credits
    ) external firewallProtected onlyOwnerOrGov WhiteListSet {
        IWhiteList(whiteListAddress).AddAddress(whiteListId, _users, _credits);
    }

    function removeUsers(address[] calldata _users) external firewallProtected onlyOwnerOrGov WhiteListSet {
        IWhiteList(whiteListAddress).RemoveAddress(whiteListId, _users);
    }

    function _whiteListRegister(address _user, uint _credits) internal {
        IWhiteList(whiteListAddress).Register(_user, whiteListId, _credits);
    }
}
