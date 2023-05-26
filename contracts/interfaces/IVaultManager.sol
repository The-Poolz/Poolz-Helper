// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVaultManager{
    function TotalVaults() external view returns(uint);
    function CreateNewVault(address _tokenAddress) external returns(uint vaultId);
    function DepositeByVaultId(uint _vaultId, address from, uint _amount) external;
    function WithdrawByVaultId(uint _vaultId, address to, uint _amount) external;
    function getVaultBalanceByVaultId(uint _vaultId) external view returns(uint);
    function getVaultBalanceByTokenAddress(address _tokenAddress) external view returns(uint);
}