import { expect } from "chai";
import { ethers } from "hardhat";
import { createEncryptedInput } from "@zama-fhe/sdk";

describe("ConfidentialVoting", function () {
  it("Should allow encrypted voting", async function () {
    const Voting = await ethers.getContractFactory("ConfidentialVoting");
    const voting = await Voting.deploy("Test Proposal", Math.floor(Date.now()/1000) + 3600);
    await voting.waitForDeployment();

    const [voter] = await ethers.getSigners();
    await voting.whitelistVoter(voter.address);

    const input = await createEncryptedInput(await voting.getAddress(), voter.address);
    input.add64(1n);
    const { ciphertexts, proof } = await input.generateProof();

    await voting.connect(voter).castVote(ciphertexts[0], proof);

    console.log("✅ Encrypted vote cast successfully");
  });
});
