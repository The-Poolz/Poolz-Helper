import { HardhatUserConfig } from "hardhat/config"
import "hardhat-gas-reporter"
import "@typechain/hardhat"
import "solidity-coverage"
import "@nomicfoundation/hardhat-network-helpers"
import "@nomicfoundation/hardhat-chai-matchers"

const config: HardhatUserConfig = {
    defaultNetwork: "hardhat",
    solidity: {
        compilers: [
            {
                version: "0.8.27",
                settings: {
                    evmVersion: "istanbul",
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                    viaIR: true,
                },
            },
        ],
    },
    networks: {
        hardhat: {
            blockGasLimit: 130_000_000,
        },
    },
    gasReporter: {
        enabled: true,
        showMethodSig: true,
        currency: "USD",
        token: "BNB",
        gasPriceApi:
            "https://api.bscscan.com/api?module=proxy&action=eth_gasPrice&apikey=" + process.env.BSCSCAN_API_KEY,
        coinmarketcap: process.env.CMC_API_KEY || "",
        noColors: true,
        reportFormat: "markdown",
        outputFile: "gasReport.md",
        forceTerminalOutput: true,
        L1: "binance",
        forceTerminalOutputFormat: "terminal",
        showTimeSpent: true,
    },
}

export default config
