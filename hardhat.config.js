require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")
require("@nomiclabs/hardhat-etherscan")
require("dotenv").config()
require("solidity-coverage")
require("hardhat-deploy")
/** @type import('hardhat/config').HardhatUserConfig */

const GOERLI_ALCHEMY_URL =
    process.env.GOERLI_ALCHEMY_URL || "https://eth-goerli"
const PRIVATE_KEY = process.env.PRIVATE_KEY || "0xkey"
const ETHERSCAN_KEY = process.env.ETHERSCAN_KEY || "key"
const CMC_KEY = process.env.CMC_KEY || "key"
module.exports = {
    // solidity: "0.8.8",
    solidity: {
        compilers: [{ version: "0.8.8" }, { version: "0.6.6" }]
    },
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337
            // gasPrice: 130000000000,
        },
        goerli: {
            url: GOERLI_ALCHEMY_URL,
            accounts: [PRIVATE_KEY],
            chainId: 5,
            blockConfirmations: 6
        }
    },
    etherscan: {
        // Your API key for Etherscan
        // Obtain one at https://etherscan.io/
        apiKey: ETHERSCAN_KEY
    },
    gasReporter: {
        enabled: true,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "USD",
        coinmarketcap: CMC_KEY
    },
    namedAccounts: {
        deployer: {
            default: 0,
            1: 0
        }
    }
}
