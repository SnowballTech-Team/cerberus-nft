const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer: ' + deployer.address)
  const property = await ethers.getContractAt('MillionDogeClubRepository', '0x6671117d1f14849D5a85Ec9c243797af8F62Dd12', signer)
  const token = await ethers.getContractAt('Berus', '0x3004739f3B9b870e012d367A42C39962Bd2A2748', signer)
  const mdc = await ethers.getContractAt('MillionDogeClub', '0xeE077A41f5064D4169C63cb9B2353b96B4b14266', signer)

  // let owner = await property.owner()
  // console.log('owner:' + owner)

  // let manageTx = await property.addManage(deployer.address)
  let manageTx = await property.addManage('0x712B8F3963AD1512f6f711F7c6A8B2F8AE6b713b')
  console.log('manageTx: ' + manageTx.hash)
  await manageTx.wait()

  // let setTx = await property.setProperty(1)
  // console.log('setTx:' + setTx.hash)
  // await setTx.wait()

  // let dogeTx = await property.updateCdoge(deployer.address, 3, ethers.utils.parseEther('999'))
  // console.log('dogeTx:' + dogeTx.hash)
  // await dogeTx.wait()

  // let approveTokenTx = await token.approve('0x118A5305ABe475089cAc273a7A80cC2bb0Abf3c4', ethers.utils.parseEther('10000'))
  // console.log('approveTokenTx: ' + approveTokenTx.hash)
  // await approveTokenTx.wait()

  // let depositTx = await property.depositBerus(4, ethers.utils.parseEther('10000'))
  // console.log('depositTx: ' + depositTx.hash)
  // await depositTx.wait()

  // let levelTx = await property.setLevel('0xb5754020ae3B287bD4e633d8135356C9b4d2e027')
  // console.log('levelTx: ' + levelTx.hash)
  // await levelTx.wait()

  let get = await property.getProperty(1)
  console.log(get.cdoge)
  console.log(get.berus)
  console.log(get.level)

  // let record = await property.sellRecoredOfTokenId(19)
  // console.log(record)

  // let hashrate = await property.tokenHashRate(3)
  // console.log(hashrate)

  // let approveTx = await mdc.approve('0x118A5305ABe475089cAc273a7A80cC2bb0Abf3c4', 4)
  // console.log('approveTx: ' + approveTx.hash)
  // await approveTx.wait()

  // let burnTx = await property.burn(4)
  // console.log('burnTx: ' + burnTx.hash)
  // await burnTx.wait()
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
