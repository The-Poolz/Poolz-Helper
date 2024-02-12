import { deployed } from '../scripts/deploy';
import { Nameable } from '../typechain-types';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Nameable tests', function () {
  let nameable: Nameable;
  let owner: SignerWithAddress;
  const name = 'TEST name';
  const version = '1.0.0';

  before(async () => {
    [owner] = await ethers.getSigners();
    nameable = await deployed('Nameable', name, version);
  });

  it('should return name of contract', async () => {
    const contractName = await nameable.name();
    expect(name).to.equal(contractName);
  });

  it('should return version of contract', async () => {
    const contractVersion = await nameable.version();
    expect(version).to.equal(contractVersion);
  });
});
