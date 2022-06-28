// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  //const WCUBE = '0xb9164670a2f388d835b868b3d0d441fa1be5bb00'; // cube-testnet
  const WCUBE = '0x9d3f61338d6eb394e378d28c1fd17d5909ac6591'; // cube-mainnet
  const MerkleDistributor = await ethers.getContractFactory("MerkleDistributor");
  const merkleDistributor = await MerkleDistributor.deploy(WCUBE);

  await merkleDistributor.deployed();

  console.log("Greeter deployed to:", merkleDistributor.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
