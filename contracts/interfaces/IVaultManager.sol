// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVaultManager{
    function depositByToken(address _tokenAddress, address from, uint _amount) external returns (uint vaultId);
    function withdrawByVaultId(uint _vaultId, address to, uint _amount) external;
    function vaultIdToTokenAddress(uint _vaultId) external view returns (address token);
    function tokenToVaultId(address _tokenAddress) external view returns (uint vaultId);
}