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
  let cdoge = '0x81e4605c4058b5017b910355F4A1396dC9A7C97A'
  let berus = '0x9D559f5ea3Ada1B005F313B0D299817B0C1F37A9'
  let mdc = '0x153d3F1FCE5BfB50752fd3F6D44EA20522952e2a'
  let level = '0xb5754020ae3B287bD4e633d8135356C9b4d2e027'
  const repository = await Repository.deploy(cdoge, berus, mdc, level)
  await repository.deployed()

  // repository deployed to: 0x39F80061ae7a5d501bf25D9320F6934e7ED6B088
  console.log('repository deployed to:', repository.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
