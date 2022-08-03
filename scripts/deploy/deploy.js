// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')

async function main() {
  const Cdoge = await hre.ethers.getContractFactory('Cdoge')
  const doge = await Cdoge.deploy('0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648', '0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  await doge.deployed()

  const Berus = await hre.ethers.getContractFactory('Berus')
  const berus = await Berus.deploy('0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648', '0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  await berus.deployed()

  const Level = await hre.ethers.getContractFactory('LevelUtil')
  const level = await Level.deploy()
  await level.deployed()

  const MDC = await hre.ethers.getContractFactory('MillionDogeClub')
  const mdc = await MDC.deploy()
  await mdc.deployed()

  const Repository = await hre.ethers.getContractFactory('MillionDogeClubRepository')
  const repository = await Repository.deploy(doge.address, berus.address, mdc.address, level.address)
  await repository.deployed()

  // Cdoge deployed to: 0xFB21be76CB7f33c11D0892793b969400E6E695fE
  // Berus deployed to: 0x3004739f3B9b870e012d367A42C39962Bd2A2748
  // level deployed to: 0x2ce2c18B4bbeD86eBf7DaE5dF8b0D80f24b7b0D7
  // MDC deployed to: 0xeE077A41f5064D4169C63cb9B2353b96B4b14266
  // repository deployed to: 0xC40Daa74743Fb03a0654b24b2DE3F72B5508f90e

  console.log('Cdoge deployed to:', doge.address)
  console.log('Berus deployed to:', berus.address)
  console.log('level deployed to:', level.address)
  console.log('MDC deployed to:', mdc.address)
  console.log('repository deployed to:', repository.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
