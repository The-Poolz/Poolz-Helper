import { ZERO_ADDRESS } from '../scripts/constants';
import { deployed } from '../scripts/deploy';
import { ERC20Token, FeeHelper } from '../typechain-types';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Fee Helper Test', function () {
  const fee: number = 100000;
  let token: ERC20Token;
  let payer: SignerWithAddress, receiver: SignerWithAddress;
  let feeHelper: FeeHelper;

  before(async () => {
    [payer, receiver] = await ethers.getSigners();
    feeHelper = await deployed('FeeHelper');
    token = await deployed('ERC20Token', 'TEST token', 'TEST');
  });

  it('zero fee', async () => {
    const gasPrice = 2500000000;
    const oldBal = await payer.getBalance();
    const tx = await feeHelper.connect(payer).MethodWithFee({ gasPrice: gasPrice });
    const txReceipt = await tx.wait();
    const actualBal = await payer.getBalance();
    const gas = txReceipt.gasUsed.mul(gasPrice);
    const expectedBal = oldBal.sub(gas);
    expect(actualBal).to.be.equal(expectedBal);
  });

  describe('test ERC20 token', async () => {
    it('should set fee token', async () => {
      await feeHelper.SetFeeAmount(fee);
      await feeHelper.SetFeeToken(token.address);
      const feeToken = await feeHelper.FeeToken();
      const actualFee = await feeHelper.FeeAmount();
      expect(actualFee).to.be.equal(fee);
      expect(feeToken).to.be.equal(token.address);
    });

    it('should pay', async () => {
      await token.connect(payer).approve(feeHelper.address, fee);
      const oldBal = await token.balanceOf(feeHelper.address);
      await feeHelper.connect(payer).MethodWithFee();
      const actualBal = await token.balanceOf(feeHelper.address);
      expect(actualBal).to.be.equal(oldBal.add(fee));
    });

    it('should withdraw', async () => {
      await feeHelper.WithdrawFee(token.address, payer.address);
      const actualBal = await token.balanceOf(payer.address);
      expect(actualBal).to.be.equal(await token.totalSupply());
    });
  });

  describe('test ETH coin', async () => {
    it('should set fee token', async () => {
      await feeHelper.SetFeeToken(ZERO_ADDRESS);
      const feeToken = await feeHelper.FeeToken();
      const actualFee = await feeHelper.FeeAmount();
      expect(actualFee).to.be.equal(fee);
      expect(feeToken).to.be.equal(ZERO_ADDRESS);
    });

    it('should pay', async () => {
      const oldBal = await ethers.provider.getBalance(feeHelper.address);
      await feeHelper.connect(payer).MethodWithFee({ value: fee });
      const actualBal = await ethers.provider.getBalance(feeHelper.address);
      expect(actualBal).to.be.equal(oldBal.add(fee));
    });

    it('should withdraw', async () => {
      const oldBal = await ethers.provider.getBalance(receiver.address);
      await feeHelper.WithdrawFee(ZERO_ADDRESS, receiver.address);
      const actualBal = await ethers.provider.getBalance(receiver.address);
      expect(actualBal).to.be.equal(oldBal.add(fee));
    });
  });

  describe("Whitelist Settings", async () => {
    it("should set whitelist address", async () => {
      const oldWhiteList = await feeHelper.WhiteListAddress()
      const newWhiteList = (await ethers.getSigners()).at(-1) as SignerWithAddress;
      await feeHelper.setWhiteListAddress(newWhiteList.address)
      const whiteList = await feeHelper.WhiteListAddress()
      expect(whiteList).to.be.equal(newWhiteList.address)
      expect(whiteList).to.not.equal(oldWhiteList)
      await feeHelper.setWhiteListAddress(oldWhiteList)
    })

    it("should set whitelist id", async () => {
      const oldWhiteListId = await feeHelper.WhiteListId()
      const newwhiteListId = 5
      await feeHelper.setWhiteListId(newwhiteListId)
      const whiteListId = await feeHelper.WhiteListId()
      expect(whiteListId).to.be.equal(newwhiteListId)
      expect(whiteListId).to.not.equal(oldWhiteListId)
    })
  })
});
