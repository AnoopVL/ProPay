const hre = require("hardhat");

async function main() {
  const Propay = await hre.ethers.getContractFactory("Propay");
  const propay = await Propay.deploy();

  await propay.deployed();
  console.log("Propay is deployed to: ", propay.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
