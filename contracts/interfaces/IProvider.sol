// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

///@dev Interface for the provider contract
///@notice This interface is used by the NFT contract to call the provider contract
interface IProvider {
    event UpdateParams(uint256 indexed poolId, uint256[] params);

    function withdraw(uint256 tokenId) external returns (uint256 withdrawnAmount, bool isFinal);

    function split(uint256 oldPoolId, uint256 newPoolId, uint256 ratio) external;

    function registerPool(uint256 poolId, uint256[] calldata params) external;

    function getParams(uint256 poolId) external view returns (uint256[] memory params);

    function getWithdrawableAmount(uint256 poolId) external view returns (uint256 withdrawalAmount);

    function currentParamsTargetLength() external view returns (uint256);

    function name() external view returns (string memory);

    function getSubProvidersPoolIds(uint256 poolID) external view returns (uint256[] memory poolIds);
}