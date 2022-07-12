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

  const Cdoge = await hre.ethers.getContractFactory('Cdoge')
  const doge = await Cdoge.deploy('0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648', '0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  await doge.deployed()

  const Berus = await hre.ethers.getContractFactory('Berus')
  const berus = await Berus.deploy('0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648', '0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  await berus.deployed()

  // Cdoge deployed to: 0xc9F83DD071241C83FF1A6ee9c39eb4D00640B151
  // Berus deployed to: 0x6E3EDd7648BE18a1149987C94A2f5e0355E3A46c
  console.log('Cdoge deployed to:', doge.address)
  console.log('Berus deployed to:', berus.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
