// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./ArrayUtils.sol";

interface ERC721simplified {
  // EVENTS
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  // APPROVAL FUNCTIONS
  function approve(address _approved, uint256 _tokenId) external payable;

  // TRANSFER FUNCTION
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

  // VIEW FUNCTIONS (GETTERS)
  function balanceOf(address _owner) external view returns (uint256);
  function ownerOf(uint256 _tokenId) external view returns (address);
  function getApproved(uint256 _tokenId) external view returns (address);
}

contract MonsterTokens is ERC721simplified {
    using ArrayUtils for uint[];
    
    struct Weapons {
        string[] names;
        uint[] firePowers;
    }

    struct Character {
        string name;
        Weapons weapons;
        address owner;
        address approved;
    }

    mapping(uint => Character) private characters;
    mapping(address => uint) private balances;
    uint private nextTokenId = 10001;
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createMonsterToken(string memory characterName, address tokenOwner) external onlyOwner returns (uint) {
        uint tokenId = nextTokenId++;
        characters[tokenId] = Character(characterName, Weapons(new string[](0), new uint[](0)), tokenOwner, address(0));
        balances[tokenOwner]++;
        return tokenId;
    }

    function addWeapon(uint tokenId, string memory weaponName, uint firePower) external {
        require(msg.sender == characters[tokenId].owner || msg.sender == characters[tokenId].approved, "Only owner or approved can call this function.");
        require(!ArrayUtils.contains(characters[tokenId].weapons.names, weaponName), "Weapon already exists");
        characters[tokenId].weapons.names.push(weaponName);
        characters[tokenId].weapons.firePowers.push(firePower);
    }

    function incrementFirePower(uint tokenId, uint8 percentage) external {
        require(msg.sender == characters[tokenId].owner || msg.sender == characters[tokenId].approved, "Only owner or approved can call this function.");
        characters[tokenId].weapons.firePowers.increment(percentage);
    }

    function collectProfits() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // Implemented functions
    function approve(address _approved, uint256 _tokenId) external payable {
        require(msg.sender == characters[_tokenId].owner, "Only owner can approve");
        require(msg.value >= characters[_tokenId].weapons.firePowers.sum(), "Insufficient value sent");
        characters[_tokenId].approved = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(msg.sender == characters[_tokenId].owner || msg.sender == characters[_tokenId].approved, "Only owner or approved can transfer");
        require(msg.value >= characters[_tokenId].weapons.firePowers.sum(), "Insufficient value sent");
        require(_from == characters[_tokenId].owner, "Incorrect owner");
        
        characters[_tokenId].owner = _to;
        characters[_tokenId].approved = address(0);
        balances[_from]--;
        balances[_to]++;
        
        emit Transfer(_from, _to, _tokenId);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        require(characters[_tokenId].owner != address(0), "Token does not exist");
        return characters[_tokenId].owner;
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        require(characters[_tokenId].owner != address(0), "Token does not exist");
        return characters[_tokenId].approved;
    }
}
