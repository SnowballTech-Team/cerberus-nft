// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')
require('dotenv').config({ path: '.env' })

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()
  console.log('deployer:' + deployer.address)

  const mdc = await ethers.getContractAt('MillionDogeClub', process.env.MDC, signer)
  const repository = await ethers.getContractAt('MillionDogeClubRepository', process.env.REPO, signer)

  // process.env.FACTORY
  let manageRepoTx = await repository.addManage(process.env.MARKET)
  console.log('manageRepoTx:' + manageRepoTx.hash)
  await manageRepoTx.wait()

  let manageMdcTx = await mdc.addManage(process.env.REF)
  console.log('manageMdcTx:' + manageMdcTx.hash)
  await manageMdcTx.wait()
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
