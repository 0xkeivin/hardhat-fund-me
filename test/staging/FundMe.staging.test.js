const { assert, expect } = require("chai")
const { getNamedAccounts, network, ethers } = require("hardhat")
const {
    isCallTrace
} = require("hardhat/internal/hardhat-network/stack-traces/message-trace")
const { developmentChains } = require("../../helper-hardhat-config")

developmentChains.includes(network.name)
    ? describe.skip
    : describe("FundMe-Staging", async () => {
          let fundMe
          let deployer
          const sendValue = ethers.utils.parseEther("52")
          beforeEach(async () => {
              deployer = (await getNamedAccounts()).deployer
              fundMe = await ethers.getContract("FundMe", deployer)
          })

          it("allows people to fund and withdraw", async () => {
              await fundMe.fund({ value: sendValue })
              await fundMe.withdraw()
              const endingBalance = await fundMe.provider.getBalance(
                  fundMe.balance
              )
              assert.equal(endingBalance.toString(), 0)
          })
      })
