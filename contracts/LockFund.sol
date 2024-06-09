// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

contract LockFund { 
    address public owner;
    mapping(address => uint256) public lockedFunds; // who transfer into the contract and their amount
    mapping(address => uint256) public lockedTimeStamps; // the time at the moment user lock funds 
    mapping(address => uint256) public lockedPeriod;
    mapping(address => bool) public isWithdrawn;

    uint256 public lockDuration = 1 days;
    uint256 public lockDuration2 = 2 days;
    uint256 public lockDuration3 = 3 days;
    uint256 public reward1 = 1 ether;
    uint256 public reward2 = 1.5 ether;
    uint256 public reward3 = 2 ether;


    constructor(){
        owner = payable(msg.sender);
    }

    function lockFund(uint256 _value, uint256 _period) public payable {
        require(msg.value >= _value,"Please check your balance");
        lockedFunds[msg.sender] = _value;
        lockedPeriod[msg.sender] = _period;
        lockedTimeStamps[msg.sender] = block.timestamp;
    }

    function releaseFund() public{
        // this check ensure that at the moment user called this function, the time lock must be over
        require(block.timestamp >= lockedTimeStamps[msg.sender] + lockedPeriod[msg.sender],"Time lock not over yet");
        
        //  transfer the locked funds from the contract to the user who locked the funds.
        if(lockedPeriod[msg.sender] == 1){
            payable(msg.sender).transfer(lockedFunds[msg.sender] + reward1);
        }

        if(lockedPeriod[msg.sender] == 2){
            payable(msg.sender).transfer(lockedFunds[msg.sender] + reward2);
        }

        if(lockedPeriod[msg.sender] == 3){
            payable(msg.sender).transfer(lockedFunds[msg.sender] + reward3);
        }

        delete lockedFunds[msg.sender];
        delete lockedPeriod[msg.sender];
        delete lockedTimeStamps[msg.sender];
    }

    // only owner
    function withdraw() public {
        require(msg.sender == owner,"Only the owner can withdraw the funds");
        require(address(this).balance > 0,"No funds available to withdraw");
        payable(owner).transfer(address(this).balance); // transfers the entire balance of the contract to the owner's address
    }

}