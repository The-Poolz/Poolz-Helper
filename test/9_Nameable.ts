import { deployed } from '../scripts/deploy';
import { Nameable } from '../typechain-types';
import { expect } from 'chai';

describe('Nameable tests', function () {
  let nameable: Nameable;
  const name = 'TEST name';
  const version = '1.0.0';

  before(async () => {
    nameable = await deployed('NameableMock', name, version);
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
