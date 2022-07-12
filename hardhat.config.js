require('@nomiclabs/hardhat-waffle')

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners()

  for (const account of accounts) {
    console.log(account.address)
  }
})

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: 'bsc_test',
  // defaultNetwork: 'bsc',
  solidity: {
    version: '0.8.6',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    bsc_test: {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545',
      // url: 'https://bsc.getblock.io/testnet/',
      // httpHeaders: { 'x-api-key': 'f4f26976-106a-4e34--a56c5660656e' },
      accounts: [''],
    },
    bsc: {
      url: 'https://bsc-dataseed1.binance.org',
      accounts: [''],
    },
    //   ropsten: {
    //     url: process.env.ROPSTEN_URL || "",
    //     accounts:
    //       process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    //   },
    // },
    // gasReporter: {
    //   enabled: process.env.REPORT_GAS !== undefined,
    //   currency: "USD",
    // },
    // etherscan: {
    //   apiKey: process.env.ETHERSCAN_API_KEY,
  },
  mocha: {
    timeout: 40000,
  },
}
