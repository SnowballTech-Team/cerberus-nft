// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')

async function main() {
  const Mint = await hre.ethers.getContractFactory('Mint')
  const mint = await Mint.deploy('0xC40Daa74743Fb03a0654b24b2DE3F72B5508f90e', '0xeE077A41f5064D4169C63cb9B2353b96B4b14266')
  await mint.deployed()

  // Mint deployed to: 0x81e4605c4058b5017b910355F4A1396dC9A7C97A
  console.log('Mint deployed to:', mint.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
