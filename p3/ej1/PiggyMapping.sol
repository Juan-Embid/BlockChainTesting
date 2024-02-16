// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract PiggyBank {
  uint public balance;
  address public owner;
    
  struct Client {
        string name;
        uint balance;
    }

  mapping(address => Client) public clients;
  
  constructor() {
    owner = msg.sender;
  }

  function addClient(string memory name)external payable {
    require(bytes(name).length > 0, "Name cannot be empty");
    clients[msg.sender] = Client(name, msg.value);
  }

  function deposit()external payable {
    clients[msg.sender].balance += msg.value;
  }

  function withdraw(uint amountInWei)external {
    require(clients[msg.sender].balance > 0, "Not a registered client");
    require(clients[msg.sender].balance >= amountInWei, "Not enough balance");
    clients[msg.sender].balance -= amountInWei;
    payable(msg.sender).transfer(amountInWei);
  }
  function getBalance()external view returns (uint) {
    require(clients[msg.sender].balance > 0, "Not a registered client");
    return clients[msg.sender].balance;
  }
}
