// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Helper {
    event TransferOut(uint256 Amount, address To, address Token);
    event TransferIn(uint256 Amount, address From, address Token);
    modifier TestAllownce(
        address _token,
        address _owner,
        uint256 _amount
    ) {
        require(
            ERC20(_token).allowance(_owner, address(this)) >= _amount,
            "ERC20Helper: no allowance"
        );
        _;
    }

    function TransferToken(
        address _Token,
        address _Reciver,
        uint256 _Amount
    ) internal {
        uint256 OldBalance = ERC20(_Token).balanceOf(address(this));
        emit TransferOut(_Amount, _Reciver, _Token);
        ERC20(_Token).transfer(_Reciver, _Amount);
        require(
        (ERC20(_Token).balanceOf(address(this)) + _Amount) == OldBalance,
            "ERC20Helper: sent incorrect amount"         
            "recive wrong amount of tokens"
        );
    }

    function TransferInToken(
        address _Token,
        address _Subject,
        uint256 _Amount
    ) internal TestAllownce(_Token, _Subject, _Amount) {
        require(_Amount > 0);
        uint256 OldBalance = ERC20(_Token).balanceOf(address(this));
        ERC20(_Token).transferFrom(_Subject, address(this), _Amount);
        emit TransferIn(_Amount, _Subject, _Token);
        require(
            (OldBalance + _Amount) == ERC20(_Token).balanceOf(address(this)),
            "ERC20Helper: Received Incorrect Amount"
        );
    }

    function ApproveAllowanceERC20(
        address _Token,
        address _Subject,
        uint256 _Amount
    ) internal {
        require(_Amount > 0);
        ERC20(_Token).approve(_Subject, _Amount);
    }
}
