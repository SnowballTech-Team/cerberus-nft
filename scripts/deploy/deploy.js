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

  // const Level = await hre.ethers.getContractFactory('LevelUtil')
  // const level = await Level.deploy()
  // await level.deployed()

  const MDC = await hre.ethers.getContractFactory('MillionDogeClub')
  const mdc = await MDC.deploy()
  await mdc.deployed()

  let _doge = '0xFB21be76CB7f33c11D0892793b969400E6E695fE'
  let _berus = '0x3004739f3B9b870e012d367A42C39962Bd2A2748'
  let _level = '0xb5754020ae3B287bD4e633d8135356C9b4d2e027'
  // const Repository = await hre.ethers.getContractFactory('MillionDogeClubRepository')
  // const repository = await Repository.deploy(_doge, _berus, mdc.address, _level)
  // const repository = await Repository.deploy(doge.address, berus.address, mdc.address, level.address)
  // await repository.deployed()

  // uint256 _rate,
  // address _pro,
  // address _level,
  // address _berus,
  // address _mdc,
  // address _referral
  let _rate = ethers.utils.parseEther('1')
  let _pro = '0x6671117d1f14849D5a85Ec9c243797af8F62Dd12'
  let _mdc = '0x6E3EDd7648BE18a1149987C94A2f5e0355E3A46c'
  let _ref = '0x178fe3900B3ef39eBE0E62E1f1dB2f6b24Fdc2Cb'
  const Pool = await hre.ethers.getContractFactory('CBerusPool')
  const pool = await Pool.deploy(_rate, _pro, _level, _berus, _mdc, _ref)
  await pool.deployed()

  // const Exchange = await hre.ethers.getContractFactory('Exchange')
  // const change = await Exchange.deploy(pool.address, _doge)
  // await change.deployed()

  // Cdoge deployed to: 0xFB21be76CB7f33c11D0892793b969400E6E695fE
  // Berus deployed to: 0x3004739f3B9b870e012d367A42C39962Bd2A2748
  // level deployed to: 0xb5754020ae3B287bD4e633d8135356C9b4d2e027
  // MDC deployed to: 0x6E3EDd7648BE18a1149987C94A2f5e0355E3A46c
  // repository deployed to: 0x6671117d1f14849D5a85Ec9c243797af8F62Dd12
  // Pool deployed to: 0x593a553B155c29765280294888882977c7d6dccA

  // console.log('Cdoge deployed to:', doge.address)
  // console.log('Berus deployed to:', berus.address)
  // console.log('level deployed to:', level.address)
  // console.log('MDC deployed to:', mdc.address)
  // console.log('repository deployed to:', repository.address)
  console.log('Pool deployed to:', pool.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
