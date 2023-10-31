// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20Helper.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

contract ERC20HelperMock is ERC20Helper {
    function transferToken(
        address token,
        address receiver,
        uint256 amount
    ) external sphereXGuardExternal(0xe86b989f) {
        TransferToken(token, receiver, amount);
    }

    function transferInToken(
        address token,
        address owner,
        uint256 amount
    ) external sphereXGuardExternal(0x3bb51247) {
        TransferInToken(token, owner, amount);
    }

    function approveAllowanceERC20(
        address token,
        address receiver,
        uint256 amount
    ) external sphereXGuardExternal(0xd17a6508) {
        ApproveAllowanceERC20(token, receiver, amount);
    }
}
