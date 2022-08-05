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

  for (i = 0; i < 10; i++) {
    let mintTx = await mdc.mint('0xE037420Ebd8B3fa5A68CB0dA7302E9254a45e0f3')
    console.log('mintTx:' + mintTx.hash)
    await mintTx.wait()
  }

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
