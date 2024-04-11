// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract VaultLib {
    address public owner;

    function init(address _owner) public {
        owner = _owner;
    }

    fallback () external payable {
        revert("Calling a non-existent function!");
    }

    receive () external payable {
        revert("This contract does not accept transfers with empty call data");
    }
}

contract CryptoVault {
    using SafeMath for uint256;

    address public owner;
    uint prcFee;
    uint public collectedFees;
    address tLib;
    mapping (address => uint256) public accounts;

    // Adding a reentrancy guard
    bool private locked;

    modifier noReentrancy() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the contract owner!");
        _;
    }

    constructor(address _vaultLib, uint _prcFee) public {
        tLib = _vaultLib;
        prcFee = _prcFee;
        (bool success,) = tLib.delegatecall(abi.encodeWithSignature("init(address)", msg.sender));
        require(success, "delegatecall failed");
        locked = false; // Lock
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable noReentrancy { // usamos el lock
        require(msg.value >= 100, "Insufficient deposit");
        uint fee = msg.value.mul(prcFee).div(100); // SafeMath
        accounts[msg.sender] = accounts[msg.sender].add(msg.value.sub(fee)); // SafeMath
        collectedFees = collectedFees.add(fee); // SafeMath
    }

    function withdraw(uint _amount) public noReentrancy { // lock
        require(accounts[msg.sender] >= _amount, "Insufficient funds");
        accounts[msg.sender] = accounts[msg.sender].sub(_amount); // SafeMath
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send funds");
    }

    function withdrawAll() public noReentrancy { // lock
        uint amount = accounts[msg.sender];
        require(amount > 0, "Insufficient funds");
        accounts[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send funds");
    }

    function collectFees() public onlyOwner {
        require(collectedFees > 0, "No fees collected");
        uint fees = collectedFees;
        collectedFees = 0; // ataque reentrante
        (bool sent, ) = owner.call{value: fees}("");
        require(sent, "Failed to send fees");
    }

    fallback () external payable {
        revert("Fallback cannot be called directly.");
    }

    receive () external payable {
        revert("Contract does not accept plain Ethers.");
    }
}
