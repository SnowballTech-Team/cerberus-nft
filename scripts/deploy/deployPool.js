// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers } = require('hardhat')
const hre = require('hardhat')

async function main() {
  const Pool = await hre.ethers.getContractFactory('CBerusPool')

  // level deployed to:
  // MDC deployed to:
  // repository deployed to:
  // uint256 _rate,
  // address _pro,
  // address _level,
  // address _berus,
  // address _mdc,
  // address _referral
  let _rate = ethers.utils.parseEther('1')
  let _pro = '0x6671117d1f14849D5a85Ec9c243797af8F62Dd12'
  let _level = '0xb5754020ae3B287bD4e633d8135356C9b4d2e027'
  let _berus = '0x3004739f3B9b870e012d367A42C39962Bd2A2748'
  let _mdc = '0x6E3EDd7648BE18a1149987C94A2f5e0355E3A46c'
  let _ref = '0xA7E0730c1098Fd820269914348E47690555fc123'
  const pool = await Pool.deploy(_rate, _pro, _level, _berus, _mdc, _ref)
  await pool.deployed()

  // Pool deployed to: 0x811b0e5f8e41A6C3A2ff5426782a85D5FfA40A08
  console.log('Pool deployed to:', pool.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
