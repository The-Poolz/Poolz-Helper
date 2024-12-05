// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IProvider.sol";

/**
 * @title IInvestProvider
 * @dev Interface for managing investment pools, including investment actions and pool creation.
 * It extends the IProvider interface and defines additional functionality specific to investment pools.
 */
interface IInvestProvider is IProvider {
    /**
     * @notice Allows an address to invest in a specific IDO (Initial DEX Offering) pool.
     * @dev The function is used to transfer a specified amount of tokens into the pool.
     * @param poolId The ID of the pool where the investment will occur.
     * @param amount The amount of tokens to be invested in the pool.
     */
    function invest(uint256 poolId, uint256 amount, uint256 validUntil, bytes calldata signature) external;

    /**
     * @notice Creates a new investment pool.
     * @dev This function is used to create a new pool with the specified parameters, copying the settings of an existing source pool.
     * It will initialize the new pool with the given details and return its poolId.
     * @param poolAmount The maximum amount of tokens that can be invested in the pool.
     * @param investSigner The address of the signer for investments.
     * @param dispenserSigner The address of the signer for dispenses.
     * @param sourcePoolId The ID of the source pool to copy settings from.
     * @return poolId The ID of the newly created pool.
     */
    function createNewPool(
        uint256 poolAmount,
        address investSigner,
        address dispenserSigner,
        uint256 sourcePoolId
    ) external returns (uint256 poolId);

    /**
     * @notice Creates a new investment pool.
     * @dev This function is used to create a new pool with the specified parameters, copying the settings of an existing source pool.
     * It will initialize the new pool with the given details and return its poolId.
     * @param poolAmount The maximum amount of tokens that can be invested in the pool.
     * @param sourcePoolId The ID of the source pool to copy settings from.
     * @return poolId The ID of the newly created pool.
     */
    function createNewPool(uint256 poolAmount, uint256 sourcePoolId) external returns (uint256 poolId);

    /**
     * @dev Struct that represents an IDO pool, which contains the pool's configuration and the remaining investment amount.
     */
    struct Pool {
        uint256 maxAmount; // The maximum amount of tokens that can be invested in the pool
        uint256 leftAmount; // The amount of tokens left to invest in the pool
    }

    /**
     * @notice Emitted when a user successfully invests in a pool.
     * @param poolId The ID of the pool where the investment was made.
     * @param user The address of the user who made the investment.
     * @param amount The amount of tokens that were invested.
     */
    event Invested(uint256 indexed poolId, address indexed user, uint256 amount);

    /**
     * @notice Emitted when a new pool is created.
     * @param poolId The ID of the newly created pool.
     * @param owner The address of the user who created the pool.
     * @param poolAmount The maximum amount of tokens that can be invested in the pool.
     */
    event NewPoolCreated(uint256 indexed poolId, address indexed owner, uint256 poolAmount);

    error InvalidLockDealNFT();
    error InvalidProvider();
    error InvalidPoolId();
    error OnlyLockDealNFT();
    error NoZeroAddress();
    error InvalidParams();
    error NoZeroAmount();
    error ExceededLeftAmount();
    error InvalidParamsLength(uint256 paramsLength, uint256 minLength);
    error InvalidSignature(uint256 poolId, address owner);
    error InvalidTime(uint256 currentTime, uint256 validUntil);
    error InvalidSourcePoolId(uint256 sourcePoolId);
}
