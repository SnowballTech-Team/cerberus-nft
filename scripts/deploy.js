// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')

async function main() {
  // const Cdoge = await hre.ethers.getContractFactory('Cdoge')
  // const doge = await Cdoge.deploy('0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648', '0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  // await doge.deployed()

  // const Berus = await hre.ethers.getContractFactory('Berus')
  // const berus = await Berus.deploy('0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648', '0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  // await berus.deployed()

  const Level = await hre.ethers.getContractFactory('LevelUtil')
  const level = await Level.deploy()
  await level.deployed()

  // const MDC = await hre.ethers.getContractFactory('MillionDogeClub')
  // const mdc = await MDC.deploy()
  // await mdc.deployed()

  const Repository = await hre.ethers.getContractFactory('MillionDogeClubRepository')
  let cdoge = '0x81e4605c4058b5017b910355F4A1396dC9A7C97A'
  let berus = '0x9D559f5ea3Ada1B005F313B0D299817B0C1F37A9'
  let mdc = '0x153d3F1FCE5BfB50752fd3F6D44EA20522952e2a'
  const repository = await Repository.deploy(cdoge, berus, mdc, level.address)
  await repository.deployed()

  // console.log('Cdoge deployed to:', doge.address)
  // console.log('Berus deployed to:', berus.address)
  console.log('level deployed to:', level.address)
  // console.log('MDC deployed to:', mdc.address)
  console.log('repository deployed to:', repository.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
