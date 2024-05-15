// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ERC721Helper is FirewallConsumer, ERC721Holder{
    event TransferOut(IERC721 token, uint256 tokenId, address to);
    event TransferIn(IERC721 token, uint256 tokenId, address from);

    error NoAllowance();

    modifier testNFTAllowance(
        IERC721 token,
        uint256 tokenId,
        address owner
    ) {
        if (!token.isApprovedForAll(owner, address(this)) && token.getApproved(tokenId) != address(this)) {
            revert NoAllowance();
        }
        _;
    }

    function transferNFTOut(IERC721 token, uint256 tokenId, address to) internal firewallProtectedSig(0x53905fab) {
        token.transferFrom(address(this), to, tokenId);
        emit TransferOut(token, tokenId, to);
        assert(token.ownerOf(tokenId) == to);
    }

    function transferNFTIn(
        IERC721 token,
        uint256 tokenId,
        address from
    ) internal testNFTAllowance(token, tokenId, from) {
        emit TransferOut(token, tokenId, from);
        token.safeTransferFrom(from, address(this), tokenId);
        assert(token.ownerOf(tokenId) == address(this));
    }

    function setApproveForAllNFT(IERC721 token, address to, bool approve) internal firewallProtectedSig(0xd5ebe78c) {
        token.setApprovalForAll(to, approve);
    }
}
