// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ERC20Helper is FirewallConsumer {
    using SafeERC20 for IERC20;

    event TransferOut(uint256 amount, address to, IERC20 token);
    event TransferIn(uint256 amount, address from, IERC20 token);

    error NoAllowance();
    error SentIncorrectAmount();
    error ReceivedIncorrectAmount();
    error ZeroAmount();

    modifier testAllowance(
        IERC20 token,
        address owner,
        uint256 amount
    ) {
        if (token.allowance(owner, address(this)) < amount) {
            revert NoAllowance();
        }
        _;
    }

    function transferToken(IERC20 token, address to, uint256 amount) internal firewallProtectedSig(0x3844b707) {
        uint256 oldBalance = token.balanceOf(address(this));
        emit TransferOut(amount, to, token);
        token.safeTransfer(to, amount);
        if (token.balanceOf(address(this)) != (oldBalance - amount)) revert SentIncorrectAmount();
    }

    function transferInToken(IERC20 token, uint256 amount) internal testAllowance(token, msg.sender, amount) {
        if (amount == 0) revert ZeroAmount();
        uint256 oldBalance = token.balanceOf(address(this));
        emit TransferIn(amount, msg.sender, token);
        token.safeTransferFrom(msg.sender, address(this), amount);
        if (token.balanceOf(address(this)) != (oldBalance + amount)) revert ReceivedIncorrectAmount();
    }

    function approveAllowanceERC20(
        IERC20 token,
        address subject,
        uint256 amount
    ) internal firewallProtectedSig(0x91251680) returns (bool) {
        if (amount == 0) revert ZeroAmount();
        return token.approve(subject, amount);
    }
}
