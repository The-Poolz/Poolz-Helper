// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Array.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

contract ArraysMock is SphereXProtected {
    address[] private addrArr;

    function addIfNotExsist(
        address[] calldata arr,
        address elem
    ) external sphereXGuardExternal(0x438f57db) returns (address[] memory) {
        addrArr = arr;
        Array.addIfNotExsist(addrArr, elem);
        return addrArr;
    }

    function keepNElementsInArray(
        uint256[] calldata arr,
        uint256 n
    ) external pure returns (uint256[] memory newArray) {
        return Array.KeepNElementsInArray(arr, n);
    }

    function KeepNElementsInArray(
        address[] calldata arr,
        uint256 n
    ) external pure returns (address[] memory newArray) {
        return Array.KeepNElementsInArray(arr, n);
    }

    function isArrayOrdered(
        uint256[] calldata arr
    ) external pure returns (bool) {
        return Array.isArrayOrdered(arr);
    }

    function getArraySum(
        uint256[] calldata arr
    ) external pure returns (uint256) {
        return Array.getArraySum(arr);
    }

    function isInArray(
        address[] memory arr,
        address elem
    ) external pure returns (bool) {
        return Array.isInArray(arr, elem);
    }
}
