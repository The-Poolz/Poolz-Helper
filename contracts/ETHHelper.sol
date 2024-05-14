// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ETHHelper is Ownable, FirewallConsumer {
    error InvalidAmount();
    error SentIncorrectAmount();

    modifier ReceivETH(
        uint256 msgValue,
        address msgSender,
        uint256 _MinETHInvest
    ) {
        if (msgValue < _MinETHInvest) revert InvalidAmount();
        emit TransferInETH(msgValue, msgSender);
        _;
    }

    //@dev not/allow contract to receive funds
    receive() external payable {
        if (!IsPayble) revert();
    }

    event TransferOutETH(uint256 Amount, address To);
    event TransferInETH(uint256 Amount, address From);

    bool public IsPayble;

    function SwitchIsPayble() public onlyOwner {
        IsPayble = !IsPayble;
    }

    function TransferETH(address payable _Reciver, uint256 _amount) internal firewallProtectedSig(0xfd69c215) {
        emit TransferOutETH(_amount, _Reciver);
        uint256 beforeBalance = address(_Reciver).balance;
        _Reciver.transfer(_amount);
        if ((beforeBalance + _amount) != address(_Reciver).balance) revert SentIncorrectAmount();
    }
}
