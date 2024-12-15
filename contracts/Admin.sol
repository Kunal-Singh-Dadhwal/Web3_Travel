// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Structs.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Admin {

    using Counters for Counters.Counter;
    Counters.Counter private _totalRoutes;


    event Action(string ActionType);

    mapping (address => bool) public isAdmin;

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
        string memory description
    ) external onlyAdmin {
        require(bytes(name).length > 0, "Name must not be empty");
        
        _totalRoutes.increment();
        emit Action("Created a new Route");

    }
}