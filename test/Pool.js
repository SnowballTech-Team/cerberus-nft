const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  const pool = await ethers.getContractAt('CBerusPool', '0x866FaFC86e63A09D99bFdB243491F80622424758', signer)
  const mdc = await ethers.getContractAt('MillionDogeClub', '0xeE077A41f5064D4169C63cb9B2353b96B4b14266', signer)

  let rate = await pool.cberusPerBlock()
  console.log('rate: ' + rate)

  // approve
  // let approveTx = await mdc.approve('0x866FaFC86e63A09D99bFdB243491F80622424758', 3)
  // console.log('approveTx:' + approveTx.hash)
  // await approveTx.wait()

  // let stakeTx = await pool.stake(3)
  // console.log('stakeTx: ' + stakeTx.hash)
  // await stakeTx.wait()

  let balance = await pool.balanceOfOwner(deployer.address)
  console.log('balance: ' + balance)

  let totalHashRate = await pool.getTotalHashRate()
  console.log('totalHashRate: ' + totalHashRate)
  let reward = await pool.earned()
  console.log('reward: ' + reward)

  let unStakeTx = await pool.unStake(3)
  console.log('unStakeTx: ' + unStakeTx.hash)
  await unStakeTx.wait()

  let info = await pool.stakeInfo('0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  console.log('info:' + info)

  let stored = await pool.rewardPerHashRateStored()
  console.log('stored:' + stored)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
