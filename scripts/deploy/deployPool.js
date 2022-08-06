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
  let _rate = ethers.utils.parseEther('1')
  let _pro = '0x8f87Ef7FBb1e3Eb30F1D3c845Da579df66C3EB3e'
  let _level = '0xb5754020ae3B287bD4e633d8135356C9b4d2e027'
  let _mdc = '0xeE077A41f5064D4169C63cb9B2353b96B4b14266'
  const pool = await Pool.deploy(_rate, _pro, _level, _mdc)
  await pool.deployed()

  // Pool deployed to: 0x8ea8CaC57885E6c4CD963F2020075aAe83a3218b
  console.log('Pool deployed to:', pool.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
