// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC721Helper.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

contract ERC721HelperMock is ERC721Helper {
    function setApproveForAllNFT(
        address token,
        address to,
        bool approve
    ) external sphereXGuardExternal(0x45052784) {
        SetApproveForAllNFT(token, to, approve);
    }

    function transferNFTIn(
        address token,
        uint256 tokenId,
        address from
    ) external sphereXGuardExternal(0x4537c2de) {
        TransferNFTIn(token, tokenId, from);
    }

    function transferNFTOut(
        address token,
        uint256 tokenId,
        address to
    ) external sphereXGuardExternal(0x445dedb1) {
        TransferNFTOut(token, tokenId, to);
    }
}
