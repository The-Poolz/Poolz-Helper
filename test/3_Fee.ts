import { ZERO_ADDRESS } from '../scripts/constants';
import { deployed } from '../scripts/deploy';
import { ERC20Token, FeeHelper, WhiteListMock } from '../typechain-types';
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers"
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Fee Helper Test', function () {
  const fee: bigint = 100000n;
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
    const gasPrice = 2500000000n;
    const oldBal = await ethers.provider.getBalance(await payer.getAddress());
    const feePaid = await feeHelper.connect(payer).MethodWithFee.staticCall({ gasPrice: gasPrice });
    const tx = await feeHelper.connect(payer).MethodWithFee({ gasPrice: gasPrice });
    const txReceipt = await tx.wait()
    const actualBal = await payer.provider.getBalance(await payer.getAddress());
    if (txReceipt) {
      const gasCost = ethers.toBigInt(txReceipt.gasUsed) * ethers.toBigInt(tx.gasPrice)
      const expectedBal = oldBal - gasCost;
      expect(actualBal).to.be.equal(expectedBal);
      expect(feePaid).to.be.equal(0);
    }
  });

  describe('test ERC20 token', async () => {
    it('should set fee token and amount', async () => {
      await feeHelper.setFee(await token.getAddress(), fee);
      const feeToken = await feeHelper.feeToken();
      const actualFee = await feeHelper.feeAmount();
      expect(actualFee).to.be.equal(fee);
      expect(feeToken).to.be.equal(await token.getAddress());
    });

    it('should pay', async () => {
      await token.connect(payer).approve(await feeHelper.getAddress(), fee);
      const oldBal = await token.balanceOf(await feeHelper.getAddress());
      const feePaid = await feeHelper.connect(payer).MethodWithFee.staticCall();
      await feeHelper.connect(payer).MethodWithFee();
      const actualBal = await token.balanceOf(await feeHelper.getAddress());
      expect(actualBal).to.be.equal(oldBal + fee);
      expect(feePaid).to.be.equal(fee);
    });

    it('should withdraw', async () => {
      await feeHelper.withdrawFee(await token.getAddress(), await payer.getAddress());
      const actualBal = await token.balanceOf(await payer.getAddress());
      expect(actualBal).to.be.equal(await token.totalSupply());
    });
  });

  describe('test ETH coin', async () => {
    it('should set fee token and amount', async () => {
      await feeHelper.setFee(ZERO_ADDRESS, fee);
      const feeToken = await feeHelper.feeToken();
      const actualFee = await feeHelper.feeAmount();
      expect(actualFee).to.be.equal(fee);
      expect(feeToken).to.be.equal(ZERO_ADDRESS);
    });

    it('should pay', async () => {
      const oldBal = await ethers.provider.getBalance(await feeHelper.getAddress());
      const feePaid = await feeHelper.connect(payer).MethodWithFee.staticCall({ value: fee });
      await feeHelper.connect(payer).MethodWithFee({ value: fee });
      const actualBal = await ethers.provider.getBalance(await feeHelper.getAddress());
      expect(actualBal).to.be.equal(oldBal + fee);
      expect(feePaid).to.be.equal(fee);
    });

    it("should revert when fee is not paid", async () => {
      await expect(feeHelper.connect(payer).MethodWithFee({value: fee / 2n})).to.be.revertedWithCustomError(feeHelper, "NotEnoughFeeProvided");
    })

    it('should withdraw', async () => {
      const oldBal = await ethers.provider.getBalance(await receiver.getAddress());
      await feeHelper.withdrawFee(ZERO_ADDRESS, await receiver.getAddress());
      const actualBal = await ethers.provider.getBalance(await receiver.getAddress());
      expect(actualBal).to.be.equal(oldBal + fee);
    });
  });

  describe("Whitelist Settings", async () => {

    it("should get 0 credits when whitelistAddress is not set", async () => {
      const credits = await feeHelper.getCredits(await payer.getAddress());
      expect(credits).to.be.equal(0);
    })

    it("should set whitelist address", async () => {
      const oldWhiteList = await feeHelper.whiteListAddress()
      await feeHelper.setupNewWhitelist(await Whitelist.getAddress())
      const whiteList = await feeHelper.whiteListAddress()
      const whiteListId = await feeHelper.whiteListId()
      expect(whiteList).to.be.equal(await Whitelist.getAddress())
      expect(whiteList).to.not.equal(oldWhiteList)
      expect(whiteListId).to.be.equal(1)
    })

    it("should add and remove new users", async () => {
      const credits: bigint = fee * 5n;
      await feeHelper.addUsers([await payer.getAddress()], [credits])
      const _credits = await feeHelper.getCredits(await payer.getAddress());
      expect(credits).to.be.equal(_credits);
      await feeHelper.removeUsers([await payer.getAddress()])
      const _credits2 = await feeHelper.getCredits(await payer.getAddress());
      expect(0).to.be.equal(_credits2);
    })

    it("should take full fee when user has not credits", async () => {
      await feeHelper.setFee(await token.getAddress(), fee);
      await feeHelper.addUsers([await payer.getAddress()], [0])
      const beforePayerBalance = await token.balanceOf(await payer.getAddress());
      await token.connect(payer).approve(await feeHelper.getAddress(), fee);
      const feePaid = await feeHelper.connect(payer).MethodWithFee.staticCall();
      const tx = await feeHelper.connect(payer).MethodWithFee();
      const afterPayerBalance = await token.balanceOf(await payer.getAddress());
      expect(beforePayerBalance - afterPayerBalance).to.be.equal(fee);
      expect(await feeHelper.feeToken()).to.be.equal(await token.getAddress());
      expect(feePaid).to.be.equal(fee);
      await expect(tx).to.emit(feeHelper, "TransferIn").withArgs(fee, await payer.getAddress(), await token.getAddress());
    })

    it("should not take fee when user has credits", async () => {
      await feeHelper.setFee(await token.getAddress(), fee);
      const credits = fee * 5n;
      await feeHelper.addUsers([await payer.getAddress()], [credits])
      const beforePayerBalance = await token.balanceOf(await payer.getAddress());
      const feePaid = await feeHelper.connect(payer).MethodWithFee.staticCall();
      const tx = await feeHelper.connect(payer).MethodWithFee();
      const afterPayerBalance = await token.balanceOf(await payer.getAddress());
      expect(beforePayerBalance).to.be.equal(afterPayerBalance);
      expect(await feeHelper.feeToken()).to.be.equal(await token.getAddress());
      expect(feePaid).to.be.equal(0);
      await expect(tx).to.not.emit(feeHelper, "TransferIn");
    })

    it("should take partial fee when user has less credits than fee", async () => {
      await feeHelper.setFee(await token.getAddress(), fee);
      const credits = fee / 2n;
      await feeHelper.addUsers([await payer.getAddress()], [credits])
      const beforePayerBalance = await token.balanceOf(await payer.getAddress());
      await token.connect(payer).approve(await feeHelper.getAddress(), fee - credits);
      const feePaid = await feeHelper.connect(payer).MethodWithFee.staticCall();
      const tx = await feeHelper.connect(payer).MethodWithFee();
      const afterPayerBalance = await token.balanceOf(await payer.getAddress());
      expect(beforePayerBalance - afterPayerBalance).to.be.equal(fee - credits);
      expect(await feeHelper.feeToken()).to.be.equal(await token.getAddress());
      expect(feePaid).to.be.equal(fee - credits);
      await expect(tx).to.emit(feeHelper, "TransferIn").withArgs(fee - credits, await payer.getAddress(), await token.getAddress());
    })

  })
});
