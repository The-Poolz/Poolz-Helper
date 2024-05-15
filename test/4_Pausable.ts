import { deployed } from '../scripts/deploy';
import { PausableHelper } from '../typechain-types';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('PausableHelper', function () {
  let pausableHelper: PausableHelper;

  before(async () => {
    pausableHelper = await deployed('PausableHelper');
  });

  it('should revert invalid user access', async () => {
    const [, addr1] = await ethers.getSigners();
    await expect(pausableHelper.connect(addr1).pause()).to.be.revertedWithCustomError(pausableHelper, "AuthorizationError")
    await expect(pausableHelper.connect(addr1).unpause()).to.be.revertedWithCustomError(pausableHelper, "AuthorizationError");
  });

  it('check pause event', async () => {
    const [addr0] = await ethers.getSigners();
    const tx = await pausableHelper.connect(addr0).pause();
    await tx.wait();
    const event = await pausableHelper.queryFilter(pausableHelper.filters.Paused());
    const data = event[event.length - 1].args;
    expect(data.account).to.be.equal(addr0.address);
  });

  it('check unpause event', async () => {
    const [addr0] = await ethers.getSigners();
    const tx = await pausableHelper.connect(addr0).unpause();
    await tx.wait();
    const event = await pausableHelper.queryFilter(pausableHelper.filters.Unpaused());
    const data = event[event.length - 1].args;
    expect(data.account).to.be.equal(addr0.address);
  });
});
