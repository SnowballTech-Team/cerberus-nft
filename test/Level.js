const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  const level = await ethers.getContractAt('LevelUtil', '0x2ce2c18B4bbeD86eBf7DaE5dF8b0D80f24b7b0D7', signer)

  let lv = await level.checkLevel(ethers.utils.parseEther('10000'), 0)
  console.log(lv)

  // let manageTx = await level.addManage(deployer.address)
  // console.log('manageTx: ' + manageTx.hash)
  // await manageTx.wait()

  // let soldierTx = await level.setLevelSoldier([ethers.utils.parseEther('1000'), ethers.utils.parseEther('10000')])
  // console.log('soldierTx: ' + soldierTx.hash)
  // await soldierTx.wait()

  // let generalTx = await level.setLevelGeneral([ethers.utils.parseEther('2000'), ethers.utils.parseEther('20000')])
  // console.log('generalTx: ' + generalTx.hash)
  // await generalTx.wait()

  // let chieftainsTx = await level.setLevelChieftains([ethers.utils.parseEther('10000'), ethers.utils.parseEther('100000')])
  // console.log('chieftainsTx: ' + chieftainsTx.hash)
  // await chieftainsTx.wait()

  // let kingTx = await level.setLevelKing([ethers.utils.parseEther('50000'), ethers.utils.parseEther('500000')])
  // console.log('kingTx: ' + kingTx.hash)
  // await kingTx.wait()

  // let astronautTx = await level.setLevelAstronaut([ethers.utils.parseEther('100000'), ethers.utils.parseEther('1000000')])
  // console.log('astronautTx: ' + astronautTx.hash)
  // await astronautTx.wait()

  // let alienTx = await level.setLevelAlien([ethers.utils.parseEther('200000'), ethers.utils.parseEther('2000000')])
  // console.log('alienTx: ' + alienTx.hash)
  // await alienTx.wait()

  // let martianTx = await level.setLevelMartian([ethers.utils.parseEther('1000000'), ethers.utils.parseEther('10000000')])
  // console.log('martianTx: ' + martianTx.hash)
  // await martianTx.wait()

  // let collectorTx = await level.setLevelCollector([ethers.utils.parseEther('1000000'), ethers.utils.parseEther('10000000')])
  // console.log('collectorTx: ' + collectorTx.hash)
  // await collectorTx.wait()
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
