// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

contract ERC721Helper is FirewallConsumer {
    event TransferOut(address Token, uint256 TokenId, address To);
    event TransferIn(address Token, uint256 TokenId, address From);

    error NoAllowance();

    modifier testNFTAllowance(
        address token,
        uint256 tokenId,
        address owner
    ) {
        if (
            !IERC721(token).isApprovedForAll(owner, address(this)) &&
            IERC721(token).getApproved(tokenId) != address(this)
        ) {
            revert NoAllowance();
        }
        _;
    }

    function transferNFTOut(address token, uint256 tokenId, address to) internal firewallProtectedSig(0x53905fab) {
        IERC721(token).transferFrom(address(this), to, tokenId);
        emit TransferOut(token, tokenId, to);
        assert(IERC721(token).ownerOf(tokenId) == to);
    }

    function transferNFTIn(
        address token,
        uint256 tokenId,
        address from
    ) internal testNFTAllowance(token, tokenId, from) {
        IERC721(token).transferFrom(from, address(this), tokenId);
        emit TransferOut(token, tokenId, from);
        assert(IERC721(token).ownerOf(tokenId) == address(this));
    }

    function setApproveForAllNFT(address token, address to, bool approve) internal firewallProtectedSig(0xd5ebe78c) {
        IERC721(token).setApprovalForAll(to, approve);
    }
}
