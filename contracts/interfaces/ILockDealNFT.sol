// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "./IProvider.sol";
import "./IVaultManager.sol";

interface ILockDealNFT is IERC721Enumerable {
    function approvedContracts(address contractAddress) external view returns (bool);

    function approvedPoolUserTransfers(address user) external view returns (bool); 

    function mintAndTransfer(
        address owner,
        address token,
        uint256 amount,
        IProvider provider
    ) external returns (uint256 poolId);

    function safeMintAndTransfer(
        address owner,
        address token,
        address from,
        uint256 amount,
        IProvider provider,
        bytes calldata data
    ) external returns (uint256 poolId);

    function cloneVaultId(uint256 destinationPoolId, uint256 sourcePoolId) external;

    function mintForProvider(address owner, IProvider provider) external returns (uint256 poolId);

    function getData(uint256 poolId) external view returns (BasePoolInfo memory poolInfo);

    function getFullData(uint256 poolId) external view returns (BasePoolInfo[] memory poolInfo);

    function tokenOf(uint256 poolId) external view returns (address token);

    function vaultManager() external view returns (IVaultManager);

    function poolIdToProvider(uint256 poolId) external view returns (IProvider provider);

    function getWithdrawableAmount(uint256 poolId) external view returns (uint256 withdrawalAmount);

    struct BasePoolInfo {
        IProvider provider;
        string name;
        uint256 poolId;
        uint256 vaultId;
        address owner;
        address token;
        uint256[] params;
    }
}