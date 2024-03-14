// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

library ArrayUtils {
    // Check if a string is contained in an array of strings
    function contains(string[] memory array, string memory val) internal pure returns (bool) {
        for (uint i = 0; i < array.length; i++) {
            if (keccak256(bytes(array[i])) == keccak256(bytes(val))) {
                return true;
            }
        }
        return false;
    }

    // Increment each element of a uint array by a percentage
    function increment(uint[] storage array, uint8 percentage) internal {
        for (uint i = 0; i < array.length; i++) {
            array[i] = array[i] + (array[i] * percentage / 100);
        }
    }

    // Sum the elements of a uint array
    function sum(uint[] memory array) internal pure returns (uint) {
        uint sumN = 0;
        for (uint i = 0; i < array.length; i++) {
            sumN += array[i];
        }
        return sumN;
    }
}
