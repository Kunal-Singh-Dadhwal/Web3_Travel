// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Route {
    uint256 id;
    string name;
    uint256 distance;
    uint256 timestamp;
    bool deleted;
}

struct Ticket {
    uint256 id;
    uint256 routeId;
    address passenger;
    uint256 price;
    uint256 timestamp;
    uint256 date;
    uint256 startTime;
    uint256 endTime;
    uint256 duration;
}