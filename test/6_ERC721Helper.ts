import { deployed } from '../scripts/deploy';
import { ERC721HelperMock, ERC721Token } from '../typechain-types';
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers"
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
  });

  beforeEach(async () => {
    await erc721Token.awardItem(await owner.getAddress(), itemId.toString());
    const status = await erc721Token.isApprovedForAll(await erc721Helper.getAddress(), await user.getAddress());
    if (!status) {
      await erc721Token.setApprovalForAll(await erc721Helper.getAddress(), true);
    }
  });

  afterEach(async () => {
    itemId++;
  });

  it('should transfer tokens in contract', async () => {
    await erc721Helper.mockTransferNFTIn(await erc721Token.getAddress(), itemId, await owner.getAddress());
    const ownerOfNFT = await erc721Token.ownerOf(itemId);
    expect(ownerOfNFT.toString()).to.be.equal(await erc721Helper.getAddress());
  });

  it('should transfer NFT token after approve', async () => {
    await erc721Token.setApprovalForAll(await erc721Helper.getAddress(), false);
    await erc721Token.approve(await erc721Helper.getAddress(), itemId);
    await erc721Helper.mockTransferNFTIn(await erc721Token.getAddress(), itemId, await owner.getAddress());
    const ownerOfNFT = await erc721Token.ownerOf(itemId);
    expect(ownerOfNFT.toString()).to.be.equal(await erc721Helper.getAddress());
  });

  it('should TransferNFTOut tokens from contract', async () => {
    await erc721Helper.mockTransferNFTOut(await erc721Token.getAddress(), itemId - 1, await owner.getAddress());
    const ownerOfNFT = await erc721Token.ownerOf(itemId);
    expect(ownerOfNFT.toString()).to.be.equal(await owner.getAddress());
  });

  it('should setApproveForAllNFT', async () => {
    await erc721Helper.mockSetApproveForAllNFT(await erc721Token.getAddress(), await user.getAddress(), true);
    const status = await erc721Token.isApprovedForAll(await erc721Helper.getAddress(), await user.getAddress());
    expect(status).to.be.equal(true);
  });

  it('should return no allowance message', async () => {
    await expect(erc721Helper.mockTransferNFTIn(await erc721Token.getAddress(), itemId, await user.getAddress())).to.be.revertedWithCustomError(
      erc721Helper,
      'NoAllowance',
    );
  });
});
