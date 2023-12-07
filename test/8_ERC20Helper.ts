import { MAX_UINT256 } from '../scripts/constants';
import { deployed } from '../scripts/deploy.ts';
import { ERC20HelperMock } from '../typechain-types';
import { ERC20Token } from '../typechain-types';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { BigNumber } from 'ethers';
import { utils } from 'ethers';
import { ethers } from 'hardhat';

describe('ERC20 Helper tests', function () {
  let erc20Helper: ERC20HelperMock;
  let contractBalance: BigNumber;
  let token: ERC20Token;
  const amount: BigNumber = utils.parseUnits('1000', 5);
  let owner: SignerWithAddress;

  before(async () => {
    [owner] = await ethers.getSigners();
    token = await deployed('ERC20Token', 'TEST token', 'TEST');
    erc20Helper = await deployed('ERC20HelperMock');
    await token.approve(erc20Helper.address, amount.mul(20));
  });

  beforeEach(async () => {
    await erc20Helper.transferInToken(token.address, owner.address, amount);
    contractBalance = await token.balanceOf(erc20Helper.address);
  });

  it('should send tokens to contract', async () => {
    await erc20Helper.transferInToken(token.address, owner.address, amount);
    const balance = await token.balanceOf(erc20Helper.address);
    expect(contractBalance.add(amount)).to.equal(balance);
  });

  it('should send tokens from contract', async () => {
    await erc20Helper.transferToken(token.address, owner.address, contractBalance);
    const balance = await token.balanceOf(erc20Helper.address);
    expect('0').to.equal(balance.toString());
  });

  it('should approve using tokens', async () => {
    await erc20Helper.approveAllowanceERC20(token.address, owner.address, contractBalance);
    const allowance = await token.allowance(erc20Helper.address, owner.address);
    expect(contractBalance.toString()).to.be.equal(allowance.toString());
  });

  it('should revert invalid approved amount', async () => {
    await expect(erc20Helper.transferInToken(token.address, owner.address, MAX_UINT256)).to.be.revertedWith(
      'ERC20Helper: no allowance',
    );
  });

  it('should revert zero transfer call', async () => {
    await expect(erc20Helper.transferInToken(token.address, owner.address, '0')).to.be.reverted;
  });

  it('should revert zero approve amount', async () => {
    await expect(erc20Helper.approveAllowanceERC20(token.address, owner.address, '0')).to.be.reverted;
  });
});
