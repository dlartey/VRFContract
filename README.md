# Lottery Smart Contract

This project deploys 3 smart contracts to test on-chain vs off-chain randomness.

## Requirements
+ Node.js
+ Infura API key
+ Truffle
+ React
+ MetaMask extension


To get started, clone the repository. You will need to ensure that [MetaMask](https://metamask.io/download/) is installed, and you fund your accounts with ETH, which can be obtained through [faucets](https://faucetlink.to/goerli).

Next, ensure that [Node.js](https://nodejs.org/en/download) is installed, then navigate to the [./lottery-dapp/](./lottery-dapp/) folder and run the following command to install dependencies for this project:

```
~ npm install
```

Also, in the [./lottery/](./lottery/) folder, run the following command so the smart contracts can be deployed to the appropriate test networks, and tests can be run.

```
~ npm install truffle
```

If you wish to use your own [Chainlink Subscription Manager](https://vrf.chain.link/goerli), edit the relevant migration contracts inside [./lottery/migrations](./lottery/migrations), replacing `deployer.deploy()` with the ID of your own subscription manager. Ensure that this is sufficiently funded with LINK token which can be obtained through a [faucet](https://faucets.chain.link/goerli)

Ensure to obtain an [Infura API key](https://docs.infura.io/infura/networks/ethereum/how-to/secure-a-project/project-id) & replace the environment variables `INFURA_API_KEY` & `PRIVATE_KEY_1` with your own inside [./lottery/truffle-config.js](./lottery/truffle-config.js). Also, in the [./lottery-dapp/blockchain/contracts](./lottery-dapp/blockchain/contracts) folder, replace the contract address with the corresponding addresses output by the terminal when running: 
```
~ truffle migrate
```
in the [./lottery/](./lottery/) folder


Now run 
```
~ npm run compile
``` 
inside the [./lottery/](./lottery/) folder and copy the ABI inside the [./lottery/build/contracts](./lottery/build/contracts) folder for the relevant smart contracts into [./lottery-dapp/blockchain](./lottery-dapp/blockchain) folder and replace the `lotteryAbi` variable for the corresponding contracts from the output in the [./lottery/build/contracts](./lottery/build/contracts) folder.

To run tests, type 
```
~ truffle test
```
inside the [./lottery/](./lottery/), which will run all the tests.

To run the dApp, type
```
~ npm run dev
```
inside the [./lottery-dapp/](./lottery-dapp/) folder. This should run the application if everything has gone smoothly.


### Example of tests which run
![image](https://user-images.githubusercontent.com/58071586/235549946-86a6251b-a4c2-49f8-a1ff-bdd57a1bea0e.png)

