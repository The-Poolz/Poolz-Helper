// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC721Helper.sol";

contract ERC721Mock is ERC721Helper {
    function setApproveForAllNFT(
        address token,
        address to,
        bool approve
    ) external {
        SetApproveForAllNFT(token, to, approve);
    }

    function transferNFTIn(
        address token,
        uint256 tokenId,
        address from
    ) external {
        TransferNFTIn(token, tokenId, from);
    }

    function transferNFTOut(
        address token,
        uint256 tokenId,
        address to
    ) external {
        TransferNFTOut(token, tokenId, to);
    }
}
