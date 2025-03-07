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
    const IBeforeTransferInterfaceId = '0x1ffb811f';
    expect(await lastPoolOwner.supportsInterface(IBeforeTransferInterfaceId)).to.be.true;
  });

  it('should support IERC165 interface', async () => {
    const IERC165InterfaceId = '0x01ffc9a7';
    expect(await lastPoolOwner.supportsInterface(IERC165InterfaceId)).to.be.true;
  });

  it('should return lastPoolOwner', async () => {
    const [addr0] = await ethers.getSigners();
    await lastPoolOwner.beforeTransfer(addr0.address, addr0.address, poolId);
    expect(await lastPoolOwner.getLastPoolOwner(poolId)).to.equal(addr0.address);
  });
});
