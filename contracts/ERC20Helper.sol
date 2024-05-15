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

    modifier TestAllowance(
        address _token,
        address _owner,
        uint256 _amount
    ) {
        if (ERC20(_token).allowance(_owner, address(this)) < _amount) {
            revert NoAllowance();
        }
        _;
    }

    function TransferToken(
        address _Token,
        address _Reciver,
        uint256 _Amount
    ) internal firewallProtectedSig(0x3844b707) {
        uint256 OldBalance = ERC20(_Token).balanceOf(address(this));
        emit TransferOut(_Amount, _Reciver, _Token);
        ERC20(_Token).transfer(_Reciver, _Amount);
        if (ERC20(_Token).balanceOf(address(this)) == (OldBalance + _Amount)) revert SentIncorrectAmount();
    }

    function TransferInToken(
        address _Token,
        address _Subject,
        uint256 _Amount
    ) internal TestAllowance(_Token, _Subject, _Amount) {
        if (_Amount == 0) revert ZeroAmount();
        uint256 OldBalance = ERC20(_Token).balanceOf(address(this));
        ERC20(_Token).transferFrom(_Subject, address(this), _Amount);
        emit TransferIn(_Amount, _Subject, _Token);
        if (ERC20(_Token).balanceOf(address(this)) != (OldBalance + _Amount)) revert ReceivedIncorrectAmount();
    }

    function ApproveAllowanceERC20(
        address _Token,
        address _Subject,
        uint256 _Amount
    ) internal firewallProtectedSig(0x91251680) {
        if (_Amount == 0) revert ZeroAmount();
        ERC20(_Token).approve(_Subject, _Amount);
    }
}
