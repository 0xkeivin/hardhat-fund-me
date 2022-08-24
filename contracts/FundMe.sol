// SPDX-License-Identifier: MIT
// Pragma
pragma solidity ^0.8.8; // at least this version

// Imports
import "./PriceConverter.sol";

// Error Codes
error FundMe__NotOwner();

// Interfaces, Libraries, Contracts

/** @title A contract for crowd funding
 *  @author 0xkeivin
 *  @notice This contract is to demo a sample funding contract
 *  @dev This implements a price feed as a library
 */
contract FundMe {
    // Type Declarations
    using PriceConverter for uint256;
    // State Variables
    // uint256 public constant MINIMUM_USD = 50 * 1e18;
    uint256 public constant MINIMUM_USD = 50 * 10**18;
    /// keep a list of funding addresses
    address[] private s_funders;
    // dbug
    uint256 public s_convertedUsd;
    /// map of address to amount funded
    mapping(address => uint256) private s_addressToAmountFunded;
    // address public owner;
    address private immutable i_owner;
    // create an aggregator obj
    AggregatorV3Interface private s_priceFeed;

    // Modifiers
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "sender is not owner");
        /// custom error
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _; // represents the to-be run code
    }

    // Functions
    constructor(address priceFeedAddress) {
        // contract deployer = owner
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /** @notice Thisfunction funds this contract
     *  @dev This implements a price feed as a library
     */
    function fund() public payable {
        /// set minimum fund amount in USD
        /// min funding of 1eth
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Didn't send enough funds!"
        );
        /// debug
        s_convertedUsd = (msg.value.getConversionRate(s_priceFeed));
        /// saving to s_funders array
        s_funders.push(msg.sender);
        /// saving to a map
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    /// allows funder to withdraw
    function withdraw() public onlyOwner {
        // require(msg.sender == owner, "sender is not owner");
        /// for loop - reset s_funders mapping
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        /// reset array - 0 means 0 objects
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed, revering");
    }

    function cheaperWithdraw() public payable onlyOwner {
        // create a memory array
        address[] memory funders = s_funders;
        // mappings can't be in memory, sorry!!
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        /// reset array - 0 means 0 objects
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed, revering");
    }

    /// Getters
    function getMinUsd() public pure returns (uint256) {
        return MINIMUM_USD;
    }

    function getConvertedUsd() public view returns (uint256) {
        return s_convertedUsd;
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(address funderAddress)
        public
        view
        returns (uint256)
    {
        return s_addressToAmountFunded[funderAddress];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
