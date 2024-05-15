// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TestToken is a basic ERC20 Token
 */
contract ERC20Token is ERC20, Ownable {
    /**
     * @dev assign totalSupply to account creating this contract
     */

    constructor(
        string memory _TokenName,
        string memory _TokenSymbol
    ) ERC20(_TokenName, _TokenSymbol) Ownable(_msgSender()) {
        _mint(msg.sender, 5_000_000 * 10 ** 18);
    }

    function FreeTest() public {
        _mint(msg.sender, 5_000_00 * 10 ** 18);
    }
}
