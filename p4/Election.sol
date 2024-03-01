pragma solidity ^0.8.0;

// Asegúrate de tener definidos los contratos DhondtPollingStation y otras dependencias necesarias
import "./DhondtPollingStation.sol";
contract Election {
    address public authority;
    uint public numParties;
    mapping(uint => DhondtPollingStation) public pollingStations;
    mapping(address => bool) public hasVoted;

    modifier onlyAuthority() {
        require(msg.sender == authority, "Solo la autoridad puede ejecutar esta funcion.");
        _;
    }

    modifier freshId(uint regionId) {
        require(address(pollingStations[regionId]) == address(0), "Una sede electoral ya existe para esta region.");
        _;
    }

    modifier validId(uint regionId) {
        require(address(pollingStations[regionId]) != address(0), "No existe una sede electoral para esta region.");
        _;
    }

    constructor(uint _numParties) {
        authority = msg.sender;
        numParties = _numParties;
    }

    function createPollingStation(uint regionId, address chairperson) external onlyAuthority freshId(regionId) returns (address) {
        DhondtPollingStation newStation = new DhondtPollingStation(chairperson, numParties, regionId);
        pollingStations[regionId] = newStation;
        return address(newStation);
    }

    function castVote(uint regionId, uint partyId) external validId(regionId) {
        require(!hasVoted[msg.sender], "Ya has votado.");
        pollingStations[regionId].castVote(partyId);
        hasVoted[msg.sender] = true;
    }

    function getResults() external view onlyAuthority returns (uint[] memory) {
        uint[] memory finalResults = new uint[](numParties);
        for (uint i = 0; i < numParties; i++) {
            uint regionId = i;
            DhondtPollingStation station = pollingStations[regionId];
            require(station.votingFinished(), "La votacion no ha finalizado para todas las regiones");
            uint[] memory localResults = station.getResults();
            for (uint j = 0; j < numParties; j++) {
                finalResults[j] += localResults[j];
            }
        }
        return finalResults;
    }
}
