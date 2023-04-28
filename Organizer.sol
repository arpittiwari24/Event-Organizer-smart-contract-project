// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract organizer 
{
    struct Event 
    {
        address host;
        string name;
        uint ticketNumber;
        uint date;
        uint price;
        uint ticketLeft;
    }

    mapping (uint => Event) public events;
    mapping (address=>mapping (uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint date,uint price,uint ticketNumber)  external {
        require(date>block.timestamp,"You can organize event for future");
        require(ticketNumber>0,"Please create more than 0 tickets");

        events[nextId] = Event(msg.sender,name,date,price,ticketNumber,ticketNumber);
        nextId++;
    }

    function buyTicket(uint id,uint quantity) external payable    {
        require(events[id].date!=0,"This event does not exist");
        require(block.timestamp<events[id].date,"Event has already occured");

        Event storage _event = events[id];
        require(msg.value == (_event.price*quantity),"Ether is not enough");
        require(_event.ticketLeft<=quantity,"Not enough tickets");
        _event.ticketLeft-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function transferTicket(uint id,uint quantity,address to) external {
        require(events[id].date!=0,"This event does not exist");
        require(block.timestamp<events[id].date,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}

