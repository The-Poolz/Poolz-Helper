import { ZERO_ADDRESS } from '../scripts/constants';
import { deployed } from '../scripts/deploy';
import { GovManager, ETHHelper, PozBenefit } from '../typechain-types';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Admin Tests', function () {
  let govInstance: GovManager,
    ethInstance: ETHHelper,
    pozInstance: PozBenefit,
    owner: SignerWithAddress,
    addr: SignerWithAddress;

  before(async () => {
    [owner, addr] = await ethers.getSigners();
    govInstance = await deployed('GovManager');
    ethInstance = await deployed('ETHHelper');
    pozInstance = await deployed('PozBenefit');
  });

  it('should set and get Gov contract address', async () => {
    const govAddress = addr.address;
    const tx = await govInstance.connect(owner).setGovernorContract(govAddress);
    await tx.wait();
    const event = await govInstance.queryFilter(govInstance.filters.GovernorUpdated());
    const result = await govInstance.GovernorContract();
    expect(result).to.be.equal(govAddress);
    expect(event[0].args.oldGovernor).to.be.equal(ZERO_ADDRESS);
    expect(event[0].args.newGovernor).to.be.equal(govAddress);
  });

  it('should set and get is payable', async () => {
    const payable = await ethInstance.IsPayble();
    await ethInstance.connect(owner).SwitchIsPayble();
    const result = await ethInstance.IsPayble();
    expect(result).to.be.equal(!payable);
  });

  it('should set and get is POZ timer', async () => {
    const timer = 1000;
    await pozInstance.connect(owner).SetPozTimer(timer);
    const result = await pozInstance.PozTimer();
    expect(result).to.be.equal(timer);
  });

  it('should set and get is POZ timer when called from Gov Address', async () => {
    const timer = 9000;
    const govAddress = addr.address;
    await pozInstance.setGovernorContract(govAddress);
    await pozInstance.connect(addr).SetPozTimer(timer);
    const result = await pozInstance.PozTimer();
    expect(result).to.be.equal(timer);
  });

  it('should fail to set POZ timer when invalid value provided', async () => {
    const timer = 100000;
    await expect(pozInstance.SetPozTimer(timer)).to.be.revertedWith('Not in range');
  });

  it('should fail to set POZ timer when called without invalid address', async () => {
    await pozInstance.setGovernorContract(ZERO_ADDRESS);
    const timer = 1000;
    await expect(pozInstance.connect(addr).SetPozTimer(timer)).to.be.revertedWithCustomError(pozInstance, "AuthorizationError");
  });
});
