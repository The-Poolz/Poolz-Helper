const ERC721 = artifacts.require("ERC721Token")
const ERC20 = artifacts.require("ERC20Token")
const { assert } = require("chai")

contract("Token Test", accounts => {
    const contractOwner = accounts[0]
    let NFT
    let ERC20Token

    before(async () => {
        NFT = await ERC721.new()
        ERC20Token = await ERC20.new('TEST token', 'TEST')
    })

    it('mint ERC20 tokens', async () => {
        const oldBalance = parseInt(await ERC20Token.balanceOf(contractOwner))
        const mintAmount = 5000000
        await ERC20Token.FreeTest()
        const newBalance = await ERC20Token.balanceOf(contractOwner)
        assert.equal((oldBalance + mintAmount).toString(), newBalance.toString(), 'check ERC20 balance')
    })

    it('mint ERC721 token', async () => {
        const oldBalance = await NFT.balanceOf(contractOwner)
        assert.equal(oldBalance.toString(), '0', 'check NFT balance of')
        const nftURI = 'TEST 1'
        await NFT.awardItem(contractOwner, nftURI)
        const newBalance = await NFT.balanceOf(contractOwner)
        assert.equal(newBalance.toString(), '1', 'check NFT balance of')
    })
})