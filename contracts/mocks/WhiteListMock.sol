// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IWhiteList.sol";

contract WhiteListMock is IWhiteList {
    uint public WhiteListId;

    mapping (address => uint) public AddressToCredits;

    function CreateManualWhiteList(uint, address) external payable returns(uint) {
        return ++WhiteListId;
    }

    function Check(address _user, uint _whiteListId) external view returns(uint) {
        if(_whiteListId != WhiteListId) return 0;
        return AddressToCredits[_user];
    }

    function Register(address _user, uint _whiteListId, uint _amount) external {
        if(_whiteListId != WhiteListId) return;
        AddressToCredits[_user] = AddressToCredits[_user] - _amount;
    }

    function AddAddress(uint256 , address[] calldata _Users, uint256[] calldata _Amount) external{
        for(uint i = 0; i < _Users.length; i++){
            AddressToCredits[_Users[i]] = _Amount[i];
        }
    }

    function RemoveAddress(uint256 , address[] calldata _Users) external{
        for(uint i = 0; i < _Users.length; i++){
            delete AddressToCredits[_Users[i]];
        }
    }

    // to avoid the error: Contract "WhiteListMock" should be marked as abstract
    function LastRoundRegister(address _Subject,uint256 _Id) external {}
    function ChangeCreator(uint256 _Id, address _NewCreator) external {}

}