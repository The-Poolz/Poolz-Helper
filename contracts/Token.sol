// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";

/**
* @title TestToken is a basic ERC20 Token
*/
contract TestToken is ERC20, Ownable{

    /**
    * @dev assign totalSupply to account creating this contract
    */
    
    constructor() ERC20("TestToken", "TEST") public {
        _setupDecimals(5);
        _mint(msg.sender, 5000000000000);

    }
    
    function FreeTest () public {
        _mint(msg.sender, 5000000);
    }
}

