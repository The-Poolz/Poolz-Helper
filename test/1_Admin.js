const GovManager = artifacts.require('GovManager')
const EthHelper = artifacts.require('ETHHelper')
const PozBenefit = artifacts.require('PozBenefit')
const { assert } = require('chai');
const truffleAssert = require('truffle-assertions');

contract('Admin Tests', accounts => {
    let govInstance, ethInstance, pozInstance, fromAddress = accounts[0]

    before(async () => {
        govInstance = await GovManager.new()
        ethInstance =  await EthHelper.new()
        pozInstance = await PozBenefit.new()
    })

    it('should set and get Gov contract address', async () => {
        const govAddress = accounts[9]
        await govInstance.setGovernerContract(govAddress, {from: fromAddress})
        const result = await govInstance.GovernerContract()
        assert.equal(govAddress, result)
    })
    it('should set and get is payable', async () => {
        const payable = await ethInstance.IsPayble()
        await ethInstance.SwitchIsPayble({from: fromAddress})
        const result = await ethInstance.IsPayble()
        assert.equal(payable, !result)
    })
    it('should set and get is POZ timer', async () => {
        const timer = 1000
        await pozInstance.SetPozTimer(timer, {from: fromAddress})
        const result = await pozInstance.PozTimer()
        assert.equal(timer, result)
    })
    it('should set and get is POZ timer when called from Gov Address', async () => {
        const timer = 9000
        const govAddress = accounts[9]
        await pozInstance.setGovernerContract(govAddress, {from: fromAddress})
        await pozInstance.SetPozTimer(timer, {from: govAddress})
        const result = await pozInstance.PozTimer()
        assert.equal(timer, result)
    })
    it('should fail to set POZ timer when invalid value provided', async () => {
        const timer = 100000
        await truffleAssert.reverts(pozInstance.SetPozTimer(timer, {from: fromAddress}), 'Not in range')
    })
    it('should fail to set POZ timer when called without invalid address', async () => {
        const timer = 1000
        await truffleAssert.reverts(pozInstance.SetPozTimer(timer, {from: accounts[1]}), 'Authorization Error')
    })
    
})