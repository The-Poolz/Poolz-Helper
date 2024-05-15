// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ETHHelper is Ownable, FirewallConsumer {
    constructor() Ownable(_msgSender()) {}

    error InvalidAmount();
    error SentIncorrectAmount();

    modifier receivETH(
        uint256 msgValue,
        address msgSender,
        uint256 minETHInvest
    ) {
        if (msgValue < minETHInvest) revert InvalidAmount();
        emit TransferInETH(msgValue, msgSender);
        _;
    }

    //@dev not/allow contract to receive funds
    receive() external payable {
        if (!isPayble) revert();
    }

    event TransferOutETH(uint256 amount, address to);
    event TransferInETH(uint256 amount, address from);

    bool public isPayble;

    function switchIsPayble() public onlyOwner {
        isPayble = !isPayble;
    }

    function transferETH(address payable receiver, uint256 _amount) internal firewallProtectedSig(0xfd69c215) {
        emit TransferOutETH(_amount, receiver);
        uint256 beforeBalance = address(receiver).balance;
        receiver.transfer(_amount);
        if ((beforeBalance + _amount) != address(receiver).balance) revert SentIncorrectAmount();
    }
}
