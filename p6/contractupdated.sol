// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract lab6 {
    uint[] private arr;
    uint private sum;

    function generate(uint n) external {
      for (uint i = 0; i < n; i++) {
        arr.push(i*i);
      }
    }

    // Compute sum in memory and then update storage
    function computeSum() external {
        uint localSum = 0;
        uint len = arr.length; // Cache length to avoid multiple SLOADs
        for (uint i = 0; i < len; i++) {
            localSum += arr[i]; // Direct access to storage, but minimized other operations
        }
        sum = localSum; // Single storage update
    }

    function getSum() external view returns (uint) {
        return sum;
    }

    function getArrayElement(uint index) external view returns (uint) {
        require(index < arr.length, "Index out of bounds");
        return arr[index];
    }
}
