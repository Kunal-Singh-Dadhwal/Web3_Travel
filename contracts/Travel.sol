// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Travel {

    struct Ticket {
        address Owner;  
        string Name;        
        uint8 Price;

    }

    mapping (address => bool) admin

}