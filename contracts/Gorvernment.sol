// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;


contract Government {
    address[] public citizens;
    address[] public officials;
    address payable owner;

    mapping(address => bool) public isOfficial;
    mapping(address => bool) public isCitizen;
    mapping(address => bool) public hasVoted; // keep track who have been voted
    mapping(address => uint256) public votesReceived; // number of vote receive for each officials

    constructor(){
        owner = payable(msg.sender);
    }

    event CitizenRegistered(address citizen);
    event OfficialRegistered(address official);
    event VoteCasted(address voter, address candidate);
    event LawProposed(address official, string proposal);

    function registerAsCitizen() public {
        require(!isOfficial[msg.sender],"Cannot register as citizen");
        require(!isCitizen[msg.sender], "Already registered as citizen");
        citizens.push(msg.sender);
        hasVoted[msg.sender] = false;
        emit CitizenRegistered(msg.sender);
    }

    function registerAsOfficial() public {
        require(!isOfficial[msg.sender],"Already registered as official");
        officials.push(msg.sender);
        isOfficial[msg.sender] = true;
        emit OfficialRegistered(msg.sender);
    }

    // Receive the address of Official who will be voted by citizens
    function vote(address candidate) public{
        require(!isOfficial[msg.sender],"Officials cannot vote");
        require(isCitizen[msg.sender], "Only citizens can vote");
        require(isOfficial[candidate],"Candidate must be registered as official"); // Whether the candidate address belong to isOfficial mapping
        require(!hasVoted[msg.sender],"Already voted");

        votesReceived[candidate]++;
        hasVoted[msg.sender] = true;
        emit VoteCasted(msg.sender, candidate);

    }

    function proposeLaw(string memory proposal) public{
        require(isOfficial[msg.sender],"Only Officials can propose law");
        emit LawProposed(msg.sender, proposal);

    }

    // Return total votes of candidate received
    function getCandidateVotes(address candidate) public view returns (uint256) {
        require(isOfficial[candidate],"Candidate must be registered as candidate");
        return votesReceived[candidate];
    }

    // return list of all citizens
    function getAllCitizens() public view returns (address[] memory) {
        return citizens;
    }

    // Returns the list of all officials
    function getAllOfficials() public view returns (address[] memory) {
        return officials;
    }

    // Returns the owner of the contract
    function getOwner() public view returns (address) {
        return owner;
    }

}