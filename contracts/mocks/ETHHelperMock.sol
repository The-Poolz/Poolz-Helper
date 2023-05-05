// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ETHHelper.sol";

contract ETHHelperMock is ETHHelper {
    function receiveETH(
        uint256 minETHInvest
    ) external payable ReceivETH(msg.value, msg.sender, minETHInvest) {}

    function transferETH(address payable reciver, uint256 amount) external {
        TransferETH(reciver, amount);
    }
}
