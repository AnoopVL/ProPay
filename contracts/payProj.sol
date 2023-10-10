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
    // 3. Add name to the wallet
    // 4. Add requests
    // 5. Fullfill requests
    // 6. Display all the previous requests
}
