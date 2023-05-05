// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20Helper.sol";

contract ERC20HelperMock is ERC20Helper {
    function transferToken(
        address token,
        address receiver,
        uint256 amount
    ) external {
        TransferToken(token, receiver, amount);
    }

    function transferInToken(
        address token,
        address owner,
        uint256 amount
    ) external {
        TransferInToken(token, owner, amount);
    }

    function approveAllowanceERC20(
        address token,
        address receiver,
        uint256 amount
    ) external {
        ApproveAllowanceERC20(token, receiver, amount);
    }
}
