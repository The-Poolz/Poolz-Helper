const ArrayLibrary = artifacts.require("Array")
const { assert } = require("chai")
const constants = require("@openzeppelin/test-helpers/src/constants")

contract("array library test", accounts => {
    let arrayContract

    before(async () => {
        arrayContract = await ArrayLibrary.new()
    })

    it('should return slice array', async () => {
        const arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        const slicedArr = await arrayContract.KeepNElementsInArray(arr, 5)
        assert.equal(arr.slice(0, 5).toString(), slicedArr.toString())
    })

    it('should return sum of array', async () => {
        const arr = [1, 2, 3, 4, 5]
        const arrSum = await arrayContract.getArraySum(arr)
        assert.equal(arrSum, arr.reduce((a, b) => a + b, 0))
    })

    it('should return true if the element exists', async () => {
        const adrrArr = [constants.ZERO_ADDRESS, accounts[3], accounts[5]]
        let result = await arrayContract.isInArray(adrrArr, adrrArr[0])
        assert.equal(result, true)
        result = await arrayContract.isInArray(adrrArr, accounts[4])
        assert.equal(result, false)
    })
})