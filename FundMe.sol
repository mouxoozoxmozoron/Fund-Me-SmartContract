// we need to do the following thinga
// 01: receive funds from users
// 02: withdraw funds to our wallet
// 03: set minimum funding limit in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
// importing our created library
import {PriceConverter} from './PriceConverter.sol';

//custom errors
error NOtOwner();

//currentl gas cost is 822282 for deployment
contract FundMe{
    //attaching the price converter library to our contract uint256
    using PriceConverter for uint256;

//introducing constant key word to reduce gas cost
//this constant key word comes with caps naming conversions

//doing so gas fee droped form 822282 to 802324
    uint256 public constant MINIMUM_USD = 5e18;
    //keep tracking of the funders adress
    address[] public funders;
    //mapp adresses to amount funded
    mapping(address funder => uint256 amountfunded) public adressToAmountFunded;

    //storing the account / contract owner sdress for restricting some calls
    // address public owner;

    //introducing immutable keyword to reduce gas too
    address public immutable i_owner;

    //this droped gas amount from 802324 to 778733 
    constructor(){
        //set who is the owner at deployment
        i_owner = msg.sender;
    }

    //modifier for modifying how sertain codes excecutes
    modifier onlyOwner(){
        //implementing the restriction
        // require(msg.sender == i_owner, "Sender is not the owner");
        if (msg.sender != i_owner) {
            revert NOtOwner();
        } // this reduces gas from 778733 to 753608 
        _;
    }


    function Fund() public payable {
    //were setting the limit of amount of fund to be sent
    //1e18 is equivalent to 1 ETH
        // require(msg.value >= 1e18, "you didnt sent enough funds!");
        // require(GetConversionRate(msg.value) >= MINIMUM_USD, "you didnt sent enough funds!");
        
        require(msg.value.GetConversionRate() >= MINIMUM_USD, "you didnt sent enough funds!");

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

    //receive fn incase msg.data is empty
    receive() external payable {
        Fund();
     }

     //fallback fn
     fallback() external payable {
        Fund();
      }
}