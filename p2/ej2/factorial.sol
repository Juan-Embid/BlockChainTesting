// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Factorial {

  function factorial(uint n) public pure returns (uint) {
    uint result = 1;
    for (uint i = 1; i <= n; i++) {
      result *= i;
    }
    return result;
  }
}
