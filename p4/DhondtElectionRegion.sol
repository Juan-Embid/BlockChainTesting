pragma solidity ^0.8.0;

contract DhondtElectionRegion {
    uint public regionId;
    mapping(uint => uint) private weights;
    uint[] public results;

    constructor(uint _numParties, uint _regionId) {
        regionId = _regionId;
        savedRegionInfo(); 
        results = new uint[](_numParties);
    }

    function savedRegionInfo() private {
        
        weights[28] = 1; // Madrid
        weights[8] = 1; // Barcelona
        weights[41] = 1; // Sevilla
        weights[44] = 5; // Teruel
        weights[42] = 5; // Soria
        weights[49] = 4; // Zamora
        weights[9] = 4; // Burgos
        weights[29] = 2; // Malaga
    }

    function registerVote(uint partyId) internal returns (bool) {
        if (partyId >= results.length) {
            return false; // El ID de partido no es válido
        }
        results[partyId] += weights[regionId]; // Aplicar el peso del voto
        return true;
    }
}