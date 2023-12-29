import { deployed } from '../scripts/deploy';
import { ERC20Token, ERC721Token } from '../typechain-types';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Token Test', function () {
  let owner: SignerWithAddress;
  let NFT: ERC721Token;
  let ERC20Token: ERC20Token;

  before(async () => {
    [owner] = await ethers.getSigners();
    NFT = await deployed('ERC721Token');
    ERC20Token = await deployed('ERC20Token', 'TEST token', 'TEST');
  });

  it('mint ERC20 tokens', async () => {
    const oldBalance = await ERC20Token.balanceOf(owner.address);
    const mintAmount = ethers.utils.parseUnits('500000', 18);
    await ERC20Token.FreeTest();
    const newBalance = await ERC20Token.balanceOf(owner.address);
    expect(newBalance).to.be.equal(oldBalance.add(mintAmount));
  });

  it('mint ERC721 token', async () => {
    const oldBalance = await NFT.balanceOf(owner.address);
    expect(oldBalance).to.be.equal(0);
    const nftURI = 'TEST 1';
    await NFT.awardItem(owner.address, nftURI);
    const newBalance = await NFT.balanceOf(owner.address);
    expect(newBalance).to.be.equal(oldBalance.add(1));
  });
});
