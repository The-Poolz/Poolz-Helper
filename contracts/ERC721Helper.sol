// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ERC721Helper {
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
    ) internal {
        IERC721(_Token).transferFrom(address(this), _To, _TokenId);
        emit TransferOut(_Token, _TokenId, _To);
        assert(IERC721(_Token).ownerOf(_TokenId) == _To);
    }

    function TransferNFTIn(
        address _Token,
        uint256 _TokenId,
        address _From
    ) internal TestNFTAllowance(_Token, _TokenId, _From) {
        IERC721(_Token).transferFrom(_From, address(this), _TokenId);
        emit TransferOut(_Token, _TokenId, _From);
        assert(IERC721(_Token).ownerOf(_TokenId) == address(this));
    }

    function SetApproveForAllNFT(
        address _Token,
        address _To,
        bool _Approve
    ) internal {
        IERC721(_Token).setApprovalForAll(_To, _Approve);
    }
}
