// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVaultManager{
    function TotalVaults() external view returns(uint);
    function CreateNewVault(address _tokenAddress) external returns(uint vaultId);
    function DepositByToken(address _tokenAddress, address from, uint _amount) external returns (uint vaultId);
    function WithdrawByVaultId(uint _vaultId, address to, uint _amount) external;
    function getVaultBalanceByVaultId(uint _vaultId) external view returns(uint);
    function getVaultBalanceByToken(address _tokenAddress) external view returns(uint);
}