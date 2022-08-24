// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8; // at least this version

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        /// ABI
        /// Address - 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e ETH/USD
        // AggregatorV3Interface priceFeed = AggregatorV3Interface(
        //     0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        // );
        /// full data unpacking
        // (uint80 roundID, int price, uint startedAt, uint timeStamp, uint80 answeredInRound) = priceFeed;
        (, int256 price, , , ) = priceFeed.latestRoundData();
        /// ETH in terms of USD
        /// 1800.00000000 usd at time of editing
        /// msg.value -> 18 decimal places
        /// ETH/USD from priceFeed -> 8 decimal places
        /// returned value needs to have 10 more decimal places to match
        return uint256(price * 1e10); // 1**10
    }

    // function getVersion() internal view returns (uint256) {
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(
    //         0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
    //     );
    //     return priceFeed.version();
    // }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        // 2000_00000000000000000 = ETH / USD price
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
