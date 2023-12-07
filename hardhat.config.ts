import '@nomicfoundation/hardhat-toolbox';
import 'hardhat-gas-reporter';
import { HardhatUserConfig } from 'hardhat/config';
import 'solidity-coverage';

const config: HardhatUserConfig = {
  defaultNetwork: 'hardhat',
  solidity: {
    version: '0.8.19',
    settings: {
      evmVersion: 'byzantium',
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      blockGasLimit: 130_000_000,
    },
  },
};

export default config;
