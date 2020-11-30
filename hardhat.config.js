/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const { etherscanApiKey, alchemyApiKey, mnemonic } = require('./secrets.json')

require('@nomiclabs/hardhat-ethers')
require('@nomiclabs/hardhat-waffle')

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async () => {
  const accounts = await ethers.getSigners()

  for (const account of accounts) {
    console.log(account.address)
  }
})

module.exports = {
  solidity: '0.7.3',
  networks: {
     mainnet: {
       url: `https://eth-mainnet.alchemyapi.io/v2/${alchemyApiKey}`,
       accounts: { mnemonic: mnemonic },
     },
     rinkeby: {
       url: `https://eth-rinkeby.alchemyapi.io/v2/${alchemyApiKey}`,
       accounts: { mnemonic: mnemonic },
     },
     ropsten: {
       url: `https://eth-ropsten.alchemyapi.io/v2/${alchemyApiKey}`,
       accounts: { mnemonic: mnemonic },
     },
     kovan: {
       url: `https://eth-kovan.alchemyapi.io/v2/${alchemyApiKey}`,
       accounts: { mnemonic: mnemonic },
     },
     goerli: {
       url: `https://eth-goerli.alchemyapi.io/v2/${alchemyApiKey}`,
       accounts: { mnemonic: mnemonic },
     },
  },
  etherscan: {
    apiKey: etherscanApiKey
  }
}
