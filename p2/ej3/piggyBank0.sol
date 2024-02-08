// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract PiggyBank {
  uint public balance;
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function getBalance() external view returns (uint) {
    return balance;
  }

  function deposit() external payable {
    balance += msg.value;
  }

  function withdraw(uint amountInWei) external {
    require(msg.sender == owner, "You are not the owner");
    require(amountInWei <= balance, "Insufficient funds");
    balance -= amountInWei;
    payable(msg.sender).transfer(amountInWei);
  }
}
