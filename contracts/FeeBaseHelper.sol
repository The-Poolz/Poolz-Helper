// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Helper.sol";
import "./GovManager.sol"; 
import {SphereXProtected} from "@spherex-xyz/contracts/src/SphereXProtected.sol";
 

contract FeeBaseHelper is ERC20Helper, GovManager {
    event TransferInETH(uint256 Amount, address From);
    event NewFeeAmount(uint256 NewFeeAmount, uint256 OldFeeAmount);
    event NewFeeToken(address NewFeeToken, address OldFeeToken);

    uint256 public Fee;
    address public FeeToken;
    mapping(address => uint256) public Reserve;

    function PayFee(uint256 _fee) public payable sphereXGuardPublic(0x0983155b, 0xda0ff68c) {
        if (_fee == 0) return;
        if (FeeToken == address(0)) {
            require(msg.value >= _fee, "Not Enough Fee Provided");
            emit TransferInETH(msg.value, msg.sender);
        } else {
            TransferInToken(FeeToken, msg.sender, _fee);
        }
        Reserve[FeeToken] += _fee;
    }

    function SetFeeAmount(uint256 _amount) public onlyOwnerOrGov sphereXGuardPublic(0x673b89da, 0xd854f702) {
        require(Fee != _amount, "Can't swap to same fee value");
        emit NewFeeAmount(_amount, Fee);
        Fee = _amount;
    }

    function SetFeeToken(address _token) public onlyOwnerOrGov sphereXGuardPublic(0x5c707ed9, 0x0842bcbb) {
        require(FeeToken != _token, "Can't swap to same token");
        emit NewFeeToken(_token, FeeToken);
        FeeToken = _token; // set address(0) to use ETH/BNB as main coin
    }

    function WithdrawFee(address _token, address _to) public onlyOwnerOrGov sphereXGuardPublic(0xa5024817, 0x8baa9f9c) {
        require(Reserve[_token] > 0, "Fee amount is zero");
        if (_token == address(0)) {
            payable(_to).transfer(Reserve[_token]);
        } else {
            TransferToken(_token, _to, Reserve[_token]);
        }
        Reserve[_token] = 0;
    }
}
