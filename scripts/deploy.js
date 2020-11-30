const tName = 'Test Token'
const tSymbol = 'TST'

async function main() {
  // We get the contract to deploy
  const Token = await ethers.getContractFactory('Token')
  console.log('Deploying Token...')
  const token = await Token.deploy(tName, tSymbol)
  await token.deployed()
  console.log('Token deployed to:', token.address)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
