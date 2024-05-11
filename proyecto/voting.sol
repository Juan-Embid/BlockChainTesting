// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; // nonReentrant

interface IExecutableProposal {
    // interfaz que implementa el contrato
    function executeProposal(
        uint proposalId,
        uint numVotes,
        uint numTokens
    ) external payable; // external para que solo pueda ser llamado desde fuera del contrato, payable para que pueda recibir ether
}

contract ERC20DAO is ERC20Capped, Ownable {
    constructor(
        string memory name,
        string memory symbol,
        uint maxTokens_
    ) ERC20(name, symbol) Ownable(msg.sender) ERC20Capped(maxTokens_) {}

    function newTokens(address to, uint value) external onlyOwner {
        _mint(to, value);
    }

    function deleteTokens(address from, uint value) external onlyOwner {
        _burn(from, value);
    }

    function maxTokens() external virtual returns (uint) {
        return cap();
    }
}

// contracto de tipo ixecutableProposal para ejecutar propuestas
contract ExecProposal is IExecutableProposal {

    event ProposalExecuted(address prop_addr, uint proposalId, uint numVotes, uint numTokens, uint balance);

    function executeProposal(uint proposalId, uint numVotes, uint numTokens) external payable override {
        emit ProposalExecuted(address(this), proposalId, numVotes, numTokens, address(this).balance);
    }
}

contract QuadraticVoting {
    // zepellin para el token y para el owner ERC20Burnable

    ERC20DAO public votingToken;
    address public owner;
    bool public votingOpen = false;
    uint256 public totalBudget; // será modificado cuando el contrato se apruebe
    uint256 public tokenPrice;
    mapping(address => bool) public registeredParticipants; // a true si el participante está registrado
    mapping(uint256 => Proposal) public proposals; // mapeo de id de propuesta a propuesta
    uint256 public proposalCount; // contador de propuestas

    event ProposalExecutionSucceeded(uint256 proposalId);
    event ProposalExecutionFailed(uint256 proposalId);

    struct Proposal {
        string title;
        string description;
        uint256 budget;
        address payable executor;
        uint256 threshold; // umbral de votos
        bool approved;
        mapping(address => uint256) votesByParticipant; // votos de cada participante
        address[] voters; // votantes
        bool executed; // default false
    }

    // CONSTRUCTOR
    constructor(uint256 _tokenPrice, uint256 _maxTokens) {
        tokenPrice = _tokenPrice;
        owner = msg.sender;
        votingToken = new ERC20DAO("Bitcoin", "BTC", _maxTokens);
    }

    // MODIFICADORES
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // CHECKS AND GETS
    function getERC20() external view returns (address) {
        return address(votingToken);
    }

    function getVotingToken() external view returns (address) {
        return address(votingToken);
    }

    function getProposalBudget(uint proposalId) external view returns (uint) {
        return proposals[proposalId].budget;
    }

    function getTotalProposalVotes(uint proposalId) external view returns (uint) {
        Proposal storage proposal = proposals[proposalId];
        uint totalVotes = 0;
        address[] storage voters = proposal.voters;
        for (uint i = 0; i < voters.length; i++) {
            totalVotes += proposal.votesByParticipant[voters[i]];
        }
        return totalVotes;
    }

    function checkProposalApproved(
        uint proposalId
    ) external view returns (bool) {
        return proposals[proposalId].approved;
    }

    function getTotalBudget() external view returns (uint) {
        return totalBudget;
    }

    function getThreshold(uint proposalId) external view returns (uint) {
        return proposals[proposalId].threshold;
    }

    // Abre voting y solo puede ser ejecutado por el creado del contrato, se le pasa el presupuesto inicial (luego modificado)
    function openVoting() external payable onlyOwner {
        require(!votingOpen, "Voting is already open");
        totalBudget = msg.value;
        votingOpen = true;
    }

    //Se añade participantes con cantidad que se transfiere a votingToken tokens asignados a el
    function addParticipant() external payable {
        require(
            !registeredParticipants[msg.sender],
            "Participant already registered"
        );
        // AVOIDING UPDATES SOLUTION
        registeredParticipants[msg.sender] = true;
        uint256 tokensToMint = msg.value;
        votingToken.transfer(msg.sender, tokensToMint);
    }

    function removeParticipant() external {
        require(
            registeredParticipants[msg.sender],
            "Participant not registered"
        );
        registeredParticipants[msg.sender] = false;
    }

    // Se añade una propuesta con un titulo, descripcion, presupuesto y el ejecutor, se devuelve el id de la propuesta
    function addProposal(
        string memory _title,
        string memory _description,
        uint256 _budget,
        address payable _executor
    ) external returns (uint256) {
        require(votingOpen, "Voting process is not open");
        require(
            registeredParticipants[msg.sender],
            "Only registered participants can add proposals"
        );

        Proposal storage newProposal = proposals[proposalCount];
        newProposal.title = _title;
        newProposal.description = _description;
        newProposal.budget = _budget; // puede ser 0 si es un signaling proposal
        newProposal.executor = _executor;
        newProposal.approved = false;
        newProposal.votesByParticipant[msg.sender] = 0;
        newProposal.voters = new address[](0);
        newProposal.executed = false;

        return proposalCount++;
    }

    function cancelProposal(uint256 _proposalId) external {
        require(votingOpen, "Voting process is not open");
        Proposal storage proposal = proposals[_proposalId];
        require(
            msg.sender == proposal.executor,
            "Only proposal creator can cancel"
        );
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
        require(
            registeredParticipants[msg.sender],
            "Only registered participants can buy tokens"
        );
        uint256 tokensToBuy = msg.value / tokenPrice;
        votingToken.newTokens(msg.sender, tokensToBuy); // crea nuevo tokens
    }

    function sellTokens(uint256 tokenAmount) external {
        require(
            votingToken.balanceOf(msg.sender) >= tokenAmount,
            "Insufficient token balance"
        );
        uint256 etherToReturn = tokenAmount * tokenPrice;
        // AVOIDING UPDATES SOLUTION
        votingToken.deleteTokens(msg.sender, tokenAmount); // eliminamos tokens
        payable(msg.sender).transfer(etherToReturn);
    }

    function getPendingProposals() external view returns (uint256[] memory) {
        require(votingOpen, "Voting process is not open");
        uint256[] memory pendingProposals = new uint256[](proposalCount);
        uint256 counter = 0;
        for (uint256 i = 0; i < proposalCount; i++) {
            if (!proposals[i].approved && proposals[i].budget > 0) {
                // asumimos solo las propuestas no aprobadas y con presupuesto
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
            if (proposals[i].approved && proposals[i].budget > 0) {
                // asumimos solo las propuestas aprobadas y con presupuesto
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
            if (proposals[i].approved && proposals[i].budget == 0) {
                // asumimos solo las propuestas aprobadas y sin presupuesto
                signalingProposals[counter++] = i;
            }
        }
        return signalingProposals;
    }

    // function getProposalInfo(uint256 proposalId) external view returns (string memory title, string memory description, uint256 budget, address executor, bool approved, mapping(address => uint256) memory votesByParticipant, address[] memory voters) {
    //   require(votingOpen, "Voting process is not open");
    //   Proposal storage proposal = proposals[proposalId];
    //   return (proposal.title, proposal.description, proposal.budget, proposal.executor, proposal.approved, proposal.votesByParticipant, proposal.voters);
    // }
    function getProposalVoteByParticipant(
        uint256 proposalId,
        address participant
    ) external view returns (uint256) {
        return proposals[proposalId].votesByParticipant[participant];
    }
    function getProposalVoters(
        uint256 proposalId
    ) external view returns (address[] memory) {
        return proposals[proposalId].voters;
    }
    function stake(uint256 proposalId, uint256 numVotes) external {
        require(votingOpen, "Voting is not open");
        require(
            registeredParticipants[msg.sender],
            "Not a registered participant"
        );
        require(proposalId < proposalCount, "Invalid proposal ID");

        Proposal storage proposal = proposals[proposalId];
        uint256 currentVotes = proposal.votesByParticipant[msg.sender];
        uint256 newTotalVotes = currentVotes + numVotes;
        uint256 costForNewVotes = (newTotalVotes * newTotalVotes) -
            (currentVotes * currentVotes);

        require(
            votingToken.balanceOf(msg.sender) >= costForNewVotes,
            "Insufficient tokens for voting"
        ); // comprobamos que tiene suficientes tokens para poder votar
        // Según la práctica: Nevertheless, the threshold of a proposal must only be computed and checked when the proposal receives votes.
        uint256 nPendingProposals = 0;
        for (uint256 i = 0; i < proposalCount; i++) {
            if (!proposals[i].approved && proposals[i].budget > 0) {
                nPendingProposals++;
            }
        }
        // proposal.threshold = ((0.2 + (proposal.budget / totalBudget)) * proposal.voters.length) + nPendingProposals; // umbral de votos
        // Scaling factor of 1000 (for three decimal places of precision)
        uint256 scalingFactor = 1000;
        uint256 weightedBudget = (proposal.budget * scalingFactor) / totalBudget;
        proposal.threshold = ((200 + weightedBudget) * proposal.voters.length) / scalingFactor + nPendingProposals;

        // AVOIDING UPDATES SOLUTION
        proposal.votesByParticipant[msg.sender] = newTotalVotes; // actualizamos los votos del participante
        votingToken.transferFrom(msg.sender, address(this), costForNewVotes); // desde el que llama al contrato a este contrato por el valor de costForNewVotes

        if (newTotalVotes >= proposal.threshold) {
            _checkAndExecuteProposal(proposalId);
        }
    }

    function withdrawFromProposal(
        uint256 proposalId,
        uint256 numVotes
    ) external {
        require(votingOpen, "Voting is not open");
        Proposal storage proposal = proposals[proposalId];
        require(
            !proposal.approved,
            "Cannot withdraw from an approved proposal"
        );

        uint256 currentVotes = proposal.votesByParticipant[msg.sender]; // Current votes del que llama la función
        require(currentVotes >= numVotes, "Not enough votes to withdraw");

        uint256 tokenWithdrawMoney = (currentVotes * currentVotes) -
            (numVotes * numVotes);

        // AVOIDING UPDATES SOLUTION
        proposal.votesByParticipant[msg.sender] = currentVotes - numVotes; // actualizamos el estado
        votingToken.transfer(msg.sender, tokenWithdrawMoney); // llamada externa
    }

    function _checkAndExecuteProposal(uint256 proposalId) internal {
        // THRESHOLD
        Proposal storage proposal = proposals[proposalId];

        if (!proposal.approved && !proposal.executed && proposal.budget > 0) {
            // comprobamos que no es signaling

            uint256 budget = proposal.budget;
            require(
                address(this).balance >= budget,
                "Insufficient funds for execution"
            ); // comprobamos si hay suficiente presupuesto para ejecutar la propuesta

            uint256 totalVotes = 0;
            for (uint256 i = 0; i < proposal.voters.length; i++) {
                address voter = proposal.voters[i];
                uint256 votes = proposal.votesByParticipant[voter];
                uint256 tokensToConsume = votes * votes;

                // AVOIDING UPDATES SOLUTION
                votingToken.deleteTokens(voter, tokensToConsume); // burn de los tokens stakeados
                totalVotes += votes;
            }
            // AVOIDING UPDATES SOLUTION
            totalBudget -= budget; // total budget se reduce en el presupuesto de la propuesta

            try
                IExecutableProposal(proposal.executor).executeProposal{
                    value: budget,
                    gas: 100000
                }(proposalId, totalVotes, budget)
            {
                proposal.approved = true;
                proposal.executed = true;
                emit ProposalExecutionSucceeded(proposalId);
            } catch {
                emit ProposalExecutionFailed(proposalId);
            }
        }
    }

    function closeVoting() external onlyOwner {
        // se tienen que ejecutar todas las propuestas signaling
        require(votingOpen, "Voting is already closed");
        votingOpen = false;

        // Procesar cada propuesta al cerrar la votación
        for (uint256 i = 0; i < proposalCount; i++) {
            Proposal storage proposal = proposals[i];
            if (!proposal.approved) {
                // Devolver tokens a los votantes de propuestas no aprobadas
                for (uint256 j = 0; j < proposal.voters.length; j++) {
                    address voter = proposal.voters[j];
                    uint256 votes = proposal.votesByParticipant[voter];
                    uint256 tokensToReturn = votes * votes; // Devolución cuadrática
                    votingToken.transfer(voter, tokensToReturn);
                    // AVOIDING UPDATES SOLUTION
                    proposal.votesByParticipant[voter] = 0; 
                }
            } else {
                // Asegurarse de que las propuestas aprobadas se ejecuten
                if (!proposal.executed) {
                    _checkAndExecuteProposal(i);
                }
            }

            // Limpiar datos de votantes para liberar espacio en storage y evitar reentrancy issues
            delete proposal.voters;
        }

        // Transferir el presupuesto no gastado al propietario del contrato
        // AVOIDING UPDATES SOLUTION
        uint256 remainingBudget = totalBudget;
        totalBudget = 0;
        payable(owner).transfer(remainingBudget);
    }
}
