// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@spherex-xyz/openzeppelin-solidity/contracts/access/Ownable.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

contract ETHHelper is SphereXProtected, Ownable {
    constructor() {
        IsPayble = false;
    }

    modifier ReceivETH(
        uint256 msgValue,
        address msgSender,
        uint256 _MinETHInvest
    ) {
        require(msgValue >= _MinETHInvest, "Send ETH to invest");
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

    function SwitchIsPayble() public onlyOwner sphereXGuardPublic(0x53f148c0, 0xaac5da5c) {
        IsPayble = !IsPayble;
    }

    function TransferETH(address payable _Reciver, uint256 _amount) internal sphereXGuardInternal(0x09bac3e2) {
        emit TransferOutETH(_amount, _Reciver);
        uint256 beforeBalance = address(_Reciver).balance;
        _Reciver.transfer(_amount);
        require(
            (beforeBalance + _amount) == address(_Reciver).balance,
            "The transfer did not complite"
        );
    }
}
