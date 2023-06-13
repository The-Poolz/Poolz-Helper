// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVaultManager{
    function totalVaults() external view returns(uint);
    function createNewVault(address _tokenAddress) external returns(uint vaultId);
    function depositByToken(address _tokenAddress, address from, uint _amount) external returns (uint vaultId);
    function withdrawByVaultId(uint _vaultId, address to, uint _amount) external;
    function getVaultBalanceByVaultId(uint _vaultId) external view returns(uint);
    function getVaultBalanceByToken(address _tokenAddress) external view returns(uint);
    function vaultIdToVault(uint256 vaultId) external view returns (address);
}