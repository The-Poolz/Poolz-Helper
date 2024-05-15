// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ERC20Helper is FirewallConsumer {
    using SafeERC20 for IERC20;

    event TransferOut(uint256 Amount, address To, address Token);
    event TransferIn(uint256 Amount, address From, address Token);

    error NoAllowance();
    error SentIncorrectAmount();
    error ReceivedIncorrectAmount();
    error ZeroAmount();

    modifier TestAllowance(
        IERC20 _Token,
        address _Owner,
        uint256 _Amount
    ) {
        if (_Token.allowance(_Owner, address(this)) < _Amount) {
            revert NoAllowance();
        }
        _;
    }

    function TransferToken(IERC20 token, address to, uint256 amount) internal firewallProtectedSig(0x3844b707) {
        uint256 OldBalance = token.balanceOf(address(this));
        emit TransferOut(amount, msg.sender, address(token));
        token.safeTransfer(to, amount);
        if (token.balanceOf(address(this)) != (OldBalance - amount)) revert SentIncorrectAmount();
    }

    function TransferInToken(IERC20 token, uint256 amount) internal TestAllowance(token, msg.sender, amount) {
        if (amount == 0) revert ZeroAmount();
        uint256 OldBalance = token.balanceOf(address(this));
        token.safeTransferFrom(msg.sender, address(this), amount);
        emit TransferIn(amount, msg.sender, address(token));
        if (token.balanceOf(address(this)) != (OldBalance + amount)) revert ReceivedIncorrectAmount();
    }

    function ApproveAllowanceERC20(
        IERC20 _Token,
        address _Subject,
        uint256 _Amount
    ) internal firewallProtectedSig(0x91251680) returns (bool) {
        if (_Amount == 0) revert ZeroAmount();
        return _Token.approve(_Subject, _Amount);
    }
}
