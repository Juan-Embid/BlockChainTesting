// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IExecutableProposal { // interfaz que implementa el contrato
    function executeProposal(uint proposalId, uint numVotes, uint numTokens) external payable; // external para que solo pueda ser llamado desde fuera del contrato, payable para que pueda recibir ether
}

contract QuadraticVoting {
    ERC20 public votingToken;
    address public owner;
    bool public votingOpen = false;
    uint256 public totalBudget; // será modificado cuando el contrato se apruebe

    mapping(address => bool) public registeredParticipants; // a true si el participante está registrado
    mapping(uint256 => Proposal) public proposals; // mapeo de id de propuesta a propuesta
    uint256 public proposalCount; // contador de propuestas

    struct Proposal {
        string title;
        string description;
        uint256 budget;
        address payable executor;
        bool approved;
        mapping(address => uint256) votesByParticipant; // votos de cada participante
        address[] voters; // votantes
    }

    //Inicializacion del contrato
    constructor(uint256 _tokenPrice, uint256 _maxTokens) {
        owner = msg.sender;
        votingToken = new ERC20("CarlosJuanToken", "CJT");
    }

    modifier onlyOwner() {
      require(msg.sender == owner, "Only owner can perform this action");
      _;
    }
    // Abre voting y solo puede ser ejecutado por el creado del contrato, se le pasa el presupuesto inicial (luego modificado)
    function openVoting(uint256 _initialBudget) external onlyOwner { 
      require(!votingOpen, "Voting is already open");
      totalBudget = _initialBudget;
      votingOpen = true;
    }
    
    //Se añade participantes con cantidad que se transfiere a votingToken tokens asignados a el
    function addParticipant() external payable {
      require(!registeredParticipants[msg.sender], "Participant already registered");
      registeredParticipants[msg.sender] = true;
      uint256 tokensToMint = msg.value; 
      votingToken.transfer(msg.sender, tokensToMint);
    }

    function removeParticipant() external {
        require(registeredParticipants[msg.sender], "Participant not registered");
        registeredParticipants[msg.sender] = false;
    }

    // Se añade una propuesta con un titulo, descripcion, presupuesto y el ejecutor, se devuelve el id de la propuesta
    function addProposal(string memory _title, string memory _description, uint256 _budget, address payable _executor) external returns (uint256) {
      require(votingOpen, "Voting process is not open");
      require(registeredParticipants[msg.sender], "Only registered participants can add proposals");

      proposals[proposalCount] = Proposal({
          title: _title,
          description: _description,
          budget: _budget, // puede ser 0 si es un signaling proposal
          executor: _executor,
          approved: false,
          votesByParticipant: new mapping(address => uint256)(),
          voters: new address[](0)
      });
      return proposalCount++;
    }

    function cancelProposal(uint256 _proposalId) external {
        require(votingOpen, "Voting process is not open");
        Proposal storage proposal = proposals[_proposalId];
        require(msg.sender == proposal.executor, "Only proposal creator can cancel");
        require(!proposal.approved, "Approved proposal cannot be cancelled");

        // Iterate through all voters and refund their tokens
        for (uint256 i = 0; i < proposal.voters.length; i++) {
            address voter = proposal.voters[i];
            uint256 votes = proposal.votesByParticipant[voter];
            uint256 tokensToRefund = votes * votes; // refund cuadratico
            votingToken.transfer(voter, tokensToRefund);
            proposal.votesByParticipant[voter] = 0; // Reset votes to zero after refunding
        }

        delete proposal.voters; // se borran los votantes
        delete proposals[_proposalId]; // la saco de mi diccionario de proposals
    }

    function buyTokens() external payable {
        require(registeredParticipants[msg.sender], "Only registered participants can buy tokens");
        uint256 tokensToBuy = msg.value / tokenPrice; 
        votingToken.mint(msg.sender, tokensToBuy); // crea nuevo tokens
    }

    function sellTokens(uint256 tokenAmount) external {
      require(votingToken.balanceOf(msg.sender) >= tokenAmount, "Insufficient token balance");
      uint256 etherToReturn = tokenAmount * tokenPrice;
      votingToken.burn(msg.sender, tokenAmount); // eliminamos tokens
      payable(msg.sender).transfer(etherToReturn);
    }

    function getERC20() external view returns (address) {
        return address(votingToken);
    }

    function getPendingProposals() external view returns (uint256[] memory) {
      require(votingOpen, "Voting process is not open");
      uint256[] memory pendingProposals = new uint256[](proposalCount);
      uint256 counter = 0;
      for (uint256 i = 0; i < proposalCount; i++) {
          if (!proposals[i].approved && proposals[i].budget > 0) { // asumimos solo las propuestas no aprobadas y con presupuesto
              pendingProposals[counter++] = i;
          }
      }
      return pendingProposals;
    }

    function getApprovedProposals() external view returns (uint256[] memory) {
      require(votingOpen, "Voting process is not open");
      uint256[] memory approvedProposals = new uint256[](proposalCount);
      uint256 counter = 0;
      for (uint256 i = 0; i < proposalCount; i++) {
          if (proposals[i].approved && proposals[i].budget > 0) { // asumimos solo las propuestas aprobadas y con presupuesto
              approvedProposals[counter++] = i;
          }
      }
      return approvedProposals;
    }

    function getSignalingProposals() external view returns (uint256[] memory) {
      require(votingOpen, "Voting process is not open");
      uint256[] memory signalingProposals = new uint256[](proposalCount);
      uint256 counter = 0;
      for (uint256 i = 0; i < proposalCount; i++) {
          if (proposals[i].approved && proposals[i].budget == 0) { // asumimos solo las propuestas aprobadas y sin presupuesto
              signalingProposals[counter++] = i;
          }
      }
      return signalingProposals;
    }

    function getProposalInfo(uint256 proposalId) external view returns (string memory title, string memory description, uint256 budget, address executor, bool approved, mapping(address => uint256) memory votesByParticipant, address[] memory voters) {
      require(votingOpen, "Voting process is not open");
      Proposal storage proposal = proposals[proposalId];
      return (proposal.title, proposal.description, proposal.budget, proposal.executor, proposal.approved, proposal.votesByParticipant, proposal.voters);
    }

    function stake(uint256 proposalId, uint256 numVotes) external {
        require(votingOpen, "Voting is not open");
        require(registeredParticipants[msg.sender], "Not a registered participant");
        require(proposalId < proposalCount, "Invalid proposal ID");

        Proposal storage proposal = proposals[proposalId];
        uint256 currentVotes = proposal.votesByParticipant[msg.sender];
        uint256 newTotalVotes = currentVotes + numVotes;
        uint256 costForNewVotes = (newTotalVotes * newTotalVotes) - (currentVotes * currentVotes);

        require(votingToken.balanceOf(msg.sender) >= costForNewVotes, "Insufficient tokens for voting"); // comprobamos que tiene suficientes tokens para poder votar

        votingToken.transferFrom(msg.sender, getERC20(), costForNewVotes); // desde el que llama al contrato a este contrato por el valor de costForNewVotes

        proposal.votesByParticipant[msg.sender] = newTotalVotes; // actualizamos los votos del participante
    }

    function withdrawFromProposal(uint256 proposalId, uint256 numVotes) external {
        require(votingOpen, "Voting is not open");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.approved, "Cannot withdraw from an approved proposal");

        uint256 currentVotes = proposal.votesByParticipant[msg.sender];// Current votes del que llama la función
        require(currentVotes >= numVotes, "Not enough votes to withdraw");
        
        uint256 tokenWithdrawMoney = (currentVotes * currentVotes) - (numVotes * numVotes);
        proposal.votesByParticipant[msg.sender] = currentVotes - numVotes;
        votingToken.transfer(msg.sender, tokenWithdrawMoney);
    }

    // TODO: Revisar
    function _checkAndExecuteProposal(uint256 proposalId) internal {
        Proposal storage proposal = proposals[proposalId];
        uint256 totalVotes = 0;
        for (uint256 i = 0; i < proposal.voters.length; i++) {
            totalVotes += proposal.votesByParticipant[proposal.voters[i]];
        }

        // Example threshold calculation (needs proper implementation based on actual requirements)
        if (totalVotes >= threshold) {
            proposal.approved = true;
            IExecutableProposal(proposal.executor).executeProposal(proposalId, totalVotes, proposal.budget);
            // Adjust budget if necessary, handle token accounting, etc.
        }
    }

    // TODO: Revisar
    function closeVoting() external onlyOwner {
        require(votingOpen, "Voting is already closed");
        votingOpen = false;

        // Handle each proposal
        for (uint256 i = 0; i < proposalCount; i++) {
            Proposal storage proposal = proposals[i];
            if (!proposal.approved) {
                // Return tokens to voters
                for (uint256 j = 0; j < proposal.voters.length; j++) {
                    address voter = proposal.voters[j];
                    uint256 votes = proposal.votesByParticipant[voter];
                    uint256 tokensToReturn = calculateVoteCost(0, votes);
                    votingToken.transfer(voter, tokensToReturn);
                    proposal.votesByParticipant[voter] = 0;
                }
            } else {
                // Ensure execution of approved proposals
                if (!proposal.executed) {
                    _checkAndExecuteProposal(i);
                }
            }
        }
    }


}