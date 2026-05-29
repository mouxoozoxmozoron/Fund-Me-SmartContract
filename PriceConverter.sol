// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
//just importing the interface to be able to use it
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter{
    
    function GetPrice() internal  view returns (uint256){
        //adress = 0x694AA1769357215DE4FAC081bf1f309aDC325306 //this is for ETH/USD
        //ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function GetConversionRate(uint256 ethAmount) internal view returns (uint256) {
        //let do some mathematics here
        uint256 ethPrice = GetPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd;
    }
}