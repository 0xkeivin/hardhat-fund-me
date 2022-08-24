# Hardhat Fund Me

This project is part of the 32hour course from https://github.com/smartcontractkit/full-blockchain-solidity-course-js

## Usage guide

-   fill in the required details in `example.env` as `.env`
-   run the following

```bash
yarn install
yarn deploy:goerli
yarn test:staging
```

## Outcomes

-   Deployed contract: https://goerli.etherscan.io/address/0xAC6b5Cc9c4a0CA368ebDfA1B9bAaf426aa29250d#code
-   gas-report.txt

```bash
·-----------------------|----------------------------|-------------|----------------------------·
|  Solc version: 0.8.8  ·  Optimizer enabled: false  ·  Runs: 200  ·  Block limit: 6718946 gas  │
························|····························|·············|·····························
|  Methods              ·               23 gwei/gas                ·      1660.56 usd/eth       │
·············|··········|··············|·············|·············|·············|···············
|  Contract  ·  Method  ·  Min         ·  Max        ·  Avg        ·  # calls    ·  usd (avg)   │
·------------|----------|--------------|-------------|-------------|-------------|--------------·
```
