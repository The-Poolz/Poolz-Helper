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

    function CreatePoolsWrtTime(
        address _Token,
        uint256[] calldata _StartTime,
        uint256[] calldata _CliffTime,
        uint256[] calldata _FinishTime,
        uint256[] calldata _StartAmount,
        address[] calldata _Owner
    ) external payable;

    function Index() external returns (uint256);

    function GetMyPoolsId(
        address _UserAddress
    ) external view returns (uint256[] memory);

    function WithdrawToken(
        uint256 _PoolId
    ) external returns (uint256 withdrawnAmount);

    function SplitPoolAmountFrom(
        uint256 _LDpoolId,
        uint256 _Amount,
        address _Address
    ) external returns(uint256 poolId);

    function Allowance(
        uint256 _poolId,
        address _user
    ) external view returns(uint256 amount);

    function AllPoolz(uint256 _LDpoolId) external view returns (
        uint256 StartTime,
        uint256 CliffTime,
        uint256 FinishTime,
        uint256 StartAmount,
        uint256 DebitedAmount,
        address Owner,
        address Token
    );
}
