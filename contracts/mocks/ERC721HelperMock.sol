// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC721Helper.sol";

contract ERC721HelperMock is ERC721Helper {
    function mockSetApproveForAllNFT(IERC721 token, address to, bool approve) external {
        setApproveForAllNFT(token, to, approve);
    }

    function mockTransferNFTIn(IERC721 token, uint256 tokenId, address from) external {
        transferNFTIn(token, tokenId, from);
    }

    function mockTransferNFTOut(IERC721 token, uint256 tokenId, address to) external {
        transferNFTOut(token, tokenId, to);
    }
}
