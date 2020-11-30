# Value Network Contracts

## Setup
1. Installing dependancies
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
> * Sign up an account on `https://alchemyapi.io/` to get alchemyApiKey.
> * Sign up an account on https://etherscan.io/ to get etherscanApiKey.

## Compile
```
npx run compile
```

## Test
```
npx run node
npx run test
```

## Deployment
```
npx run deploy:mainnet
```

## Verify source code to Etherscan
```
npx hardhat verify --network mainnet {DEPLOYED_CONTRACT_ADDRESS} "{Constructor argument 1}"
```
You need write your token address and deploying arguments.
