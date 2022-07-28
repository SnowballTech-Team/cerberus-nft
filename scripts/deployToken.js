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
  const doge = await Cdoge.deploy('0xE13175C36da232ab9AEFc33f841eeC9b697BBf2a', '0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  await doge.deployed()

  const Berus = await hre.ethers.getContractFactory('Berus')
  const berus = await Berus.deploy('0xE13175C36da232ab9AEFc33f841eeC9b697BBf2a', '0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  await berus.deployed()

  // Cdoge deployed to: 0xbA1403c0a2ad71Aa4e1Ad485420Fe5EA7FaB4689
  // Berus deployed to: 0xcBC5894411f388697FdD60254e3a3c69B694bbb3
  console.log('Cdoge deployed to:', doge.address)
  console.log('Berus deployed to:', berus.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
