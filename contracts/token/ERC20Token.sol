// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@spherex-xyz/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "@spherex-xyz/openzeppelin-solidity/contracts/access/Ownable.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

/**
 * @title TestToken is a basic ERC20 Token
 */
contract ERC20Token is SphereXProtected, ERC20, Ownable {
    /**
     * @dev assign totalSupply to account creating this contract
     */

    constructor(string memory _TokenName, string memory _TokenSymbol)
        ERC20(_TokenName, _TokenSymbol)
    {
        _mint(msg.sender, 5000000000000);
    }

    function FreeTest() public sphereXGuardPublic(0x22ee4c74, 0x87e41302) {
        _mint(msg.sender, 5000000);
    }
}
