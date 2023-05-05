const EthHelper = artifacts.require("ETHHelperMock")
const { assert } = require("chai")
const truffleAssert = require("truffle-assertions")

contract("ETH Helper tests", (accounts) => {
    let ethHelper, contractBalance
    const minETHInvest = "1000"
    const owner = accounts[0]

    before(async () => {
        ethHelper = await EthHelper.new()
    })

    beforeEach(async () => {
        await ethHelper.receiveETH(minETHInvest, { value: minETHInvest })
    })

    afterEach(async () => {
        await ethHelper.transferETH(owner, minETHInvest)
    })

    it("should send eth to the contract", async () => {
        contractBalance = await web3.eth.getBalance(ethHelper.address)
        assert.equal(minETHInvest.toString(), contractBalance.toString())
    })

    it("should revert invalid amount eth", async () => {
        await truffleAssert.reverts(
            ethHelper.receiveETH(minETHInvest, { value: minETHInvest / 2 }),
            "Send ETH to invest"
        )
    })

    after(async () => {
        contractBalance = await web3.eth.getBalance(ethHelper.address)
        assert.equal("0", contractBalance.toString())
    })
})
