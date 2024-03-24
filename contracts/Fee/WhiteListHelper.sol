// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IWhiteList.sol";
import "../GovManager.sol";

abstract contract WhiteListHelper is GovManager {
    error WhiteListNotSet();

    uint public WhiteListId;
    address public WhiteListAddress;

    function getCredits(address _user) public view returns(uint) {
        if(WhiteListAddress == address(0) || WhiteListId == 0) return 0;
        return IWhiteList(WhiteListAddress).Check(_user, WhiteListId);
    }

    function setupNewWhitelist(address _whiteListAddress) external firewallProtected onlyOwnerOrGov {
        WhiteListAddress = _whiteListAddress;
        WhiteListId = IWhiteList(_whiteListAddress).CreateManualWhiteList(type(uint256).max, address(this));
    }

    function addUsers(address[] calldata _users, uint256[] calldata _credits) external firewallProtected onlyOwnerOrGov {
        if(WhiteListAddress == address(0) || WhiteListId == 0) revert WhiteListNotSet();
        IWhiteList(WhiteListAddress).AddAddress(WhiteListId, _users, _credits);
    }

    function removeUsers(address[] calldata _users) external firewallProtected onlyOwnerOrGov {
        if(WhiteListAddress == address(0) || WhiteListId == 0) revert WhiteListNotSet();
        IWhiteList(WhiteListAddress).RemoveAddress(WhiteListId, _users);
    }
}