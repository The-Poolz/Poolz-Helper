require("@nomiclabs/hardhat-truffle5");

module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
        evmVersion: "byzantium",
        optimizer: { enabled: true, runs: 200 },
      }
  },
};