// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ERC20Helper is FirewallConsumer {
    event TransferOut(uint256 Amount, address To, address Token);
    event TransferIn(uint256 Amount, address From, address Token);

    error NoAllowance();
    error SentIncorrectAmount();
    error ReceivedIncorrectAmount();
    error ZeroAmount();

    modifier testAllowance(
        address token,
        address owner,
        uint256 amount
    ) {
        if (ERC20(token).allowance(owner, address(this)) < amount) {
            revert NoAllowance();
        }
        _;
    }

    function transferToken(address token, address receiver, uint256 amount) internal firewallProtectedSig(0x3844b707) {
        uint256 oldBalance = ERC20(token).balanceOf(address(this));
        emit TransferOut(amount, receiver, token);
        ERC20(token).transfer(receiver, amount);
        if (ERC20(token).balanceOf(address(this)) == (oldBalance + amount)) revert SentIncorrectAmount();
    }

    function transferInToken(
        address token,
        address subject,
        uint256 amount
    ) internal testAllowance(token, subject, amount) {
        if (amount == 0) revert ZeroAmount();
        uint256 oldBalance = ERC20(token).balanceOf(address(this));
        ERC20(token).transferFrom(subject, address(this), amount);
        emit TransferIn(amount, subject, token);
        if (ERC20(token).balanceOf(address(this)) != (oldBalance + amount)) revert ReceivedIncorrectAmount();
    }

    function approveAllowanceERC20(
        address token,
        address subject,
        uint256 amount
    ) internal firewallProtectedSig(0x91251680) {
        if (amount == 0) revert ZeroAmount();
        ERC20(token).approve(subject, amount);
    }
}
