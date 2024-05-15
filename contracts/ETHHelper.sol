// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ETHHelper is Ownable, FirewallConsumer {
    constructor() Ownable(msgSender()) {}

    modifier receivETH(
        uint256 msgValue,
        address msgSender,
        uint256 minETHInvest
    ) {
        require(msgValue >= minETHInvest, "Send ETH to invest");
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

    function TransferETH(address payable _Reciver, uint256 _amount) internal firewallProtectedSig(0xfd69c215) {
        emit TransferOutETH(_amount, _Reciver);
        uint256 beforeBalance = address(_Reciver).balance;
        _Reciver.transfer(_amount);
        require((beforeBalance + _amount) == address(_Reciver).balance, "The transfer did not complite");
    }
}
