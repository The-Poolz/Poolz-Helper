[![Build Status](https://app.travis-ci.com/The-Poolz/Poolz-Helper.svg?branch=master)](https://app.travis-ci.com/The-Poolz/Poolz-Helper)
[![codecov](https://codecov.io/gh/The-Poolz/Poolz-Helper/branch/master/graph/badge.svg?token=JIz6mduCuo)](https://codecov.io/gh/The-Poolz/Poolz-Helper)
[![CodeFactor](https://www.codefactor.io/repository/github/the-poolz/poolz-helper/badge)](https://www.codefactor.io/repository/github/the-poolz/poolz-helper)
[![npm version](https://img.shields.io/npm/v/poolz-helper-v2/latest.svg)](https://www.npmjs.com/package/poolz-helper-v2/v/latest)


# Poolz-Helper
This package acts as a single source of truth for helper contracts used by the [Poolz](http://poolz.finance/).

## Install
```
npm i poolz-helper-v2
```
## Reference
### 1. ERC20Helper
```javascript
//Function
//Transfers out ERC20 tokens to ReceiverAddress
TransferToken(TokenAddress, ReceiverAddress, Amount)

//Function
//Checks balance of ERC20 tokens
CheckBalance(TokenAddress, WalletAddress)

//Function
//Transfers in ERC20 Tokens from AddressToTransferFrom(approval required). 
TransferInToken(TokenAddress, AddressToTransferFrom, Amount)
```
### 2. ETHHelper
```javascript
//function
//transfers ETH to ReceiverAddress
TransferETH(ReceiverAddress, Amount)
```
### 3. GovManager
```javascript
//modifier
//allows functions to be called by the gov contract
onlyOwnerOrGov

//function
//sets the address of Gov contract
setGovernerContract(address)
```
### 4. Token
ERC20 Token used for Testing Purpose

### 5. IWhiteList
Interface to interact with WhiteList Contract
