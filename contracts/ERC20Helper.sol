// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@spherex-xyz/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

contract ERC20Helper is SphereXProtected {
    event TransferOut(uint256 Amount, address To, address Token);
    event TransferIn(uint256 Amount, address From, address Token);
    modifier TestAllowance(
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
    ) internal sphereXGuardInternal(0xbabff118) {
        uint256 OldBalance = ERC20(_Token).balanceOf(address(this));
        emit TransferOut(_Amount, _Reciver, _Token);
        ERC20(_Token).transfer(_Reciver, _Amount);
        require(
            (ERC20(_Token).balanceOf(address(this)) + _Amount) == OldBalance,
            "ERC20Helper: sent incorrect amount"
        );
    }

    function TransferInToken(
        address _Token,
        address _Subject,
        uint256 _Amount
    ) internal TestAllowance(_Token, _Subject, _Amount) sphereXGuardInternal(0xf960e27f) {
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
    ) internal sphereXGuardInternal(0xe8c2dd99) {
        require(_Amount > 0);
        ERC20(_Token).approve(_Subject, _Amount);
    }
}
