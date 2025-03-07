import { ethers } from 'hardhat';
import { deployed } from '../scripts/deploy';
import { MockLastPoolOwner } from '../typechain-types';
import { expect } from 'chai';

describe('LastPoolOwner abstract contract', function () {
  let lastPoolOwner: MockLastPoolOwner;
  const poolId = ethers.parseUnits('100', 18);

  before(async () => {
    lastPoolOwner = await deployed('MockLastPoolOwner');
  });

  it('should support IBeforeTransfer interface', async () => {
    expect(await lastPoolOwner.supportsInterface('0x1ffb811f')).to.be.true;
  });

  it('should support IERC165 interface', async () => {
    expect(await lastPoolOwner.supportsInterface('0x01ffc9a7')).to.be.true;
  });

  it('should return lastPoolOwner', async () => {
    const [addr0] = await ethers.getSigners();
    await lastPoolOwner.beforeTransfer(addr0.address, addr0.address, poolId);
    expect(await lastPoolOwner.getLastPoolOwner(poolId)).to.equal(addr0.address);
  });
});
