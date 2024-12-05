import { MAX_UINT256 } from '../scripts/constants';
import { deployed } from '../scripts/deploy';
import { ERC20HelperMock, ERC20Token } from '../typechain-types';
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers"
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('ERC20 Helper tests', function () {
  let erc20Helper: ERC20HelperMock;
  let contractBalance: bigint;
  let token: ERC20Token;
  const amount: bigint = ethers.parseUnits('1000', 5);
  let owner: SignerWithAddress;

  before(async () => {
    [owner] = await ethers.getSigners();
    token = await deployed('ERC20Token', 'TEST token', 'TEST');
    erc20Helper = await deployed('ERC20HelperMock');
    await token.approve(await erc20Helper.getAddress(), amount * 20n);
  });

  beforeEach(async () => {
    await erc20Helper.mockTransferInToken(token.getAddress(), amount);
    contractBalance = await token.balanceOf(await erc20Helper.getAddress());
  });

  it('should send tokens to contract', async () => {
    await erc20Helper.mockTransferInToken(token.getAddress(), amount);
    const balance = await token.balanceOf(await erc20Helper.getAddress());
    expect(contractBalance + amount).to.equal(balance);
  });

  it('should send tokens from contract', async () => {
    await erc20Helper.mockTransferToken(await token.getAddress(), await owner.getAddress(), contractBalance);
    const balance = await token.balanceOf(await erc20Helper.getAddress());
    expect('0').to.equal(balance.toString());
  });

  it('should approve using tokens', async () => {
    await erc20Helper.mockApproveAllowanceERC20(await token.getAddress(), await owner.getAddress(), contractBalance);
    const allowance = await token.allowance(await erc20Helper.getAddress(), await owner.getAddress());
    expect(contractBalance.toString()).to.be.equal(allowance.toString());
  });

  it('should revert invalid approved amount', async () => {
    await expect(erc20Helper.mockTransferInToken(await token.getAddress(), MAX_UINT256)).to.be.revertedWithCustomError(
      erc20Helper,
      'NoAllowance',
    );
  });

  it('should revert zero transfer call', async () => {
    await expect(erc20Helper.mockTransferInToken(await token.getAddress(), '0')).to.be.reverted;
  });

  it('should revert zero approve amount', async () => {
    await expect(erc20Helper.mockApproveAllowanceERC20(await token.getAddress(), owner.getAddress(), '0')).to.be.reverted;
  });
});
