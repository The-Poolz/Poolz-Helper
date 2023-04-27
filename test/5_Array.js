const ArraysMock = artifacts.require("ArraysMock")
const { assert } = require("chai")
const constants = require("@openzeppelin/test-helpers/src/constants")
const BigNumber = require("bignumber.js")
const truffleAssert = require("truffle-assertions")

contract("Array library", (accounts) => {
    let arrayLibrary

    before(async () => {
        arrayLibrary = await ArraysMock.new()
    })

    it("add array element if not exists", async () => {
        const addrArray = [accounts[0], accounts[1], accounts[2]]
        const newElem = accounts[3]
        const copyElem = accounts[0]
        const arr = await arrayLibrary.addIfNotExsist.call(addrArray, copyElem)
        const newArr = await arrayLibrary.addIfNotExsist.call(addrArray, newElem)
        assert.equal(arr.toString(), addrArray.toString())
        addrArray.push(newElem)
        assert.equal(newArr.toString(), addrArray.toString())
    })

    it("keep uint N Elements In Array", async () => {
        const arr = [1, 2, 46, 6, 9]
        const newArr = await arrayLibrary.keepNElementsInArray.call(arr, 2)
        assert.equal(arr.slice(0, 2).toString(), newArr.toString())
        await truffleAssert.reverts(arrayLibrary.keepNElementsInArray(arr, 20), "can't cut more then got")
        // return the same array if the length is the same
        const sameArr = await arrayLibrary.keepNElementsInArray.call(arr, arr.length)
        assert.equal(sameArr.toString(), arr.toString())
    })

    it("keep address N Elements In Array", async () => {
        const arr = [accounts[0], accounts[1], accounts[2], accounts[3]]
        const newArr = await arrayLibrary.KeepNElementsInArray.call(arr, 2)
        assert.equal(arr.slice(0, 2).toString(), newArr.toString())
        await truffleAssert.reverts(arrayLibrary.KeepNElementsInArray(arr, 20), "can't cut more then got")
        // return the same array if the length is the same
        const sameArr = await arrayLibrary.KeepNElementsInArray.call(arr, arr.length)
        assert.equal(sameArr.toString(), arr.toString())
    })

    it("is Array Ordered", async () => {
        await truffleAssert.reverts(arrayLibrary.isArrayOrdered([]), "array should be greater than zero")
        const orderedArr = [1, 2, 3, 4, 5]
        const nonOrderedArr = [5, 8, 3, 19]
        let status = await arrayLibrary.isArrayOrdered.call(orderedArr)
        assert.equal(status, true)
        status = await arrayLibrary.isArrayOrdered.call(nonOrderedArr)
        assert.equal(status, false)
    })

    it("get sum array", async () => {
        const arr = [1, 2, 3, 4, 5]
        const sum = await arrayLibrary.getArraySum.call(arr)
        assert.equal(sum.toString(), arr.reduce((a, b) => a + b, 0).toString())
    })

    it("is In Array", async () => {
        const arr = [accounts[0], accounts[1], accounts[2], accounts[3]]
        let status = await arrayLibrary.isInArray.call(arr, accounts[0])
        assert.equal(status, true)
        status = await arrayLibrary.isInArray.call(arr, accounts[7])
        assert.equal(status, false)
    })
})
