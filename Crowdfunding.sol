// SPDX-License-Identifier: UNLICENSE
pragma solidity >=0.5.0 <0.9.0;

contract Manager_Side{
    struct Request{
        string description;
        address payable receipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) votes;
    }
}


contract CrowdFunding is Manager_Side{
    mapping(address=>uint) Contributor;   // 00 -> 0
    address public Manager;
    uint public MinimumAmount; 
    uint public Deadline;
    uint public Target;
    uint public raisedAmount; 
    uint public numOfContributor;

 constructor(uint _target , uint _deadline){
     Target = _target;
     Deadline = block.timestamp + _deadline; // 10 sec + 3600 sec (60*60)
     MinimumAmount = 100 wei;
     Manager = msg.sender;
 }

 modifier Conditions{
     require(block.timestamp < Deadline, "Deadline has passed" );
     require(msg.value >= MinimumAmount, " Minimum Contribution should be 100 wei");
     _;
 }

 function sendEth() public payable Conditions{
     if(Contributor[msg.sender] == 0){
         numOfContributor ++;
     }
     Contributor[msg.sender] += msg.value;
     raisedAmount +=msg.value;
 }

function getContractBalance() public view returns(uint){
    return address(this).balance; 
}

function refund() public{
require(block.timestamp > Deadline && raisedAmount <Target, "you are not eligible for refund");
require(Contributor[msg.sender] >0);
address payable user = payable(msg.sender);
user.transfer(Contributor[msg.sender]);
Contributor[msg.sender] = 0;
}

mapping(uint => Request) public request;
 uint public numRequest ; // number of request

 modifier onlyManager
 {
     require(msg.sender == Manager, "only manager can call this function");
     _;
 }

 function createRequest (string memory _description, address payable _receipent, uint _value ) public{
     Request storage newRequest = request[numRequest];
     numRequest++;
     newRequest.description = _description;
     newRequest.receipient = _receipent;
     newRequest.value = _value;
     newRequest.completed = false;
     newRequest.noOfVoters =0;
 }

 function voteRequest (uint _requestNo) public {
     require(Contributor[msg.sender] > 0, "you must be a contributor");
     Request storage thisRequest = request[_requestNo];
     require(thisRequest.votes[msg.sender] == false, "you have already voted");
     thisRequest.votes[msg.sender] = true;
     thisRequest.noOfVoters++;
 }
 function makePayment(uint _requestNo)public onlyManager{
     require(raisedAmount >Target);
     Request storage thisRequest = request[_requestNo];
     require(thisRequest.completed == false, "The request has already cmpleted");
     require(thisRequest.noOfVoters > numOfContributor/2, "Majority do not support");
     thisRequest.receipient.transfer(thisRequest.value);
     thisRequest.completed = true;
 }

 



} 
