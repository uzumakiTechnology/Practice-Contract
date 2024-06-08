// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

contract Banking {
    mapping(address => uint256) public balances;

    address payable owner; // owner of the contract
     
    constructor(){
        owner = payable(msg.sender);
    }

    // deposit money to our bank
    function deposit() public payable{
        require(msg.value > 0,"deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public  {
        require(msg.sender == owner,"Only ownner can withdraw funds");
        require(amount <= balances[msg.sender],"Insufficient funds");
        require(amount > 0, "Withdraw amount must be greater than 0");
        payable(msg.sender).transfer(amount);
        balances[msg.sender] -= amount;
    }

    function transfer(address payable recipient, uint256 amount) public{
        require(amount <= balances[msg.sender]);
        require(amount >  0, "Transfer amount must be greater than 0");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }

    function getBalance(address payable user) public view returns(uint256){
        return balances[user];
    }

    // Change the role
    function grantAccess(address payable user) public {
        require(msg.sender == owner,"Only owner can grant access");
        owner = user;
    }

    // remove access
    function revokeAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can revoke access");
        require(user != owner,"Cannot revoke access for the current owner");
        owner = payable(msg.sender);
    }
}