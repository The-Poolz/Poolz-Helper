import { ZERO_ADDRESS } from '../scripts/constants';
import { deployed } from '../scripts/deploy';
import { ERC20Token, FeeHelper, WhiteListMock } from '../typechain-types';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Fee Helper Test', function () {
  const fee: number = 100000;
  let token: ERC20Token;
  let payer: SignerWithAddress, receiver: SignerWithAddress;
  let feeHelper: FeeHelper;
  let Whitelist: WhiteListMock;

  before(async () => {
    [payer, receiver] = await ethers.getSigners();
    feeHelper = await deployed('FeeHelper');
    token = await deployed('ERC20Token', 'TEST token', 'TEST');
    Whitelist = await deployed('WhiteListMock');
  });

  it('zero fee', async () => {
    const gasPrice = 2500000000;
    const oldBal = await payer.getBalance();
    const feePaid = await feeHelper.connect(payer).callStatic.MethodWithFee({ gasPrice: gasPrice });
    const tx = await feeHelper.connect(payer).MethodWithFee({ gasPrice: gasPrice });
    const txReceipt = await tx.wait();
    const actualBal = await payer.getBalance();
    const gas = txReceipt.gasUsed.mul(gasPrice);
    const expectedBal = oldBal.sub(gas);
    expect(actualBal).to.be.equal(expectedBal);
    expect(feePaid).to.be.equal(0);
  });

  describe('test ERC20 token', async () => {
    it('should set fee token and amount', async () => {
      await feeHelper.setFee(token.address, fee);
      const feeToken = await feeHelper.FeeToken();
      const actualFee = await feeHelper.FeeAmount();
      expect(actualFee).to.be.equal(fee);
      expect(feeToken).to.be.equal(token.address);
    });

    it('should pay', async () => {
      await token.connect(payer).approve(feeHelper.address, fee);
      const oldBal = await token.balanceOf(feeHelper.address);
      const feePaid = await feeHelper.connect(payer).callStatic.MethodWithFee();
      await feeHelper.connect(payer).MethodWithFee();
      const actualBal = await token.balanceOf(feeHelper.address);
      expect(actualBal).to.be.equal(oldBal.add(fee));
      expect(feePaid).to.be.equal(fee);
    });

    it('should withdraw', async () => {
      await feeHelper.WithdrawFee(token.address, payer.address);
      const actualBal = await token.balanceOf(payer.address);
      expect(actualBal).to.be.equal(await token.totalSupply());
    });
  });

  describe('test ETH coin', async () => {
    it('should set fee token and amount', async () => {
      await feeHelper.setFee(ZERO_ADDRESS, fee);
      const feeToken = await feeHelper.FeeToken();
      const actualFee = await feeHelper.FeeAmount();
      expect(actualFee).to.be.equal(fee);
      expect(feeToken).to.be.equal(ZERO_ADDRESS);
    });

    it('should pay', async () => {
      const oldBal = await ethers.provider.getBalance(feeHelper.address);
      const feePaid = await feeHelper.connect(payer).callStatic.MethodWithFee({ value: fee });
      await feeHelper.connect(payer).MethodWithFee({ value: fee });
      const actualBal = await ethers.provider.getBalance(feeHelper.address);
      expect(actualBal).to.be.equal(oldBal.add(fee));
      expect(feePaid).to.be.equal(fee);
    });

    it("should revert when fee is not paid", async () => {
      await expect(feeHelper.connect(payer).MethodWithFee({value: fee / 2})).to.be.revertedWithCustomError(feeHelper, "NotEnoughFeeProvided");
    })

    it('should withdraw', async () => {
      const oldBal = await ethers.provider.getBalance(receiver.address);
      await feeHelper.WithdrawFee(ZERO_ADDRESS, receiver.address);
      const actualBal = await ethers.provider.getBalance(receiver.address);
      expect(actualBal).to.be.equal(oldBal.add(fee));
    });
  });

  describe("Whitelist Settings", async () => {

    it("should get 0 credits when whitelistAddress is not set", async () => {
      const credits = await feeHelper.getCredits(payer.address);
      expect(credits).to.be.equal(0);
    })

    it("should set whitelist address", async () => {
      const oldWhiteList = await feeHelper.WhiteListAddress()
      await feeHelper.setupNewWhitelist(Whitelist.address)
      const whiteList = await feeHelper.WhiteListAddress()
      const whiteListId = await feeHelper.WhiteListId()
      expect(whiteList).to.be.equal(Whitelist.address)
      expect(whiteList).to.not.equal(oldWhiteList)
      expect(whiteListId).to.be.equal(1)
    })

    it("should add and remove new users", async () => {
      const credits: number = fee * 5;
      await feeHelper.addUsers([payer.address], [credits])
      const _credits = await feeHelper.getCredits(payer.address);
      expect(credits).to.be.equal(_credits);
      await feeHelper.removeUsers([payer.address])
      const _credits2 = await feeHelper.getCredits(payer.address);
      expect(0).to.be.equal(_credits2);
    })

    it("should take full fee when user has not credits", async () => {
      await feeHelper.setFee(token.address, fee);
      await feeHelper.addUsers([payer.address], [0])
      const beforePayerBalance = await token.balanceOf(payer.address);
      await token.connect(payer).approve(feeHelper.address, fee);
      const feePaid = await feeHelper.connect(payer).callStatic.MethodWithFee();
      const tx = await feeHelper.connect(payer).MethodWithFee();
      const afterPayerBalance = await token.balanceOf(payer.address);
      expect(beforePayerBalance.sub(afterPayerBalance)).to.be.equal(fee);
      expect(await feeHelper.FeeToken()).to.be.equal(token.address);
      expect(feePaid).to.be.equal(fee);
      await expect(tx).to.emit(feeHelper, "TransferIn").withArgs(fee, payer.address, token.address);
    })

    it("should not take fee when user has credits", async () => {
      await feeHelper.setFee(token.address, fee);
      const credits = fee * 5;
      await feeHelper.addUsers([payer.address], [credits])
      const beforePayerBalance = await token.balanceOf(payer.address);
      const feePaid = await feeHelper.connect(payer).callStatic.MethodWithFee();
      const tx = await feeHelper.connect(payer).MethodWithFee();
      const afterPayerBalance = await token.balanceOf(payer.address);
      expect(beforePayerBalance).to.be.equal(afterPayerBalance);
      expect(await feeHelper.FeeToken()).to.be.equal(token.address);
      expect(feePaid).to.be.equal(0);
      await expect(tx).to.not.emit(feeHelper, "TransferIn");
    })

    it("should take partial fee when user has less credits than fee", async () => {
      await feeHelper.setFee(token.address, fee);
      const credits = fee / 2;
      await feeHelper.addUsers([payer.address], [credits])
      const beforePayerBalance = await token.balanceOf(payer.address);
      await token.connect(payer).approve(feeHelper.address, fee - credits);
      const feePaid = await feeHelper.connect(payer).callStatic.MethodWithFee();
      const tx = await feeHelper.connect(payer).MethodWithFee();
      const afterPayerBalance = await token.balanceOf(payer.address);
      expect(beforePayerBalance.sub(afterPayerBalance)).to.be.equal(fee - credits);
      expect(await feeHelper.FeeToken()).to.be.equal(token.address);
      expect(feePaid).to.be.equal(fee - credits);
      await expect(tx).to.emit(feeHelper, "TransferIn").withArgs(fee - credits, payer.address, token.address);
    })

  })
});
