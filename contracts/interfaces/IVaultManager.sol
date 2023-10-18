// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC2981.sol";

interface IVaultManager is IERC2981 {
    function depositByToken(address _tokenAddress, uint _amount) external returns (uint vaultId);
    function safeDeposit(
        address _tokenAddress,
        uint _amount,
        address _from,
        bytes memory _signature
    ) external returns (uint vaultId);
    function withdrawByVaultId(uint _vaultId, address to, uint _amount) external;
    function vaultIdToTokenAddress(uint _vaultId) external view returns (address token);
    function vaultIdToTradeStartTime(uint256 _vaultId) external view returns (uint256 startTime);
}
