const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  // const pool = await ethers.getContractAt('CBerusPool', '0x811b0e5f8e41A6C3A2ff5426782a85D5FfA40A08', signer)
  const pool = await ethers.getContractAt('CBerusPool', '0x5EcCBfC2643008cb8Ec162cBe35cEF2e1D69806B', signer)
  const mdc = await ethers.getContractAt('MillionDogeClub', '0x6E3EDd7648BE18a1149987C94A2f5e0355E3A46c', signer)

  let rate = await pool.cberusPerBlock()
  console.log('rate: ' + rate)

  // let manageTx = await pool.addManage(deployer.address)
  // console.log('manageTx: ' + manageTx.hash)
  // await manageTx.wait()

  // approve
  // let approveTx = await mdc.approve('0x5EcCBfC2643008cb8Ec162cBe35cEF2e1D69806B', 6)
  // console.log('approveTx:' + approveTx.hash)
  // await approveTx.wait()

  // let stakeTx = await pool.stake(6)
  // console.log('stakeTx: ' + stakeTx.hash)
  // await stakeTx.wait()

  let balance = await pool.balanceOfOwner(deployer.address)
  console.log('balance: ' + balance)

  let totalHashRate = await pool.getTotalHashRate()
  console.log('totalHashRate: ' + totalHashRate)

  let reward = await pool.earned()
  console.log('reward: ' + reward)

  let unStakeTx = await pool.unStake(6)
  console.log('unStakeTx: ' + unStakeTx.hash)
  await unStakeTx.wait()

  // let testTx = await pool.test()
  // console.log('testTx: ' + testTx.hash)
  // await testTx.wait()

  // let info = await pool.stakeInfo('0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  // console.log('info:' + info)

  // let stored = await pool.rewardPerHashRateStored()
  // console.log('stored:' + stored)

  // let referrakTx = await pool.setReferral('0xA7E0730c1098Fd820269914348E47690555fc123')
  // console.log('referrakTx:' + referrakTx.hash)
  // await referrakTx.wait()
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
