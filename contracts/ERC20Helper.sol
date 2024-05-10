// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ERC20Helper is FirewallConsumer {
    using SafeERC20 for IERC20;

    event TransferOut(uint256 Amount, address To, address Token);
    event TransferIn(uint256 Amount, address From, address Token);

    modifier TestAllowance(
        IERC20 token,
        address owner,
        uint256 amount
    ) {
        require(token.allowance(owner, address(this)) >= amount, "ERC20Helper: no allowance");
        _;
    }

    function TransferToken(IERC20 token, address receiver, uint256 amount) internal firewallProtectedSig(0x3844b707) {
        uint256 oldBalance = token.balanceOf(address(this));
        emit TransferOut(amount, receiver, address(token));
        token.safeTransfer(receiver, amount);
        require((token.balanceOf(address(this)) + amount) == oldBalance, "ERC20Helper: sent incorrect amount");
    }

    function TransferInToken(IERC20 token, uint256 amount) internal TestAllowance(token, msg.sender, amount) {
        require(amount > 0);
        uint256 oldBalance = token.balanceOf(address(this));
        token.safeTransferFrom(msg.sender, address(this), amount);
        emit TransferIn(amount, msg.sender, address(token));
        require((oldBalance + amount) == token.balanceOf(address(this)), "ERC20Helper: Received Incorrect Amount");
    }

    function ApproveAllowanceERC20(
        IERC20 token,
        address subject,
        uint256 amount
    ) internal firewallProtectedSig(0x91251680) {
        require(amount > 0);
        token.approve(subject, amount);
    }
}
