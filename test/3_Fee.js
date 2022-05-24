const ERC20 = artifacts.require("ERC20Token")
const FeeHelper = artifacts.require("FeeHelper")
const FeeBaseHelper = artifacts.require("FeeBaseHelper")
const { assert } = require("chai")

contract("Fee Helper Test", accounts => {
    const contractOwner = accounts[0], fee = '100000'
    let token
    let feeHelper, feeBase

    before(async () => {
        feeHelper = await FeeHelper.new()
        const feeBaseAddr = (await feeHelper.BaseFee()).toString()
        feeBase = await FeeBaseHelper.at(feeBaseAddr)
        token = await ERC20.new('TEST token', 'TEST')
    })

    it('should set fee token', async () => {
        await feeHelper.SetFee(token.address, fee)
        const feeToken = await feeBase.FeeToken()
        const actualFee = await feeBase.Fee()
        assert.equal(actualFee, fee, 'invalid fee')
        assert.equal(feeToken, token.address, 'invalid token address')
    })

    it('should pay', async () => {
        const payer = accounts[1]
        await token.transfer(payer, fee)
        await token.approve(feeBase.address, fee, { from: payer })
        const oldBal = await token.balanceOf(feeBase.address)
        await feeHelper.PayFee({ from: payer })
        const actualBal = await token.balanceOf(feeBase.address)
        assert.equal(actualBal, parseInt(oldBal) + parseInt(fee))
    })

    it('should withdraw', async () => {
        await feeHelper.WithdrawFee(contractOwner)
        const actualBal = await token.balanceOf(contractOwner)
        assert.equal((await token.totalSupply()).toString(), actualBal.toString())
    })
})