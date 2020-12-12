import {
  TOKEN_NAME,
  TOKEN_SYMBOL,
  VESTING_TOKEN_NAME,
  VESTING_TOKEN_SYMBOL,
} from '../config/config.js'

async function main() {
  // owner address
  const signers = await ethers.getSigners()
  const ownerAddress = await signers[0].getAddress()
  console.log('Admin Address: ', ownerAddress)

  // deploy token
  const Token = await ethers.getContractFactory('Token')
  const token = await Token.deploy(TOKEN_NAME, TOKEN_SYMBOL)
  await token.deployed()
  console.log('Token Address: ', token.address)

  // deploy vesting token
  const VestingToken = await ethers.getContractFactory('VestingToken')
  const vestingToken = await VestingToken.deploy(VESTING_TOKEN_NAME, VESTING_TOKEN_SYMBOL)
  await vestingToken.deployed()
  console.log('Vesting Token Address: ', vestingToken.address)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
