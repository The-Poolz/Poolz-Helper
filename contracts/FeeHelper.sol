// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Helper.sol";
import "./ETHHelper.sol";
import "./GovManager.sol";

contract FeeHelper is ETHHelper, ERC20Helper, GovManager {
    uint256 public Fee;
    uint256 public Reserve;
    address public FeeToken;

    modifier isZeroReserve(uint256 _reserve) {
        require(_reserve > 0, "Fee amount is zero");
        _;
    }

    function PayFee() public payable {
        PayFee(FeeToken, Fee);
        Reserve += Fee;
    }

    function WithdrawFee(address payable _to) public onlyOwnerOrGov {
        WithdrawFee(FeeToken, _to, Reserve);
        Reserve = 0;
    }

    function PayFee(address _token, uint256 _fee) internal {
        if (_fee == 0) return;
        if (_token == address(0)) {
            require(msg.value >= _fee, "Not Enough Fee Provided");
        } else {
            TransferInToken(_token, msg.sender, _fee);
        }
    }

    function SetFee(address _token, uint256 _amount) external onlyOwnerOrGov {
        SetFeeToken(_token);
        Fee = _amount;
    }

    function SetFeeToken(address _token) public onlyOwnerOrGov {
        if (Reserve > 0 && _token != FeeToken) {
            WithdrawFee(payable(msg.sender)); // If the admin tries to set a new token without withrowing the old one
        }
        FeeToken = _token; // set address(0) to use ETH/BNB as main coin
    }

    function WithdrawFee(
        address _token,
        address payable _to,
        uint256 _reserve
    ) internal isZeroReserve(_reserve) {
        if (_token == address(0)) {
            _to.transfer(_reserve);
        } else {
            TransferToken(_token, _to, _reserve);
        }
    }
}
