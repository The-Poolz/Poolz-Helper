import { deployed } from '../scripts/deploy';
import { ETHHelperMock } from '../typechain-types';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('ETH Helper tests', function () {
  let ethHelper: ETHHelperMock, contractBalance;
  const minETHInvest: number = 1000;
  let owner: SignerWithAddress;

  before(async () => {
    [owner] = await ethers.getSigners();
    ethHelper = await deployed('ETHHelperMock');
  });

  beforeEach(async () => {
    await ethHelper.receiveETH(minETHInvest, { value: minETHInvest });
  });

  afterEach(async () => {
    await ethHelper.mockTransferETH(owner.address, minETHInvest);
  });

  it('should send eth to the contract', async () => {
    contractBalance = await ethers.provider.getBalance(ethHelper.address);
    expect(minETHInvest.toString()).to.be.equal(contractBalance.toString());
  });

  it('should revert invalid amount eth', async () => {
    await expect(ethHelper.receiveETH(minETHInvest, { value: minETHInvest / 2 })).to.be.revertedWithCustomError(
      ethHelper,
      'InvalidAmount',
    );
  });

  it('should revert default eth transfer', async () => {
    await expect(
      owner.sendTransaction({
        to: ethHelper.address,
        value: 100,
      }),
    ).to.be.reverted;
  });

  after(async () => {
    contractBalance = await ethers.provider.getBalance(ethHelper.address);
    expect('0').to.be.equal(contractBalance.toString());
  });
});
