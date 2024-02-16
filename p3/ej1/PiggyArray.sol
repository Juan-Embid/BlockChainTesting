// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;
//10:75974
//20:78500 gas
//30
contract PiggyArray {
    struct Client {
        address addr;
        string name;
        uint balance;
    }

    Client[] public clients;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Función para añadir un nuevo cliente
    function addClient(string memory name) external payable {
        require(bytes(name).length > 0, "Name cannot be empty");
        // Verificar si el cliente ya existe antes de añadirlo
        require(!clientExists(msg.sender), "Client already exists");
        clients.push(Client(msg.sender, name, msg.value));
    }

    // Función para depositar fondos
    function deposit() external payable {
        int clientIndex = findClientIndex(msg.sender);
        require(clientIndex >= 0, "Client not found");
        clients[uint(clientIndex)].balance += msg.value;
    }

    // Función para retirar fondos
    function withdraw(uint amountInWei) external {
        int clientIndex = findClientIndex(msg.sender);
        require(clientIndex >= 0, "Client not found");
        Client storage client = clients[uint(clientIndex)];
        require(client.balance >= amountInWei, "Not enough balance");
        client.balance -= amountInWei;
        payable(msg.sender).transfer(amountInWei);
    }

    // Función para obtener el balance de un cliente
    function getBalance() external view returns (uint) {
        int clientIndex = findClientIndex(msg.sender);
        require(clientIndex >= 0, "Client not found");
        return clients[uint(clientIndex)].balance;
    }

    // Función interna para buscar el índice de un cliente en el array
    function findClientIndex(address clientAddress) internal view returns (int) {
        for (uint i = 0; i < clients.length; i++) {
            if (clients[i].addr == clientAddress) {
                return int(i); // Cliente encontrado, devolver el índice
            }
        }
        return -1; // Cliente no encontrado
    }

    // Función interna para verificar si un cliente existe
    function clientExists(address clientAddress) internal view returns (bool) {
        return findClientIndex(clientAddress) >= 0;
    }
}
