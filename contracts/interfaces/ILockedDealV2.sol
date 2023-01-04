// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILockedDealV2 {
    function CreateNewPool(
        address _Token, //token to lock address
        uint256 _StartTime, //Until what time the pool will start
        uint256 _CliffTime, //Before CliffTime can't withdraw tokens
        uint256 _FinishTime, //Until what time the pool will end
        uint256 _StartAmount, //Total amount of the tokens to sell in the pool
        address _Owner // Who the tokens belong to
    ) external payable;

    function WithdrawToken(uint256 _PoolId)
        external
        returns (uint256 withdrawnAmount);
}
