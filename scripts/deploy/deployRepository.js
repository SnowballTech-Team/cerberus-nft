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
  let cdoge = '0xFB21be76CB7f33c11D0892793b969400E6E695fE'
  let berus = '0x3004739f3B9b870e012d367A42C39962Bd2A2748'
  let mdc = '0xeE077A41f5064D4169C63cb9B2353b96B4b14266'
  let level = '0xb5754020ae3B287bD4e633d8135356C9b4d2e027'
  const repository = await Repository.deploy(cdoge, berus, mdc, level)
  await repository.deployed()

  // repository deployed to: 0x8f87Ef7FBb1e3Eb30F1D3c845Da579df66C3EB3e
  console.log('repository deployed to:', repository.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
