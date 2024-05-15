// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title contains array utility functions
library Array {
    error InvalidArrayLength(uint256 _arrLength, uint256 _n);
    error ZeroArrayLength();
    
    /// @dev returns a new slice of the array
    function KeepNElementsInArray(uint256[] memory _arr, uint256 _n)
        internal
        pure
        returns (uint256[] memory newArray)
    {
        if (_arr.length == _n) return _arr;
        if (_arr.length <= _n) revert InvalidArrayLength(_arr.length, _n);
        newArray = new uint256[](_n);
        for (uint256 i = 0; i < _n; ++i) {
            newArray[i] = _arr[i];
        }
        return newArray;
    }

    function KeepNElementsInArray(address[] memory _arr, uint256 _n)
        internal
        pure
        returns (address[] memory newArray)
    {
        if (_arr.length == _n) return _arr;
        if (_arr.length <= _n) revert InvalidArrayLength(_arr.length, _n);
        newArray = new address[](_n);
        for (uint256 i = 0; i < _n; ++i) {
            newArray[i] = _arr[i];
        }
        return newArray;
    }

    /// @return true if the array is ordered
    function isArrayOrdered(uint256[] memory _arr)
        internal
        pure
        returns (bool)
    {
        if (_arr.length == 0) revert ZeroArrayLength();
        uint256 temp = _arr[0];
        for (uint256 i = 1; i < _arr.length; ++i) {
            if (temp > _arr[i]) {
                return false;
            }
            temp = _arr[i];
        }
        return true;
    }

    /// @return sum of the array elements
    function getArraySum(uint256[] memory _array)
        internal
        pure
        returns (uint256)
    {
        uint256 sum = 0;
        for (uint256 i = 0; i < _array.length; ++i) {
            sum = sum + _array[i];
        }
        return sum;
    }

    /// @return true if the element exists in the array
    function isInArray(address[] memory _arr, address _elem)
        internal
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < _arr.length; ++i) {
            if (_arr[i] == _elem) return true;
        }
        return false;
    }

    function addIfNotExsist(address[] storage _arr, address _elem) internal {
        if (!Array.isInArray(_arr, _elem)) {
            _arr.push(_elem);
        }
    }
}
