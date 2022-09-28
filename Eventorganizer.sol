// SPDX-License-Identifier : unlicense
pragma solidity >= 0.5.0 <0.9.0;

contract EventContract{

 struct Event{
     address organizer;
     string name;
     uint date;
     uint price;
     uint ticketcount;
     uint ticketRemain;
 }
 mapping(uint=>Event) public events;

 uint public nextid;
//  modifier Condition {
//      require(Event.date >block.timestamp, "You can oraganize event for future event");
//      require(Event.ticketcount >0, "you can organize event only if you more than 0 tricket");
//  }

 function createEvent    (string memory name, uint date, uint price, uint ticketcount)  external{
      require(date >block.timestamp, "You can oraganize event for future event");
     require(ticketcount >0, "you can organize event only if you more than 0 tricket");
     events[nextid] = Event(msg.sender,name,date,price,ticketcount, ticketcount);
     nextid++;
 }


 mapping(address=>mapping(uint=>uint)) public tickets;

function BuyTicket (uint id, uint quantity) external payable{
require(events[id].date!=0, "Event does not exist");
require(events[id].date >block.timestamp,"Event has been already occured");
Event storage _event = events[id];
require(msg.value == (_event.price*quantity ), "Ether is not sufficient");
require(_event.ticketRemain>=quantity,"Not Enough tickets");
_event.ticketRemain -= quantity;
tickets[msg.sender][id]+= quantity;

}

function transferTicket(uint id, uint quantity, address to) external{
require(events[id].date!=0, "Event does not exist");
require(events[id].date >block.timestamp,"Event has been already occured");
require(tickets[msg.sender][id]>=quantity, "You hav not enough tickets" );
tickets[msg.sender][id] -=quantity;
tickets[to][id] +=quantity;
}


}
