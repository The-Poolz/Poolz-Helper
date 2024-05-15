// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ERC20Helper is FirewallConsumer {
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

    function transferToken(IERC20 token, address receiver, uint256 amount) internal firewallProtectedSig(0x3844b707) {
        uint256 oldBalance = token.balanceOf(address(this));
        emit TransferOut(amount, receiver, token);
        token.transfer(receiver, amount);
        if (token.balanceOf(address(this)) == (oldBalance + amount)) revert SentIncorrectAmount();
    }

    function transferInToken(
        IERC20 token,
        address subject,
        uint256 amount
    ) internal testAllowance(token, subject, amount) {
        if (amount == 0) revert ZeroAmount();
        uint256 oldBalance = token.balanceOf(address(this));
        token.transferFrom(subject, address(this), amount);
        emit TransferIn(amount, subject, token);
        if (token.balanceOf(address(this)) != (oldBalance + amount)) revert ReceivedIncorrectAmount();
    }

    function approveAllowanceERC20(
        IERC20 token,
        address subject,
        uint256 amount
    ) internal firewallProtectedSig(0x91251680) {
        if (amount == 0) revert ZeroAmount();
        token.approve(subject, amount);
    }
}
