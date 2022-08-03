const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  const mdc = await ethers.getContractAt('MillionDogeClub', '0xeE077A41f5064D4169C63cb9B2353b96B4b14266', signer)
  const property = await ethers.getContractAt('MillionDogeClubRepository', '0xC40Daa74743Fb03a0654b24b2DE3F72B5508f90e', signer)

  let mintTx = await mdc.mint('0x9F6C71dE830F70dFc352F13fE34F351D7fA9B648')
  console.log('mintTx:' + mintTx.hash)
  let result = await mintTx.wait()
  console.log(result.events[0].topics[3])

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
