// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { FHE, euint64, ebool, externalEuint64 } from "@fhevm/solidity/lib/FHE.sol";
import { ZamaEthereumConfig } from "@fhevm/solidity/config/ZamaConfig.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract ConfidentialVoting is ZamaEthereumConfig, Ownable2Step {
    string public proposalTitle;
    uint256 public votingDeadline;
    bool public votingEnded;

    mapping(uint8 => euint64) private voteCounts;
    mapping(address => ebool) private hasVoted;

    mapping(address => bool) public isVoterWhitelisted;

    event VoteCast(address voter, uint8 option);
    event VotingEnded(uint256 timestamp);
    event PublicTallyMadeAvailable();

    constructor(string memory _title, uint256 _deadline) Ownable2Step() {
        proposalTitle = _title;
        votingDeadline = _deadline;
        for (uint8 i = 0; i < 5; i++) {
            voteCounts[i] = FHE.asEuint64(0);
            FHE.allowThis(voteCounts[i]);
        }
    }

    function whitelistVoter(address voter) external onlyOwner {
        isVoterWhitelisted[voter] = true;
    }

    function castVote(externalEuint64 encryptedOption, bytes calldata inputProof) external {
        require(block.timestamp < votingDeadline, "Voting ended");
        require(isVoterWhitelisted[msg.sender], "Not whitelisted");

        euint64 option = FHE.fromExternal(encryptedOption, inputProof);
        FHE.allowThis(option);

        // Simplified vote logic (expand as needed)
        voteCounts[uint8(FHE.decrypt(option))] = FHE.add(voteCounts[uint8(FHE.decrypt(option))], FHE.asEuint64(1));

        hasVoted[msg.sender] = FHE.asEbool(true);
        FHE.allowThis(hasVoted[msg.sender]);

        emit VoteCast(msg.sender, uint8(FHE.decrypt(option)));
    }

    function endVoting() external onlyOwner {
        require(!votingEnded, "Already ended");
        votingEnded = true;
        emit VotingEnded(block.timestamp);
    }

    function makeTallyPublic() external onlyOwner {
        require(votingEnded, "Voting not ended");
        for (uint8 i = 0; i < 5; i++) {
            FHE.makePubliclyDecryptable(voteCounts[i]);
        }
        emit PublicTallyMadeAvailable();
    }

    function getEncryptedVoteCount(uint8 option) external view returns (euint64) {
        return voteCounts[option];
    }
}
