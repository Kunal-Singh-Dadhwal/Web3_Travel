// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Structs.sol";
import "./Admin.sol";

contract Travel is Ownable {
    // State variables
    mapping(uint256 => Structs.Ticket) public tickets;
    uint256 public ticketCount;
    uint256 public constant TICKET_PRICE = 0.1 ether;

    // Events
    event TicketPurchased(
        address indexed buyer,
        uint256 indexed ticketId,
        uint256 timestamp
    );

    /**
     * @dev Allows a user to purchase a ticket
     * @param _destination The destination for the ticket
     * @param _date The date of travel
     * @return ticketId The ID of the purchased ticket
     */
    function buyTicket(
        string memory _destination,
        uint256 _date
    ) external payable returns (uint256) {
        require(msg.value >= TICKET_PRICE, "Insufficient payment");
        require(_date > block.timestamp, "Invalid date");

        ticketCount++;

        tickets[ticketCount] = Structs.Ticket({
            id: ticketCount,
            owner: msg.sender,
            destination: _destination,
            date: _date,
            status: Structs.TicketStatus.ACTIVE
        });

        emit TicketPurchased(msg.sender, ticketCount, block.timestamp);

        // Return excess payment if any
        if (msg.value > TICKET_PRICE) {
            payable(msg.sender).transfer(msg.value - TICKET_PRICE);
        }

        return ticketCount;
    }
}
