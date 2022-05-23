const ERC20 = artifacts.require("ERC20Token")
const FeeHelper = artifacts.require("FeeHelper")
const { assert } = require("chai")

contract("Fee Helper Test", accounts => {
    const contractOwner = accounts[0], fee = '100000'
    let token
    let feeHelper

    before(async () => {
        feeHelper = await FeeHelper.new()
        token = await ERC20.new('TEST token', 'TEST')
    })

    it('should set fee token', async () => {
        await feeHelper.SetFee(token.address, fee)
        const feeToken = await feeHelper.FeeToken()
        const actualFee = await feeHelper.Fee()
        assert.equal(actualFee, fee, 'invalid fee')
        assert.equal(feeToken, token.address, 'invalid token address')
    })

    it('should pay', async () => {
        const payer = accounts[1]
        await token.transfer(payer, fee)
        await token.approve(feeHelper.address, fee, { from: payer })
        const oldBal = await token.balanceOf(feeHelper.address)
        await feeHelper.PayFee({ from: payer })
        const actualBal = await token.balanceOf(feeHelper.address)
        assert.equal(actualBal, parseInt(oldBal) + parseInt(fee))
    })

    it('should withdraw', async () => {
        await feeHelper.WithdrawFee(contractOwner)
        const actualBal = await token.balanceOf(contractOwner)
        assert.equal((await token.totalSupply()).toString(), actualBal.toString())
    })
})