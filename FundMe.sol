// we need to do the following thinga
// 01: receive funds from users
// 02: withdraw funds to our wallet
// 03: set minimum funding limit in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
// importing our created library
import {PriceConverter} from './PriceConverter.sol';

contract FundMe{
    //attaching the price converter library to our contract uint256
    using PriceConverter for uint256;

    uint256 public MinimumUSD = 5e18;
    //keep tracking of the funders adress
    address[] public funders;
    //mapp adresses to amount funded
    mapping(address funder => uint256 amountfunded) public adressToAmountFunded;

    //storing the account / contract owner sdress for restricting some calls
    address public owner;
    constructor(){
        //set who is the owner at deployment
        owner = msg.sender;
    }

    //modifier for modifying how sertain codes excecutes
    modifier onlyOwner(){
                //implementing the restriction
        require(msg.sender == owner, "Sender is not the owner");
        _;
    }


    function Fund() public payable {
    //were setting the limit of amount of fund to be sent
    //1e18 is equivalent to 1 ETH
        // require(msg.value >= 1e18, "you didnt sent enough funds!");
        // require(GetConversionRate(msg.value) >= MinimumUSD, "you didnt sent enough funds!");
        
        require(msg.value.GetConversionRate() >= MinimumUSD, "you didnt sent enough funds!");

        funders.push(msg.sender);
        adressToAmountFunded[msg.sender] = adressToAmountFunded[msg.sender] + msg.value;
    }

    function Withdraw() public onlyOwner {

        for (uint256 FunderIndex = 0; FunderIndex < funders.length; FunderIndex++) 
        {
            //get adress to reset
            address funder = funders[FunderIndex];
            //get amount to reset
            adressToAmountFunded[funder] = 0;
        }
        //reset the adress of the funder
        funders = new address[](0);

        //withdraw the money

        //tranfer
        // payable (msg.sender).transfer(address(this).balance);

        //send
        // bool SendSuccess = payable(msg.sender).send(address(this).balance);
        // require(SendSuccess, "send failed");

        //call
        (bool CallSuccess, ) = payable(msg.sender).call{ value: address(this).balance} ("");

        require(CallSuccess, "call failed");
    }
}