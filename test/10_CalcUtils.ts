import { ethers } from 'hardhat';
import { deployed } from '../scripts/deploy';
import { CalcUtilsMock } from '../typechain-types';
import { expect } from 'chai';

describe('CalcUtils library tests', function () {
  let calcUtils: CalcUtilsMock;
  const amount = ethers.parseUnits('100', 18);
  const halfRate = ethers.parseUnits('5', 20); // 50%

  before(async () => {
    calcUtils = await deployed('CalcUtilsMock');
  });

  it('should Calc Amount', async () => {
    expect(await calcUtils.calcAmount(amount, halfRate)).to.equal(amount / 2n);
  });

  it('should Calc Rate', async () => {
    expect(await calcUtils.calcRate(amount / 2n, amount)).to.equal(halfRate);
  });
});
