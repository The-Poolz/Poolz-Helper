require("@nomiclabs/hardhat-truffle5");
require("hardhat-preprocessor");
const fs = require("fs");

function getRemappings() {
    return fs
      .readFileSync("remappings.txt", "utf8")
      .split("\n")
      .filter(Boolean) // remove empty lines
      .map((line) => line.trim().split("="));
  }

module.exports = {
  solidity: {
    version: "0.8.18",
    settings: {
        evmVersion: "byzantium",
        optimizer: { enabled: true, runs: 200 },
      },
      docker: false,
  },
  preprocess: {
    eachLine: (hre) => ({
      transform: (line) => {
        if (line.match(/^\s*import /i)) {
          for (const [from, to] of getRemappings()) {
            if (line.includes(from)) {
              line = line.replace(from, to);
              break;
            }
          }
        }
        return line;
      },
    }),
  },
};