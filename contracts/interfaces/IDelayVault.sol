// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDelayVault {
    function setLockedDealAddress(address _lockedDealAddress) external;

    function WithdrawFrom(
        address _token,
        address _owner,
        address _spender,
        uint256 _amount
    ) external;
}
