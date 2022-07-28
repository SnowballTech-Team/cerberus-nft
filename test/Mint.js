const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  const mdc = await ethers.getContractAt('MillionDogeClub', '0x153d3F1FCE5BfB50752fd3F6D44EA20522952e2a', signer)
  const property = await ethers.getContractAt('MillionDogeClubRepository', '0x6671117d1f14849D5a85Ec9c243797af8F62Dd12', signer)

  let mintTx = await mdc.mint('0xE13175C36da232ab9AEFc33f841eeC9b697BBf2a')
  console.log('mintTx:' + mintTx.hash)
  console.log(mintTx)
  await mintTx.wait()

  // let setTx = await property.setProperty(mintTx.)
  // console.log('setTx:' + setTx.hash)
  // await setTx.wait()

  // let setBaseURITX = await mdc.setBaseURI('https://nft.btc-z.org/')
  // console.log('setBaseURITX:' + setBaseURITX.hash)
  // await setBaseURITX.wait()

  // let baseURI = await mdc.baseURI()
  // console.log('baseURI:' + baseURI)

  // approve
  // let approveTx = await mdc.approve('0xA21C66a62f340737Aa1F3B9614522B71697a5b4e', 1)
  // console.log('approveTx:' + approveTx.hash)
  // await approveTx.wait()
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
