// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract PiggyMapping2 {
    uint public totalBalance;
    address public owner;

    struct Client {
        string name;
        uint balance;
    }

    mapping(address => Client) public clients;
    address[] private clientAddresses; // Arreglo para almacenar las direcciones de los clientes

    constructor() {
        owner = msg.sender;
    }

    function addClient(string memory name) external payable {
        require(bytes(name).length > 0, "Name cannot be empty");
        require(clients[msg.sender].balance == 0, "Client already exists");

        clients[msg.sender] = Client(name, msg.value);
        clientAddresses.push(msg.sender); // Añade la dirección del cliente al arreglo
        totalBalance += msg.value; // Actualiza el balance total del contrato
    }

    function deposit() external payable {
        require(clients[msg.sender].balance > 0, "Not a registered client");

        clients[msg.sender].balance += msg.value;
        totalBalance += msg.value; // Actualiza el balance total del contrato
    }

    function withdraw(uint amountInWei) external {
        require(clients[msg.sender].balance > 0, "Not a registered client");
        require(clients[msg.sender].balance >= amountInWei, "Not enough balance");

        clients[msg.sender].balance -= amountInWei;
        payable(msg.sender).transfer(amountInWei);
        totalBalance -= amountInWei; // Actualiza el balance total del contrato
    }

    function getBalance() external view returns (uint) {
        require(clients[msg.sender].balance > 0, "Not a registered client");
        return clients[msg.sender].balance;
    }

    function checkBalances() external view returns (bool) {
        uint totalClientBalances = 0;

        for (uint i = 0; i < clientAddresses.length; i++) {
            totalClientBalances += clients[clientAddresses[i]].balance;
        }

        return totalClientBalances == totalBalance; // Compara el total calculado con el balance del contrato
    }
}
