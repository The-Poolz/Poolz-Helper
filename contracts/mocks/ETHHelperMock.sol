// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ETHHelper.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

contract ETHHelperMock is ETHHelper {
    function receiveETH(
        uint256 minETHInvest
    ) external payable ReceivETH(msg.value, msg.sender, minETHInvest) sphereXGuardExternal(0x073921c9) {}

    function transferETH(address payable reciver, uint256 amount) external sphereXGuardExternal(0x0fc8c226) {
        TransferETH(reciver, amount);
    }
}
