// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//For whitelist, 
interface IWhiteList {
    function Check(address _Subject, uint256 _Id) external view returns(uint);
    function Register(address _Subject,uint256 _Id,uint256 _Amount) external;
    function LastRoundRegister(address _Subject,uint256 _Id) external;
    function CreateManualWhiteList(uint256 _ChangeUntil, address _Contract) external payable returns(uint256 Id);
    function ChangeCreator(uint256 _Id, address _NewCreator) external;
}
