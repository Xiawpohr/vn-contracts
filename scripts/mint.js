async function main() {
  const tokenAddress = '0x9978f7A8A7Ac990d83aF70b808dfF678102616a6'
  const amount = ethers.utils.parseEther('100') // Edit the number
  const signers = await ethers.getSigners()
  const ownerAddress = await signers[0].getAddress()
  const token = await ethers.getContractAt('Token', tokenAddress)
  const tx = await token.mint(ownerAddress, amount)
  const receipt = await tx.wait()
  console.log('Transaction Hash:', receipt.transactionHash)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
