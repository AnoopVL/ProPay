// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract payProj {
    // 1. Declare the owner of the contract
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // 2. Define struct and other public variables
    struct request {
        address requestor;
        uint256 amount;
        string message;
        string name;
    }
    struct sendRecieve {
        string action;
        uint256 amount;
        string message;
        address otherPartyAddress;
        string otherPartName;
    }
    struct userName {
        string name;
        bool hasName;
    }
    mapping(address => userName) names;
    mapping(address => request[]) requests;
    mapping(address => sendRecieve[]) history;

    // 3. Add name to the wallet
    function addUser(string memory _name) public {
        userName storage newUser = names[msg.sender];
        newUser.name = _name;
        newUser.hasName = true;
    }

    // 4. Add requests

    function createRequest(
        address user,
        uint256 _amount,
        string memory _message
    ) public {
        request memory newRequest;
        newRequest.amount = _amount;
        newRequest.message = _message;
        newRequest.requestor = msg.sender;
        if (names[msg.sender].hasName) {
            newRequest.name = names[msg.sender].name;
        }
    }
    // 5. Fullfill requests
    // 6. Display all the previous requests
}
