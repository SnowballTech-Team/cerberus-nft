const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  const property = await ethers.getContractAt('MillionDogeClubRepository', '0x6671117d1f14849D5a85Ec9c243797af8F62Dd12', signer)

  let owner = await property.owner()
  console.log('owner:' + owner)

  // let manageTx = await property.addManage(deployer.address)
  let prop = [500000, 10, 0]
  // let setTx = await property.setProperty(1, prop)
  // console.log('setTx:' + setTx.hash)
  // await setTx.wait()

  // let dogeTx = await property.updateCdoge(1, 10000)
  // console.log('dogeTx:' + dogeTx.hash)
  // await dogeTx.wait()

  // let depositTx = await property.depositBerus(1, 10000)
  // console.log('depositTx:' + depositTx.hash)
  // await depositTx.wait()

  let get = await property.getProperty(1)
  console.log(get)
  console.log('===============')
  console.log(get.cdoge)
  console.log(get.level)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
