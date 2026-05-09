import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with:", deployer.address);

  const Voting = await ethers.getContractFactory("ConfidentialVoting");
  const voting = await Voting.deploy("Main Proposal", Math.floor(Date.now()/1000) + 86400);
  await voting.waitForDeployment();

  console.log("ConfidentialVoting deployed to:", voting.target);
}

main().catch(console.error);
