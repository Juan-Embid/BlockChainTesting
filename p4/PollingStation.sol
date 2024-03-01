pragma solidity ^0.8.0;

abstract contract PollingStation {
    bool public votingFinished = false;
    bool private votingOpen = false;
    address public chairperson;

    constructor(address _chairperson) {
        chairperson = _chairperson;
        votingFinished = false;
        votingOpen = false;
    }

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Solo el presidente puede ejecutar esta funcion.");
        _;
    }

    modifier whenVotingOpen() {
        require(votingOpen && !votingFinished, "La votacion no esta abierta.");
        _;
    }

    function openVoting() external onlyChairperson {
        votingOpen = true;
        votingFinished = false;
    }

    function closeVoting() external onlyChairperson {
        votingOpen = false;
        votingFinished = true;
    }

    // Declaración de funciones abstractas
    function castVote(uint partyId) external virtual;
    function getResults() external view virtual returns (uint[] memory);
}
