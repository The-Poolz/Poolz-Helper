// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Helper.sol";
import "./ETHHelper.sol";
import "./GovManager.sol";

contract FeeHelper is ETHHelper, ERC20Helper, GovManager {
    uint256 public Fee;
    uint256 public Reserve;
    address public FeeToken;
    //mapping(address => uint256) FeeMap;

    modifier isZeroReserve() {
        require(Reserve > 0, "Fee amount is zero");
        _;
    }

    function PayFee() public payable {
        if (Fee > 0) {
            if (FeeToken == address(0)) {
                require(msg.value >= Fee, "Not Enough Fee Provided"); // check if tx.origin has paid the required fee amount
            } else {
                TransferInToken(FeeToken, tx.origin, Fee); // transfer ERC20 tokens to contract
            }
        }
        msg.value > Fee ? Reserve += msg.value : Reserve += Fee; // solves the problem if msg.value more than fee amount
    }

    function WithdrawFee(address payable _to) public isZeroReserve {
        if (FeeToken == address(0)) {
            _to.transfer(Reserve);
        } else {
            TransferToken(FeeToken, _to, Reserve);
        }
        Reserve = 0;
    }

    function setFee(uint256 _fee) public {
        Fee = _fee;
    }

    function setToken(address _token) public {
        if (Reserve > 0) {
            WithdrawFee(payable(tx.origin)); // If tries to set a new token without withrowing the old one
        }
        FeeToken = _token;
    }
}
