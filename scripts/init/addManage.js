// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()
  console.log('deployer:' + deployer.address)

  const repository = await ethers.getContractAt('MillionDogeClubRepository', '0xC40Daa74743Fb03a0654b24b2DE3F72B5508f90e', signer)

  // process.env.FACTORY
  let manageMinerTx = await repository.addManage('0x4ddEf3c413370A4D6CB35595503604CFacD823D0')
  console.log('manageMinerTx:' + manageMinerTx.hash)
  await manageMinerTx.wait()
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
