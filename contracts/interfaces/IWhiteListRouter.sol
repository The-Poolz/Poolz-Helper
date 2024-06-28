// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IWhiteListV2.sol";

interface IWhiteListRouter {
    function handleInvestment(
        address user,
        uint256 whiteListId,
        uint256 amount
    ) external;

    function setWhiteListStatus(IWhiteListV2 whiteList, bool status) external;

    function createNewWhiteList(
        WhiteListSetup[] calldata data,
        DictionaryItems[] calldata dictionary,
        address consumer
    ) external;

    struct Permissions {
        address consumer;
        address owner;
    }

    struct WhiteListSettings {
        WhiteListSetup setup;
        uint256 whiteListId;
    }

    struct WhiteListSetup {
        IWhiteListV2 whiteList;
        uint256 startTime;
        uint256 endTime;
    }

    struct DictionaryItems {
        address[] users;
        uint256[] amounts;
    }

    event UpdateWhiteListStatus(IWhiteListV2 indexed whiteList, bool status);
    event HandleInvestment(
        address indexed user,
        uint256 whiteListId,
        uint256 amount
    );

    error ZeroAddress();
    error InvalidConsumer();
    error ZeroAmount();
    error AlreadySet();
    error InvalidTime();
    error WhiteListNotFound();
    error InvalidWhiteListContract();
    error LengthMismatch(uint256 dictionaryLength, uint256 dataLength);
    error ZeroArrayLength();
}
