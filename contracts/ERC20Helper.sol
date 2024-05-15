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

    function TransferToken(IERC20 _Token, address _Reciver, uint256 _Amount) internal firewallProtectedSig(0x3844b707) {
        uint256 OldBalance = _Token.balanceOf(address(this));
        emit TransferOut(_Amount, _Reciver, address(_Token));
        _Token.transfer(_Reciver, _Amount);
        if (_Token.balanceOf(address(this)) == (OldBalance + _Amount)) revert SentIncorrectAmount();
    }

    function TransferInToken(IERC20 _Token, uint256 _Amount) internal TestAllowance(_Token, msg.sender, _Amount) {
        if (_Amount == 0) revert ZeroAmount();
        uint256 OldBalance = _Token.balanceOf(address(this));
        _Token.transferFrom(msg.sender, address(this), _Amount);
        emit TransferIn(_Amount, msg.sender, address(_Token));
        if (_Token.balanceOf(address(this)) != (OldBalance + _Amount)) revert ReceivedIncorrectAmount();
    }

    function ApproveAllowanceERC20(
        IERC20 _Token,
        address _Subject,
        uint256 _Amount
    ) internal firewallProtectedSig(0x91251680) {
        if (_Amount == 0) revert ZeroAmount();
        _Token.approve(_Subject, _Amount);
    }
}
