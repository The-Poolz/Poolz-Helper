// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Helper.sol";
import "./GovManager.sol";
import "./interfaces/IWhiteList.sol";

abstract contract FeeBaseHelper is ERC20Helper, GovManager {
    event TransferInETH(uint Amount, address From);
    event NewFeeAmount(uint NewFeeAmount, uint OldFeeAmount);
    event NewFeeToken(address NewFeeToken, address OldFeeToken);

    error NotEnoughFeeProvided();
    error FeeAmountIsZero();
    error TransferFailed();

    uint public FeeAmount;
    uint public WhiteListId;
    address public FeeToken;
    address public WhiteListAddress;
    mapping(address => uint) public FeeReserve;

    function TakeFee() internal virtual firewallProtected {
        uint feeToPay = FeeAmount;
        if(feeToPay == 0) return;
        uint credits = getCredits(msg.sender);
        if(credits > 0) {
            if(credits < feeToPay) {
                feeToPay -= credits;
                IWhiteList(WhiteListAddress).Register(msg.sender, WhiteListId, credits);
            } else {
                feeToPay = 0;
                IWhiteList(WhiteListAddress).Register(msg.sender, WhiteListId, feeToPay);
            }
        }
        if( feeToPay == 0 ) return;
        if (FeeToken == address(0)) {
            if (msg.value < feeToPay) revert NotEnoughFeeProvided();
            emit TransferInETH(msg.value, msg.sender);
        } else {
            TransferInToken(FeeToken, msg.sender, feeToPay);
        }
        FeeReserve[FeeToken] += feeToPay;
    }

    function getCredits(address _user) public view returns(uint) {
        if(WhiteListAddress == address(0) || WhiteListId == 0) return 0;
        return IWhiteList(WhiteListAddress).Check(_user, WhiteListId);
    }

    function SetFeeAmount(uint _amount) external firewallProtected onlyOwnerOrGov {
        emit NewFeeAmount(_amount, FeeAmount);
        FeeAmount = _amount;
    }

    function SetFeeToken(address _token) external firewallProtected onlyOwnerOrGov {
        emit NewFeeToken(_token, FeeToken);
        FeeToken = _token; // set address(0) to use ETH/BNB as main coin
    }

    function setWhiteListAddress(address _whiteListAddr) public onlyOwnerOrGov {
        WhiteListAddress = _whiteListAddr;
    }

    function setWhiteListId(uint _id) public onlyOwnerOrGov {
        WhiteListId = _id;
    }

    function WithdrawFee(address _token, address _to) external firewallProtected onlyOwnerOrGov {
        if (FeeReserve[_token] == 0) revert FeeAmountIsZero();
        if (_token == address(0)) {
            (bool success, ) = _to.call{value: FeeReserve[_token]}("");
            if (!success) revert TransferFailed();
        } else {
            TransferToken(_token, _to, FeeReserve[_token]);
        }
        FeeReserve[_token] = 0;
    }
}
