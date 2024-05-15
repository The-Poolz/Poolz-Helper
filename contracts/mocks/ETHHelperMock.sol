// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ETHHelper.sol";

contract ETHHelperMock is ETHHelper {
    constructor() ETHHelper() {}

    function receiveETH(uint256 minETHInvest) external payable receivETH(msg.value, msg.sender, minETHInvest) {}

    function mockTransferETH(address payable reciver, uint256 amount) external {
        transferETH(reciver, amount);
    }
}
