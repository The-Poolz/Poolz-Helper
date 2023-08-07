// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC2981.sol";

interface IVaultManager is IERC2981 {
    function depositByToken(address _tokenAddress, address from, uint _amount) external returns (uint vaultId);
    function withdrawByVaultId(uint _vaultId, address to, uint _amount) external;
    function vaultIdToTokenAddress(uint _vaultId) external view returns (address token);
}