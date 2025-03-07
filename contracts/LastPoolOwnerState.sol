// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IBeforeTransfer.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/**
 * @title LastPoolOwnerState
 * @dev Contract to keep track of the last owner of a Provider pool before a transfer.
 */
abstract contract LastPoolOwnerState is IBeforeTransfer, IERC165 {
    // Mapping to store the last owner of each Provider pool before a transfer
    mapping(uint256 => address) internal lastPoolOwner;

    /**
     * @dev Function to be called before a transfer.
     * @param from Address from which the transfer is initiated.
     * @param to Address to which the transfer is directed.
     * @param poolId Identifier of the Provider pool.
     */
    function beforeTransfer(address from, address to, uint256 poolId) external virtual override;

    /**
     * @dev Checks whether a contract supports the specified interface.
     * @param interfaceId Interface identifier.
     * @return A boolean indicating whether the contract supports the specified interface.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId || interfaceId == type(IBeforeTransfer).interfaceId;
    }
}