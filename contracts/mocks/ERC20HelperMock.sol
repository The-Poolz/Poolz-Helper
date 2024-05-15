// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20Helper.sol";

contract ERC20HelperMock is ERC20Helper {
    constructor() ERC20Helper() {}

    function mockTransferToken(IERC20 token, address receiver, uint256 amount) external {
        transferToken(token, receiver, amount);
    }

    function mockTransferInToken(IERC20 token, address owner, uint256 amount) external {
        transferInToken(token, owner, amount);
    }

    function mockApproveAllowanceERC20(IERC20 token, address receiver, uint256 amount) external {
        approveAllowanceERC20(token, receiver, amount);
    }
}
