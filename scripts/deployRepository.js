// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000)
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS
  const lockedAmount = hre.ethers.utils.parseEther('1')

  const Repository = await hre.ethers.getContractFactory('MillionDogeClubRepository')
  const repository = await Repository.deploy('0xc9F83DD071241C83FF1A6ee9c39eb4D00640B151', '0x6E3EDd7648BE18a1149987C94A2f5e0355E3A46c')
  await repository.deployed()

  // repository deployed to: 0x6671117d1f14849D5a85Ec9c243797af8F62Dd12
  console.log('repository deployed to:', repository.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
