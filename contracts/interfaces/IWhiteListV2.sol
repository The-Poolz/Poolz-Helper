// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IWhiteListV2 {
    function createManualWhiteList(
        uint256 changeUntil,
        address contractAddress
    ) external payable returns (uint256 id);

    function addAddress(
        uint256 id,
        address[] calldata users,
        uint256[] calldata amounts
    ) external;

    function removeAddress(uint256 id, address[] calldata users) external;

    function register(address subject, uint256 id, uint256 amount) external;

    function lastRoundRegister(address subject, uint256 id) external;
}
