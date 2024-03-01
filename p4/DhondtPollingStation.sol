pragma solidity ^0.8.0;

import "./PollingStation.sol";
import "./DhondtElectionRegion.sol";

contract DhondtPollingStation is PollingStation, DhondtElectionRegion {

    constructor(address _chairperson, uint _numParties, uint _regionId)
    PollingStation(_chairperson) 
    DhondtElectionRegion(_numParties, _regionId) {}

    function castVote(uint partyId) public override whenVotingOpen {
        bool success = registerVote(partyId);
        require(success, "El voto no es valido o la votacion ha finalizado.");
    }

    function getResults() public view override returns (uint[] memory) {
        require(votingFinished, "La votacion aun no ha finalizado.");
        return results;
    }
}
