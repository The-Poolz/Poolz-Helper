// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/security/Pausable.sol";
import "./GovManager.sol";

/**
 * @title Pausable Helper Contract
 * @dev Contract that allows the owner or government to pause and unpause certain contract functions in case of emergency.
 */
contract PausableHelper is GovManager, Pausable {
    /// @dev Pauses certain contract functions in case of emergency.
    function pause() external onlyOwnerOrGov {
        _pause();
    }

    /// @dev Unpauses certain contract functions that were paused by the pause() function.
    function unpause() external onlyOwnerOrGov {
        _unpause();
    }
}
