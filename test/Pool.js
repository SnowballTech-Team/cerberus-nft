const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  const pool = await ethers.getContractAt('CBerusPool', '0x0765cAfCfD27e7BB027c32363b3F491baBA5c97b', signer)

  let rate = await pool.cberusPerBlock()
  console.log('rate: ' + rate)

  // let stakeTx = await pool.stake(1)
  // console.log('stakeTx:' + stakeTx.hash)
  // await stakeTx.wait()

  // let unStakeTx = await pool.unStake(1)
  // console.log('unStakeTx:' + unStakeTx.hash)
  // await unStakeTx.wait()

  // let amount = await pool.earned(1)
  // console.log('amount:' + amount)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
