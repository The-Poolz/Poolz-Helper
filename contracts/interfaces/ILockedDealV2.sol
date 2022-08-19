// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILockedDealV2 {
    function CreateNewPool(
        address _Token,
        uint256 _StartTime,
        uint256 _FinishTime,
        uint256 _StartAmount,
        address _Owner
    ) external returns (uint256);

    function WithdrawToken(uint256 _PoolId) external returns (bool);
}
