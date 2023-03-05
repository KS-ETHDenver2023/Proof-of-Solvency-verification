
# **Alice's ring - Proof of Solvency verification**

This smart contract developed during the **ETHDenver 2023 hackathon** is a part of our solvency proof : This contract verify the solvency and emit a SoulBound Token if the proof is valid.

🎯 Building a simple SoulBound Token for our solvency proof.  

🎯 Use Infura and the Truffle suite of tools for L2 and Multi-Network Deployment.

## **Configuration** 📝

1. Clone this repo 
```
git clone https://github.com/KS-ETHDenver2023/Proof-of-Solvency-verification.git
```
2. Install npm
```
npm install 
```
3. Install truffle
```
npm i truffle
```
4. Install hdWallet
```
npm i @truffle/hdwallet-provider
```
5. Install open zeppelin libraries
```
npm i @openzeppelin/contracts
```
6. Set up your .env file in the truffle folder
```
MNEMONIC="Your mnemonic"
API_KEY="Your infura api key"
ETHERSCAN="Your etherscan api key"
```
7. Set up the contract addresses
```
Set up the SBT and Ring verification addresses
```
8. Compile using truffle 
```
truffle compile
```
9. Deploy using truffle 
```
truffle deploy --network matic
```
10. Verify your contract on etherscan
```
truffle run verify PoS_token --network matic
```

We use the **[React Truffle Box](https://trufflesuite.com/boxes/react/)** to write, compile, test, and deploy smart contracts, and interact with them from a React app. It's a great tool for every developer and it helps us a lot during our development journey.
You can install [**Ganache**](https://trufflesuite.com/ganache/) for local development and deployment.


## Challenges and benefits when using Infura and the Truffle suite of tools 💻
Challenges :

Our challenges were numerous during the design and implementation of our project.

 - First we had to create a portable, scalable and understandable development environment for the whole team but also in view of a future reuse of the project by other developers.
 - Our project and our smart contracts must be deployed and usable on different networks (L1, L2).
 - Test, correct, deploy... We needed to have a set of easily usable and implementable tools for these actions.

Benefits 🛰️:

1.  **Convenient access to blockchain networks** : Infura provides convenient access to various networks via L1 and L2 endpoints, so we don't need to set up and maintain our own node and configure our own RPC. This save us lot of time and resources, especially during hackathon.
2.  **Reliable and scalable infrastructure**: Infura is built on top of highly reliable and scalable infrastructure, which can help ensure that our dApp remains available and responsive to users.
3.  **Simplified deployment:** Using Infura and Truffle box simplify the process of deploying and testing our multichain dApp.
4.  **Integrated with Truffle:** Truffle provides built-in support for Infura, so it's easy to configure your Truffle project to use Infura's RPC. The process of RPC configuration inside the truffle-config.js is verry simple. 
5. **Truffle for VS Code:** As developers we love using VS Code. The Truffle extension for VS Code allowed us to simplify our development process.
6. **Documentation :** The infura and truffle documentation is very detailed and simply explains via concrete examples how to set up your project.

## **Smart contract architecture 📏**

The purpose of this smart contract is not only to verify the source and validity of the ring signature, but it also verifies that the user's secret address owns the tokens. If all the criteria are met, the smart contract mints a specific SBT for the prover's communication address.
 
 This is all done in the verify function

## Technology 💻

 - [Tuffle Boxes](https://trufflesuite.com/boxes/)
 - [Infura RPC provider](https://www.infura.io/)
 - [Solidity](https://soliditylang.org/)
 - [OpenZeppelin](https://www.openzeppelin.com/)

	The use of Truffle boxes very easily allowed us to have a complete and intuitive front end to test our Smarts Contracts.
	Thanks to the large number of chains supported, we first used infura's RPCs for Polygon and Ethereum networks (mainnet&testnet).
	The infura and truffle tools were also useful for the deployment of multi-chain smart contracts.
	For Scroll and zkSync networks we used the RPCs provided in their respective documentations.

## Smart contract address

Polygon mainnet : 
```

```
Polygon mumbai and scroll alpha testnet : 
```

```
Sepolia testnet: 
```
0x7cc4404E811a12547C988d421D0F1ee5Cb2d96d5
```
Goerli testnet : 
```

```

## Contribute ✨

Our project is intended as open source and as a tool for the Ethereum community and all web3 users. 
Feel free to contribute!

**Maxime - Thomas - Nathan - Adam | KRYPTOSPHERE®**
