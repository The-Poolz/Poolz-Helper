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
    const arr = await arrayLibrary.addIfNotExsist.staticCall(addrArray, copyElem);
    addrArray.push(copyElem);
    expect(arr.toString()).to.equal(addrArray.toString());
  });

  it('keep uint N Elements In Array', async () => {
    const arr = [1, 2, 46, 6, 9];
    const newArr = await arrayLibrary.keepNElementsInArray.staticCall(arr, 2);
    expect(newArr.toString()).to.equal(arr.slice(0, 2).toString());
    await expect(arrayLibrary.keepNElementsInArray(arr, 20)).to.be.revertedWithCustomError(arrayLibrary, "InvalidArrayLength")
    // return the same array if the length is the same
    const sameArr = await arrayLibrary.keepNElementsInArray.staticCall(arr, arr.length);
    expect(sameArr.toString()).to.equal(arr.toString());
  });

  it('keep address N Elements In Array', async () => {
    const [addr0, addr1, addr2, addr4] = await ethers.getSigners();
    const arr = [addr0.address, addr1.address, addr2.address, addr4.address];
    const newArr = await arrayLibrary.KeepNElementsInArray.staticCall(arr, 2);
    expect(newArr.toString()).to.equal(arr.slice(0, 2).toString());
    await expect(arrayLibrary.KeepNElementsInArray(arr, 20)).to.be.revertedWithCustomError(arrayLibrary, "InvalidArrayLength");
    // return the same array if the length is the same
    const sameArr = await arrayLibrary.KeepNElementsInArray.staticCall(arr, arr.length);
    expect(sameArr.toString()).to.equal(arr.toString());
  });

  it('is Array Ordered', async () => {
    await expect(arrayLibrary.isArrayOrdered([])).to.be.revertedWithCustomError(arrayLibrary, "ZeroArrayLength");
    const orderedArr = [1, 2, 3, 4, 5];
    const nonOrderedArr = [5, 8, 3, 19];
    let status = await arrayLibrary.isArrayOrdered.staticCall(orderedArr);
    expect(status).to.equal(true);
    status = await arrayLibrary.isArrayOrdered.staticCall(nonOrderedArr);
    expect(status).to.equal(false);
  });

  it('get sum array', async () => {
    const arr = [1, 2, 3, 4, 5];
    const sum = await arrayLibrary.getArraySum.staticCall(arr);
    expect(sum.toString()).to.equal(arr.reduce((a, b) => a + b, 0).toString());
  });

  it('is In Array', async () => {
    const [addr0, addr1, addr2, addr4] = await ethers.getSigners();
    const arr = [addr0.address, addr1.address, addr2.address];
    let status = await arrayLibrary.isInArray.staticCall(arr, addr0.address);
    expect(status).to.equal(true);
    status = await arrayLibrary.isInArray.staticCall(arr, addr4.address);
    expect(status).to.equal(false);
  });
});
