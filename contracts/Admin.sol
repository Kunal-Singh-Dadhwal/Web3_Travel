// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Structs.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Admin {

    uint256 public balance;

    using Counters for Counters.Counter;
    Counters.Counter private _totalRoutes;
    Counters.Counter private _totalTickets;

    event Action(string ActionType);

    mapping (address => bool) isAdmin;
    mapping (uint256 => bool) routeExists;
    mapping (uint256 => Route) routes;
    mapping (uint256 => mapping(uint256 => address[])) ticketHolders;

    constructor() {
        isAdmin[msg.sender] = true;
    }

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Caller is not an admin");
        _;
    }

    function setAdmin(address _address, bool _status) external onlyAdmin {
        isAdmin[_address] = _status;
    }

    function checkAdmin(address _address) external view returns (bool) {
        return isAdmin[_address];
    }



    function addRoute(
        string memory name,
        string memory description,
        uint256 distance
    ) external onlyAdmin {
        require(bytes(name).length > 0, "Name must not be empty");
        require(distance == 0, "Distance must not be empty");
        _totalRoutes.increment();

        Route memory route;
        route.id = _totalRoutes.current();
        route.name = name;
        route.description = description;
        route.distance = distance;
        route.timestamp = currentTime();
        
        routes[route.id] = route;
        routeExists[route.id] = true;
        emit Action("Created a new Route");

    }

    function deleteRoute(uint256 routeId) public onlyAdmin {
        require(routeExists[routeId], "Route doesn't exist");
        for(uint256 slotId = 1; slotId <= _totalRoutes.current();slotId++){
            address [] memory holders = ticketHolders[routeId][slotId];
            require(
                holders.length == 0,
                "Cant delete route with purchased tickets"
            );
        }

        routes[routeId].deleted = true;
        routeExists[routeId] = false;

        emit Action("Deleted a route");        
    }

    function updateRoute(
        uint256 routeId,
        string memory name,
        string memory description,
        uint256 distance
    ) public onlyAdmin {
        require(routeExists[routeId], "Route doesn't exist");
        require((bytes(name).length > 0), "Name must not be empty");
        require(distance == 0, "Distance must not be empty");
        
        for (uint256 slotId = 1; slotId <= _totalRoutes.current(); slotId++){
            address [] storage holders = ticketHolders[routeId][slotId];
            require(
                holders.length == 0,
                "Cannot update route with purchased tickets"
            );
        }
        routes[routeId].name = name;
        routes[routeId].description = description;
        routes[routeId].distance = distance;
            
         emit Action("Updated a route"); 
     }

    function getRoutes() public view returns(Route[] memory Routes){
        uint256 totalRoutes;
        for(uint256 i = 1; i<= _totalRoutes.current();i++){
            if(!routes[i].deleted) totalRoutes++;
        }

        Routes = new Route[](totalRoutes);

        uint256 j = 0;
        for(uint256 i = 1;i <= _totalRoutes.current();i++){
            if(!routes[i].deleted){
                Routes[j] = routes[i];
                j++;
            }
        }
    }

    function getRouteTicketHolders(
        uint256 routeId,
        uint256 slotId
    ) public view returns (address[] memory) {
        return ticketHolders[routeId][slotId];
    }


    function withdrawTo(address reciever, uint256 amount) public onlyAdmin {
        require(balance >= amount, "Insufficient fund");
        balance -= amount;
        payTo(reciever, amount);
    }

    function payTo(address reciever, uint256 amount) internal { 
        require(reciever != address(0), "Reciver must be a valid address");
        (bool success, ) = payable(reciever).call{value: amount}("");
        require(success);
    }

    function currentTime() internal view returns (uint256) {
        uint256 newNum = (block.timestamp * 1000) + 1000;
        return newNum;
    }
}