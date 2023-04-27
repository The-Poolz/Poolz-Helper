const PausableHelper = artifacts.require("PausableHelper")
const truffleAssert = require("truffle-assertions")
const { assert } = require("chai")
const constants = require("@openzeppelin/test-helpers/src/constants")
const BigNumber = require("bignumber.js")

contract("PausableHelper", (accounts) => {
  let pausableHelper

  before(async () => {
    pausableHelper = await PausableHelper.new()
  })

  it("should revert invalid user access", async () => {
    await truffleAssert.reverts(
      pausableHelper.pause({ from: accounts[2] }),
      "Authorization Error"
    )
    await truffleAssert.reverts(
      pausableHelper.unpause({ from: accounts[2] }),
      "Authorization Error"
    )
  })

  it("check pause event", async () => {
    const tx = await pausableHelper.pause()
    assert.equal(tx.logs[0].args.account.toString(), accounts[0].toString())
  })

  it("check unpause event", async () => {
    const tx = await pausableHelper.unpause()
    assert.equal(tx.logs[0].args.account.toString(), accounts[0].toString())
  })
})
