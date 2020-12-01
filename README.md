# Value Network Contracts

## Setup
1. Installing dependencies
```
npm install
```
2. Create `secret.json` file
```
cp secret.json.example secret.json
```
3. Set mnemonic, alchemyApiKey, etherscanApiKey in `secret.json`
> Noted:
> * You can use your own mnemonic words or create a new one by running `npm run create-account` command.
> * Sign up an account on https://alchemyapi.io/ to get alchemyApiKey.
> * Sign up an account on https://etherscan.io/ to get etherscanApiKey.

## Compile
```
npm run compile
```

## Test
1. Run test environment.
```
npm run node
```
2. Test contracts.
```
npm run test
```

## Deployment
1. Go to `scripts/deploy.js` and edit name and symbol of token.
2. Deploy token contract by running this command. Token Address is displayed later when deployment has been compeleted.
```
npm run deploy
```
3. Please remember this token address.

> Noted: 
> * The account that you set on `secrets.json` will be admin key of this token.
> * You should deposit some ethers into this account before deployment.

## Verify source code to Etherscan
```
npx hardhat verify --network mainnet {DEPLOYED_CONTRACT_ADDRESS} "{Constructor argument 1}"
```
You need write your token address and deploying arguments.

## Mint Token
1. Go to `scripts/mint.js` and edit tokenAddress and amount.
2. Mint token by running this command.
```
npx run mint
```
3. TransactionHash will be displayed. You can check it on etherscan.io or any Ethereum Explorer.
