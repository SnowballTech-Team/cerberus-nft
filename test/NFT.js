const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  const mdc = await ethers.getContractAt('MillionDogeClub', '0x6E3EDd7648BE18a1149987C94A2f5e0355E3A46c', signer)

  // for (i = 0; i < 10; i++) {
  //   let mintTx = await mdc.mint('0xE037420Ebd8B3fa5A68CB0dA7302E9254a45e0f3')
  //   console.log('mintTx: ' + mintTx.hash)
  //   await mintTx.wait()
  // }

  let manageTx = await mdc.addManage('0x178fe3900B3ef39eBE0E62E1f1dB2f6b24Fdc2Cb')
  console.log('manageTx: ' + manageTx.hash)
  await manageTx.wait()

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
