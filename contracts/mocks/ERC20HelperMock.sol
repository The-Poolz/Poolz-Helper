// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20Helper.sol";

contract ERC20HelperMock is ERC20Helper {
    function transferToken(IERC20 token, address receiver, uint256 amount) external {
        TransferToken(token, receiver, amount);
    }

    function transferInToken(IERC20 token, uint256 amount) external {
        TransferInToken(token, amount);
    }

    function approveAllowanceERC20(IERC20 token, address receiver, uint256 amount) external {
        ApproveAllowanceERC20(token, receiver, amount);
    }
}
