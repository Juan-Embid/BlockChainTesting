// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract lab6ex6 {
  uint[] public arr;
  function generate(uint n) external {
    // Populates the array with some weird small numbers.
    bytes32 b = keccak256("seed");
    delete arr;
    for (uint i = 0; i < n; i++) {
      uint8 number = uint8(b[i % 32]);
      arr.push(number);
    }
  }

  function maxMinStorage() public view returns (uint maxmin) {
    assembly {
      // Step 1: Store the array slot in memory
      let slot := sload(arr.slot) // Get the slot of the array
      mstore(0x0, slot)
      let arrayDataSlot := keccak256(0, 0x20) // Hash to find the starting slot of the array data

      let length := sload(slot) // Get the length of the array from its slot
      let max := 0
      let min := not(0)

      // Step 2: Iterate through the array to find max and min
      for { let i := 0 } lt(i, length) { i := add(i, 1) } {
          let value := sload(add(arrayDataSlot, i)) // Access each element
          if gt(value, max) { max := value } // Update max
          if lt(value, min) { min := value } // Update min
      }

      maxmin := sub(max, min) // Calculate the difference between max and min
    }
  }
}

// ********* IMPLEMENTACION EJ 3 **********
contract SimpleMaxMinStorage {
    uint[] public arr;

    // Function to populate the array, similar to the previous contract for consistency
    function generate(uint n) external {
        bytes32 b = keccak256(abi.encodePacked("seed"));
        delete arr;
        for (uint i = 0; i < n; i++) {
            uint8 number = uint8(b[i % 32]);
            arr.push(number);
        }
    }

    // Simple implementation of maxMinStorage in Solidity
    function maxMinStorage() public view returns (uint maxmin) {
        require(arr.length > 0, "Array is empty.");

        uint max = arr[0];
        uint min = arr[0];

        for (uint i = 1; i < arr.length; i++) {
            if (arr[i] > max) {
                max = arr[i];
            }
            if (arr[i] < min) {
                min = arr[i];
            }
        }

        maxmin = max - min;
    }
}
