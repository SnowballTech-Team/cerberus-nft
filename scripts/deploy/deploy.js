// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')
require('dotenv').config({ path: '.env' })

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

  const MDC = await hre.ethers.getContractFactory('MillionDogeClub')
  const mdc = await MDC.deploy()
  await mdc.deployed()

  let _doge = '0xFB21be76CB7f33c11D0892793b969400E6E695fE'
  let _berus = '0x3004739f3B9b870e012d367A42C39962Bd2A2748'
  let _level = '0xb5754020ae3B287bD4e633d8135356C9b4d2e027'
  const Repository = await hre.ethers.getContractFactory('MillionDogeClubRepository')
  const repository = await Repository.deploy(process.env.CDOGE, process.env.BERUS, mdc.address, level.address)
  // const repository = await Repository.deploy(doge.address, berus.address, mdc.address, level.address)
  await repository.deployed()

  // uint256 _rate,
  // address _pro,
  // address _level,
  // address _berus,
  // address _mdc,
  // address _referral
  let _rate = ethers.utils.parseEther('1')
  let _pro = '0x6671117d1f14849D5a85Ec9c243797af8F62Dd12'
  let _mdc = '0x6E3EDd7648BE18a1149987C94A2f5e0355E3A46c'
  let _ref = '0x1915359d50450892575154Fa847E511fb24F43d2'
  const Pool = await hre.ethers.getContractFactory('BerusPool')
  const pool = await Pool.deploy(_rate, repository.address, level.address, process.env.BERUS, mdc.address, process.env.REF)
  await pool.deployed()

  // const Exchange = await hre.ethers.getContractFactory('Exchange')
  // const change = await Exchange.deploy(pool.address, process.env.CDOGE)
  // await change.deployed()

  // Cdoge deployed to: 0xFB21be76CB7f33c11D0892793b969400E6E695fE
  // Berus deployed to: 0x3004739f3B9b870e012d367A42C39962Bd2A2748
  // level deployed to: 0xC2D5A69B38B0a6FcDCF26A1A8A371fB677772349
  // MDC deployed to: 0x06C96B856c9815f4DD850dBe5B5bA08A710A46AF
  // repository deployed to: 0xbD74399966a0273b71DDA2ff439cfC5D48A6C493
  // Pool deployed to: 0x126a148426ECd2ca4c566f659E953F5479f26CE1

  // console.log('Cdoge deployed to:', doge.address)
  // console.log('Berus deployed to:', berus.address)
  console.log('level deployed to:', level.address)
  console.log('MDC deployed to:', mdc.address)
  console.log('repository deployed to:', repository.address)
  console.log('Pool deployed to:', pool.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
