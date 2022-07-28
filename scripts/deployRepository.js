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
  let cdoge = '0xbA1403c0a2ad71Aa4e1Ad485420Fe5EA7FaB4689'
  let berus = '0xcBC5894411f388697FdD60254e3a3c69B694bbb3'
  let mdc = '0x153d3F1FCE5BfB50752fd3F6D44EA20522952e2a'
  let level = '0x3C93b51c4D82AAB48DF7C45EF4Ff76471f05D6E4'
  const repository = await Repository.deploy(cdoge, berus, mdc, level)
  await repository.deployed()

  // repository deployed to: 0x52c2ABe3039F994574bae93317f5Cb77aC8d736c
  console.log('repository deployed to:', repository.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
