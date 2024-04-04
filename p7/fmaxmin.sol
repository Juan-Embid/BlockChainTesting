// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MaxMinFinder {
    function maxMinMemory(uint[] memory arr) public pure returns (uint maxmin) {
        assembly {
            // temporary space
            let maxVal := 0
            let minVal := not(0) // max uint value

            let length := mload(arr)
            let data := add(arr, 0x20)
            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                let val := mload(add(data, mul(i, 0x20)))

                if gt(val, maxVal) { maxVal := val }
                if lt(val, minVal) { minVal := val }
            }

            maxmin := sub(maxVal, minVal)
        }
    }
}
