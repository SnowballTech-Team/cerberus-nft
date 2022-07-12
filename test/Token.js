const { ethers, run } = require('hardhat')

async function main() {
  await run('compile')

  let provider = ethers.provider
  let signer = provider.getSigner()

  console.log('NetWorks ID is ', (await ethers.provider.getNetwork()).chainId)
  console.log('NetWorks Name is ', (await ethers.provider.getNetwork()).name)

  const [deployer] = await ethers.getSigners()

  console.log('deployer:' + deployer.address)
  const token = await ethers.getContractAt('Berus', '0x6E3EDd7648BE18a1149987C94A2f5e0355E3A46c', signer)

  // amount
  // let amount = await token.balanceOf(deployer.address)
  let amount = await token.balanceOf('0x6671117d1f14849D5a85Ec9c243797af8F62Dd12')
  console.log('amount:' + amount)

  // totalSupply
  // let totalSupply = await token.totalSupply()
  // console.log('totalSupply:' + totalSupply)

  // approve
  // let approveTx = await token.approve('0x6671117d1f14849D5a85Ec9c243797af8F62Dd12', amount)
  // console.log('approveTx:' + approveTx.hash)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
