// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WhiteListMock {
    uint constant public WhiteListId = 1;

    mapping (address => uint) public AddressToCredits;

    function setCredits(address _user, uint _credits) external {
        AddressToCredits[_user] = _credits;
    }

    function Check(address _user, uint _whiteListId) external view returns(uint) {
        if(_whiteListId != WhiteListId) return 0;
        return AddressToCredits[_user];
    }

    function Register(address _user, uint _whiteListId, uint _amount) external {
        if(_whiteListId != WhiteListId) return;
        AddressToCredits[_user] = AddressToCredits[_user] - _amount;
    }

}