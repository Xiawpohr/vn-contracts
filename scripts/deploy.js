async function main() {
  const name = 'Test Token'
  const symbol = 'TST'

  const Token = await ethers.getContractFactory('Token')
  const token = await Token.deploy(name, symbol)
  await token.deployed()
  console.log('Token Address:', token.address)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
