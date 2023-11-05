require("@nomiclabs/hardhat-truffle5");

module.exports = {
  solidity: {
    version: "0.8.18",
    settings: {
        evmVersion: "byzantium",
        optimizer: { enabled: true, runs: 200 },
      },
      docker: false,
  },
};