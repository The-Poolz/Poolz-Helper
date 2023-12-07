import { deployed } from '../scripts/deploy.ts';
import { ERC721HelperMock } from '../typechain-types';
import { ERC721Token } from '../typechain-types';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('ERC721 Helper tests', function () {
  let erc721Helper: ERC721HelperMock;
  let erc721Token: ERC721Token;
  let itemId: number = 1;
  let owner: SignerWithAddress;
  let user: SignerWithAddress;

  before(async () => {
    [owner, user] = await ethers.getSigners();
    //await deployed('ETHHelperMock')
    erc721Helper = await deployed('ERC721HelperMock');
    erc721Token = await deployed('ERC721Token');
    await erc721Token.setApprovalForAll(erc721Helper.address, true);
  });

  beforeEach(async () => {
    await erc721Token.awardItem(owner.address, itemId.toString());
  });

  afterEach(async () => {
    itemId++;
  });

  it('should transfer tokens in contract', async () => {
    await erc721Helper.transferNFTIn(erc721Token.address, itemId, owner.address);
    const ownerOfNFT = await erc721Token.ownerOf(itemId);
    expect(ownerOfNFT.toString()).to.be.equal(erc721Helper.address);
  });

  it('should TransferNFTOut tokens from contract', async () => {
    await erc721Helper.transferNFTOut(erc721Token.address, itemId - 1, owner.address);
    const ownerOfNFT = await erc721Token.ownerOf(itemId);
    expect(ownerOfNFT.toString()).to.be.equal(owner.address);
  });

  it('should setApproveForAllNFT', async () => {
    await erc721Helper.setApproveForAllNFT(erc721Token.address, user.address, true);
    const status = await erc721Token.isApprovedForAll(erc721Helper.address, user.address);
    expect(status).to.be.equal(true);
  });

  it('should return no allowance message', async () => {
    await expect(erc721Helper.transferNFTIn(erc721Token.address, itemId, user.address)).to.be.revertedWith(
      'No Allowance',
    );
  });
});
