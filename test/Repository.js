const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  const property = await ethers.getContractAt('MillionDogeClubRepository', '0xC40Daa74743Fb03a0654b24b2DE3F72B5508f90e', signer)

  // let owner = await property.owner()
  // console.log('owner:' + owner)

  // let manageTx = await property.addManage(deployer.address)
  // let manageTx = await property.addManage('0x1CB32423BcD55E1c7799B2d4592A7cee114623D3')
  // console.log('manageTx: ' + manageTx.hash)
  // await manageTx.wait()

  // let setTx = await property.setProperty(1)
  // console.log('setTx:' + setTx.hash)
  // await setTx.wait()

  // let dogeTx = await property.updateCdoge(deployer.address, 1, 10000)
  // console.log('dogeTx:' + dogeTx.hash)
  // await dogeTx.wait()

  // let depositTx = await property.depositBerus(1, 10000)
  // console.log('depositTx:' + depositTx.hash)
  // await depositTx.wait()

  // let levelTx = await property.setLevel('0xb5754020ae3B287bD4e633d8135356C9b4d2e027')
  // console.log('levelTx: ' + levelTx.hash)
  // await levelTx.wait()

  // let get = await property.getProperty(19)
  // console.log(get.cdoge)
  // console.log(get.berus)
  // console.log(get.level)

  // let record = await property.sellRecoredOfTokenId(19)
  // console.log(record)

  let hashrate = await property.tokenHashRate(1)
  console.log(hashrate)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
