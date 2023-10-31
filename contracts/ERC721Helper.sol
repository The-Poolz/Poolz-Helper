// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

contract ERC721Helper is SphereXProtected {
    event TransferOut(address Token, uint256 TokenId, address To);
    event TransferIn(address Token, uint256 TokenId, address From);

    modifier TestNFTAllowance(
        address _token,
        uint256 _tokenId,
        address _owner
    ) {
        require(
            IERC721(_token).isApprovedForAll(_owner, address(this)) ||
                IERC721(_token).getApproved(_tokenId) == address(this),
            "No Allowance"
        );
        _;
    }

    function TransferNFTOut(
        address _Token,
        uint256 _TokenId,
        address _To
    ) internal sphereXGuardInternal(0x6e83f0f0) {
        IERC721(_Token).transferFrom(address(this), _To, _TokenId);
        emit TransferOut(_Token, _TokenId, _To);
        assert(IERC721(_Token).ownerOf(_TokenId) == _To);
    }

    function TransferNFTIn(
        address _Token,
        uint256 _TokenId,
        address _From
    ) internal TestNFTAllowance(_Token, _TokenId, _From) sphereXGuardInternal(0xc76dc0f9) {
        IERC721(_Token).transferFrom(_From, address(this), _TokenId);
        emit TransferOut(_Token, _TokenId, _From);
        assert(IERC721(_Token).ownerOf(_TokenId) == address(this));
    }

    function SetApproveForAllNFT(
        address _Token,
        address _To,
        bool _Approve
    ) internal sphereXGuardInternal(0x11a52ea3) {
        IERC721(_Token).setApprovalForAll(_To, _Approve);
    }
}
