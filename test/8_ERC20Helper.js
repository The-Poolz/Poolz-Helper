const ERC20Helper = artifacts.require("ERC20HelperMock")
const ERC20Token = artifacts.require("ERC20Token")
const constants = require("@openzeppelin/test-helpers/src/constants")
const { assert } = require("chai")
const truffleAssert = require("truffle-assertions")
const BigNumber = require("bignumber.js")

contract("ERC20 Helper tests", (accounts) => {
    let erc20Helper, contractBalance
    let token
    const amount = "1000"
    const owner = accounts[0]

    before(async () => {
        token = await ERC20Token.new("TEST token", "TEST")
        erc20Helper = await ERC20Helper.new()
        await token.approve(erc20Helper.address, constants.MAX_INT256)
    })

    beforeEach(async () => {
        await erc20Helper.transferInToken(token.address, owner, amount)
        contractBalance = await token.balanceOf(erc20Helper.address)
    })

    it("should send tokens to contract", async () => {
        await erc20Helper.transferInToken(token.address, owner, amount)
        const balance = await token.balanceOf(erc20Helper.address)
        assert.equal(BigNumber.sum(contractBalance, amount).toString(), balance.toString())
    })

    it("should send tokens from contract", async () => {
        await erc20Helper.transferToken(token.address, owner, contractBalance)
        const balance = await token.balanceOf(erc20Helper.address)
        assert.equal("0", balance.toString())
    })

    it("should approve using tokens", async () => {
        await erc20Helper.approveAllowanceERC20(token.address, owner, contractBalance)
        const allowance = await token.allowance(erc20Helper.address, owner)
        assert.equal(contractBalance.toString(), allowance.toString())
    })

    it("should revert invalid approved amount", async () => {
        await truffleAssert.reverts(
            erc20Helper.transferInToken(token.address, owner, constants.MAX_UINT256),
            "ERC20Helper: no allowance"
        )
    })

    it("should revert zero transfer call", async () => {
        await truffleAssert.reverts(erc20Helper.transferInToken(token.address, owner, "0"))
    })

    it("should revert zero approve amount", async () => {
        await truffleAssert.reverts(erc20Helper.approveAllowanceERC20(token.address, owner, "0"))
    })
})
