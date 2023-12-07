import { ZERO_ADDRESS } from '../scripts/constants.ts';
import { deployed } from '../scripts/deploy.ts';
import { ERC20Token } from '../typechain-types';
import { FeeHelper } from '../typechain-types';
import { FeeBaseHelper } from '../typechain-types';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Fee Helper Test', function () {
  const fee: number = 100000;
  let token: ERC20Token;
  let payer: SignerWithAddress, receiver: SignerWithAddress;
  let feeHelper: FeeHelper, feeBase: FeeBaseHelper;

  before(async () => {
    [payer, receiver] = await ethers.getSigners();
    feeHelper = await deployed('FeeHelper');
    const FeeBaseHelper = await ethers.getContractFactory('FeeBaseHelper');
    feeBase = await FeeBaseHelper.attach(await feeHelper.BaseFee());
    token = await deployed('ERC20Token', 'TEST token', 'TEST');
  });

  it('zero fee', async () => {
    const gasPrice = 250000000000;
    const oldBal = await payer.getBalance();
    const tx = await feeHelper.connect(payer).PayFee({ gasPrice: 250000000000 });
    const txReceipt = await tx.wait();
    const actualBal = await payer.getBalance();
    const gas = txReceipt.gasUsed.mul(gasPrice);
    const expectedBal = oldBal.sub(gas);
    expect(actualBal).to.be.equal(expectedBal);
  });

  describe('test ERC20 token', async () => {
    it('should set fee token', async () => {
      await feeHelper.SetFee(fee);
      await feeHelper.SetToken(token.address);
      const feeToken = await feeBase.FeeToken();
      const actualFee = await feeBase.Fee();
      expect(actualFee).to.be.equal(fee);
      expect(feeToken).to.be.equal(token.address);
    });

    it('should pay', async () => {
      await token.connect(payer).approve(feeHelper.address, fee);
      const oldBal = await token.balanceOf(feeBase.address);
      await feeHelper.connect(payer).PayFee();
      const actualBal = await token.balanceOf(feeBase.address);
      expect(actualBal).to.be.equal(oldBal.add(fee));
    });

    it('should withdraw', async () => {
      await feeHelper.WithdrawFee(payer.address);
      const actualBal = await token.balanceOf(payer.address);
      expect(actualBal).to.be.equal(await token.totalSupply());
    });
  });

  describe('test ETH coin', async () => {
    it('should set fee token', async () => {
      await feeHelper.SetToken(ZERO_ADDRESS);
      const feeToken = await feeBase.FeeToken();
      const actualFee = await feeBase.Fee();
      expect(actualFee).to.be.equal(fee);
      expect(feeToken).to.be.equal(ZERO_ADDRESS);
    });

    it('should pay', async () => {
      const oldBal = await ethers.provider.getBalance(feeBase.address);
      await feeHelper.connect(payer).PayFee({ value: fee });
      const actualBal = await ethers.provider.getBalance(feeBase.address);
      expect(actualBal).to.be.equal(oldBal.add(fee));
    });

    it('should withdraw', async () => {
      const oldBal = await ethers.provider.getBalance(receiver.address);
      await feeHelper.WithdrawFee(receiver.address);
      const actualBal = await ethers.provider.getBalance(receiver.address);
      expect(actualBal).to.be.equal(oldBal.add(fee));
    });
  });
});
