import { deployed } from '../scripts/deploy';
import { ArraysMock } from '../typechain-types';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Array library', function () {
  let arrayLibrary: ArraysMock;

  before(async () => {
    arrayLibrary = await deployed('ArraysMock');
  });

  it('add array element if not exists', async () => {
    const [addr0, addr1, addr2, addr4] = await ethers.getSigners();
    const addrArray = [addr0.address, addr1.address, addr2.address];
    const copyElem = addr4.address;
    const arr = await arrayLibrary.callStatic.addIfNotExsist(addrArray, copyElem);
    addrArray.push(copyElem);
    expect(arr.toString()).to.equal(addrArray.toString());
  });

  it('keep uint N Elements In Array', async () => {
    const arr = [1, 2, 46, 6, 9];
    const newArr = await arrayLibrary.callStatic.keepNElementsInArray(arr, 2);
    expect(newArr.toString()).to.equal(arr.slice(0, 2).toString());
    await expect(arrayLibrary.keepNElementsInArray(arr, 20)).to.be.revertedWith("can't cut more then got");
    // return the same array if the length is the same
    const sameArr = await arrayLibrary.callStatic.keepNElementsInArray(arr, arr.length);
    expect(sameArr.toString()).to.equal(arr.toString());
  });

  it('keep address N Elements In Array', async () => {
    const [addr0, addr1, addr2, addr4] = await ethers.getSigners();
    const arr = [addr0.address, addr1.address, addr2.address, addr4.address];
    const newArr = await arrayLibrary.callStatic.KeepNElementsInArray(arr, 2);
    expect(newArr.toString()).to.equal(arr.slice(0, 2).toString());
    await expect(arrayLibrary.KeepNElementsInArray(arr, 20)).to.be.revertedWith("can't cut more then got");
    // return the same array if the length is the same
    const sameArr = await arrayLibrary.callStatic.KeepNElementsInArray(arr, arr.length);
    expect(sameArr.toString()).to.equal(arr.toString());
  });

  it('is Array Ordered', async () => {
    await expect(arrayLibrary.isArrayOrdered([])).to.be.revertedWith('array should be greater than zero');
    const orderedArr = [1, 2, 3, 4, 5];
    const nonOrderedArr = [5, 8, 3, 19];
    let status = await arrayLibrary.callStatic.isArrayOrdered(orderedArr);
    expect(status).to.equal(true);
    status = await arrayLibrary.callStatic.isArrayOrdered(nonOrderedArr);
    expect(status).to.equal(false);
  });

  it('get sum array', async () => {
    const arr = [1, 2, 3, 4, 5];
    const sum = await arrayLibrary.callStatic.getArraySum(arr);
    expect(sum.toString()).to.equal(arr.reduce((a, b) => a + b, 0).toString());
  });

  it('is In Array', async () => {
    const [addr0, addr1, addr2, addr4] = await ethers.getSigners();
    const arr = [addr0.address, addr1.address, addr2.address];
    let status = await arrayLibrary.callStatic.isInArray(arr, addr0.address);
    expect(status).to.equal(true);
    status = await arrayLibrary.callStatic.isInArray(arr, addr4.address);
    expect(status).to.equal(false);
  });
});
