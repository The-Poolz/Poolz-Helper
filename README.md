# Poolz-Helper

[![Build Status](https://github.com/The-Poolz/Poolz-Helper/actions/workflows/node.js.yml/badge.svg)](https://github.com/The-Poolz/Poolz-Helper/actions/workflows/node.js.yml)
[![codecov](https://codecov.io/gh/The-Poolz/Poolz-Helper/branch/master/graph/badge.svg?token=JIz6mduCuo)](https://codecov.io/gh/The-Poolz/Poolz-Helper)
[![CodeFactor](https://www.codefactor.io/repository/github/the-poolz/poolz-helper/badge)](https://www.codefactor.io/repository/github/the-poolz/poolz-helper)
[![npm version](https://img.shields.io/npm/v/@poolzfinance/poolz-helper-v2/latest.svg)](https://www.npmjs.com/package/@poolzfinance/poolz-helper-v2/v/latest)

This package acts as a single source of truth for helper contracts used by the [Poolz](http://poolz.finance/).

## Install
```
npm i poolz-helper-v2
```

### Navigation

- [Tokens](#tokens)
- [Interfaces](#interfaces)
- [ERC20Helper](#erc20helper)
- [ERC721Helper](#erc721helper)
- [ETHHelper](#ethhelper)
- [GovManager](#govmanager)
- [Array](#array-library)
- [Fee Helper](#feebasehelper)
- [License](#license)

## Tokens

The helper repository include two token contracts that are used for testing purposes. These tokens are:

- **ERC20Token:** a basic ERC20 token which allows to transfer tokens between addresses. This contract is implemented in the ERC20Token.sol file.
- **ERC721Token:** a basic ERC721 token that allows for the minting and transfer of non-fungible tokens (NFTs) between addresses. This contract is implemented in the ERC721Token.sol file.

Both tokens are implemented using **OpenZeppelin** libraries and inherit from their respective base contract (either **ERC20** or **ERC721URIStorage**).

## Interfaces
The Interface section contains Solidity interfaces, which are a way of defining the expected external interface of a contract without implementing the actual logic.

- **ILockedDealV2:** An interface for a contract that allows users to create new token pools and withdraw tokens from existing pools. Users can specify the start time, cliff time, finish time, start amount, and owner of each pool. They can also get information about their own pools and withdraw tokens from them.

- **ILockedDeal:** An interface for a contract that allows users to create new token pools and withdraw tokens from existing pools. Users can specify the finish time, start amount, and owner of each pool.

- **IPOZBenefit:** An interface for a contract that provides a function to check whether an address is a POZ holder.

- **IWhiteList:** An interface for a contract that provides functions for checking and registering addresses on a whitelist. Users can check whether an address is on a whitelist, register an address with a given ID and amount, and create a manual whitelist with a specified change time and contract address. Users can also change the creator of a whitelist.

##  ERC20Helper
The ERC20Helper is a Solidity smart contract that provides helper functions for interacting with ERC20 tokens. It has the following functions:

### TransferToken
```solidity
function TransferToken(address _Token, address _Receiver, uint256 _Amount) internal
```
This function transfers a specified amount of an ERC20 token to a recipient address. It emits the TransferOut event to indicate that the transfer has taken place.

#### Parameters
- **address _Token:** The address of the ERC20 token to be transferred.
- **address _Receiver:** The address of the recipient of the tokens.
- **uint256 _Amount:** The amount of tokens to be transferred.
#### Events
**TransferOut(uint256 Amount, address To, address Token):** This event is emitted when tokens are transferred out of the contract. The parameters are:
- **Amount:** The amount of tokens that were transferred.
- **To:** The address that received the tokens.
- **Token:** The address of the ERC20 token that was transferred.

### TransferInToken
```solidity
function TransferInToken(address _Token, address _Subject, uint256 _Amount) internal TestAllownce(_Token, _Subject, _Amount)
```
This function transfers a specified amount of an ERC20 token to the contract from the specified subject. It first checks if the contract has sufficient allowance to perform the transfer using the TestAllownce modifier, and then emits the TransferIn event to indicate that the transfer has taken place.
#### Parameters
- **address _Token:** The address of the ERC20 token to be transferred.
- **address _Subject:** The address of the subject of the tokens.
- **uint256 _Amount:** The amount of tokens to be transferred.

#### Modifiers
**TestAllownce(address _token, address _owner, uint256 _amount):** This modifier checks if the contract has sufficient allowance to perform the transfer. It takes the following parameters:
- **_token:** The address of the ERC20 token.
- **_owner:** The address of the owner of the tokens.
- **_amount:** The amount of tokens to be transferred.
#### Events
**TransferIn(uint256 Amount, address From, address Token):** This event is emitted when tokens are transferred into the contract. The parameters are:
- **Amount:** The amount of tokens that were transferred.
- **From:** The address that sent the tokens.
- **Token:** The address of the ERC20 token that was transferred.

### ApproveAllowanceERC20
```solidity
function ApproveAllowanceERC20(address _Token, address _Subject, uint256 _Amount) internal
```
This function approves a specified amount of an ERC20 token to be spent by a specified subject.
#### Parameters
- **address _Token:** The address of the ERC20 token to approve.
- **address _Subject:** The address of the subject to approve.
- **uint256 _Amount:** The amount of tokens to approve.

##  ERC721Helper
The ERC721Helper contract is a utility contract that provides common helper functions for working with ERC721 tokens. It allows for the transfer of ERC721 tokens and setting of approval for ERC721 tokens.
### TransferNFTOut
```solidity
function TransferNFTOut(address _Token, uint256 _TokenId, address _To) internal
```
This function transfers an ERC721 token from the contract to a specified recipient address.
#### Parameters:

- **address _Token:** The address of the ERC721 token contract.
- **uint256 _TokenId:** The ID of the ERC721 token being transferred.
- **address _To:** The recipient address that will receive the ERC721 token.

### TransferNFTIn
```solidity
function TransferNFTIn(address _Token, uint256 _TokenId, address _From) internal
```
This function transfers an ERC721 token from a specified sender address to the contract.
#### Parameters:

- **address _Token:** The address of the ERC721 token contract.
- **uint256 _TokenId:** The ID of the ERC721 token being transferred.
- **address _From:** The sender address that will transfer the ERC721 token to the contract.
### SetApproveForAllNFT
```solidity
function SetApproveForAllNFT(address _Token, address _To, bool _Approve) internal
```
This function sets or revokes approval for a specified address to transfer all tokens owned by the contract owner.
#### Parameters:

- **address _Token:** The address of the ERC721 token contract.
- **address _To:** The address for which approval will be set or revoked.
- **bool _Approve:** Boolean value indicating whether to approve or revoke approval for _To.

## ETHHelper
ETHHelper is a contract that provides useful functions for handling Ether transactions.
### SwitchIsPayble
```solidity
function SwitchIsPayble() public onlyOwner;
```
`SwitchIsPayble` allows the owner of the contract to toggle the ability of the contract to receive Ether.
### TransferETH
```solidity
function TransferETH(address payable _Reciver, uint256 _amount) internal;
```
`TransferETH` allows the contract to transfer Ether to a specified address.
#### Parameters:
- **address _Reciver:** the address to transfer the ETH to.
- **uint256 _amount:** the amount of ETH to transfer.
### ReceivETH
```solidity
modifier ReceivETH(uint256 msgValue, address msgSender, uint256 _MinETHInvest);
```
`ReceivETH` is a modifier that checks if the amount of Ether sent with the transaction is greater than or equal to a specified minimum investment value.
#### Parameters:
- **uint256 msgValue:** the amount of ETH sent with the transaction.
- **address msgSender:** the address of the sender of the transaction.
- **uint256 _MinETHInvest:** the minimum amount of ETH required to invest.

## GovManager
The GovManager contract manages the authorization of a Governor Contract address. It is based on the OpenZeppelin Ownable contract which allows for ownership transferability
### setGovernorContract
```solidity
function setGovernorContract(address _address) external onlyOwnerOrGov
```
This function sets the GovernorContract address to the specified address. Only the contract owner or the existing GovernorContract can call this function. Upon successful execution, the GovernorUpdated event is emitted.
```solidity
modifier onlyOwnerOrGov()
```
This modifier ensures that the caller is either the contract owner or the current GovernorContract address. If the caller is not authorized, an error message is returned and the function execution is reverted.
### Usage
The GovManager contract can be used to manage the authorization of a GovernorContract address. To use the contract, simply deploy it to the blockchain and interact with it using the functions described above.

Note that the initial GovernorContract address is set to address(0) upon contract deployment. This means that no address is initially authorized and setGovernorContract() must be called to set the initial GovernorContract address.

It is important to note that the GovManager contract does not implement any functionality related to the GovernorContract. It only manages authorization of the GovernorContract address. Any additional functionality related to the GovernorContract must be implemented separately.

## Array Library
### KeepNElementsInArray
```solidity
function KeepNElementsInArray(uint256[] memory _arr, uint256 _n) internal pure returns (uint256[] memory)
```
```solidity
function KeepNElementsInArray(address[] memory _arr, uint256 _n) internal pure returns (address[] memory)
```
The `KeepNElementsInArray` functions take an array `_arr` and a number `_n` as input and return a new slice of the array containing only the first `_n` elements. If the length of `_arr` is equal to `_n`, the function returns the original array. If the length of `_arr` is less than `_n`, the function will throw an error.

### isArrayOrdered
```solidity
function isArrayOrdered(uint256[] memory _arr) internal pure returns (bool)
```
The `isArrayOrdered` function takes an array `_arr` as input and returns **true** if the array is ordered in ascending order, **false** otherwise. If the array is empty, the function will throw an error.

### getArraySum
```solidity
function getArraySum(uint256[] memory _array) internal pure returns (uint256)
```
The `getArraySum` function takes an array `_array` as input and returns the sum of all the elements in the array.

### isInArray
```solidity
function isInArray(address[] memory _arr, address _elem) internal pure returns (bool)
```
The `isInArray` function takes an array `_arr` and an element `_elem` as input and returns **true** if the element exists in the array, **false** otherwise.

### addIfNotExsist
```solidity
function addIfNotExsist(address[] storage _arr, address _elem) internal
```
The `addIfNotExsist` function takes an array `_arr` and an element `_elem` as input and adds the element to the array if it does not already exist in the array. The function modifies the array in place by adding the element to the end of the array.

## FeeBaseHelper
**The FeeBaseHelper** contract is a smart contract that enables users to pay a fee in order to use certain functionality. It is designed to work with **ERC20** tokens or with **ETH/BNB** as the main coin.

The contract extends two other contracts: **ERC20Helper** and **GovManager**. The **ERC20Helper** contract is responsible for handling transfers of ERC20 tokens, while the **GovManager** contract provides access control to the owner and government authorities.

### Functionality
- **PayFee(uint256 _fee):** Allows users to pay a fee in order to use certain functionality. If the FeeToken address is address(0), the fee must be paid in ETH/BNB, and the amount sent must be greater than or equal to the specified fee. If the FeeToken address is not address(0), the fee must be paid in the specified ERC20 token. The Reserve mapping is updated with the amount of the fee paid.

- **SetFeeAmount(uint256 _amount):** Allows the owner or government authority to set the fee amount to a new value. Emits a NewFeeAmount event.

- **SetFeeToken(address _token):** Allows the owner or government authority to set the token used for paying the fee. If the _token address is address(0), the fee must be paid in ETH/BNB. Emits a NewFeeToken event.

- **WithdrawFee(address _token, address _to):** Allows the owner or government authority to withdraw the accumulated fees from the contract. The _token address specifies which ERC20 token to withdraw, or address(0) to withdraw in ETH/BNB. The _to address specifies where the funds should be sent. The Reserve mapping is updated to reflect the withdrawn amount.

### Variables
- **uint256 Fee:** A uint256 variable representing the current fee amount.

- **address FeeToken:** An address variable representing the ERC20 token used to pay the fee, or address(0) to use ETH/BNB.

- **mapping(address => uint256) Reserve:** A mapping that tracks the accumulated fees for each ERC20 token.

### Events
- **TransferInETH(uint256 Amount, address From):** Emits when a user pays a fee in ETH/BNB.

- **NewFeeAmount(uint256 NewFeeAmount, uint256 OldFeeAmount):** Emits when the fee amount is updated.

- **NewFeeToken(address NewFeeToken, address OldFeeToken):** Emits when the fee token is updated.

## License
The-Poolz Contracts is released under the MIT License.
