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
    struct sendReceive {
        string action;
        uint256 amount;
        string message;
        address otherPartyAddress;
        string otherPartyName;
    }
    struct userName {
        string name;
        bool hasName;
    }
    mapping(address => request[]) requests;
    mapping(address => sendReceive[]) history;
    mapping(address => userName) names;

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
        requests[user].push(newRequest);
    }

    // 5. Fullfill requests
    function payRequest(uint256 _request) public payable {
        require(
            _request < requests[msg.sender].length,
            "No such request exists!!"
        );
        request[] storage myRequests = requests[msg.sender];
        request storage payableRequest = myRequests[_request];

        uint256 toPay = payableRequest.amount * 1000000000000000000;
        require(msg.value == (toPay), "Please pay the exact amount!!");
        payable(payableRequest.requestor).transfer(msg.value);
        myRequests[_request] = myRequests[myRequests.length - 1];
        myRequests.pop();
    }

    function addHistory(
        address sender,
        address receiver,
        uint256 _amount,
        string memory _message
    ) private {
        sendReceive memory newSend;
        newSend.action = "-";
        newSend.amount = _amount;
        newSend.message = _message;
        newSend.otherPartyAddress = receiver;
        if (names[receiver].hasName) {
            newSend.otherPartyName = names[receiver].name;
        }
        history[sender].push(newSend);

        sendReceive memory newReceive;
        newReceive.action = "+";
        newReceive.amount = _amount;
        newReceive.message = _message;
        newReceive.otherPartyAddress = sender;
        if (names[sender].hasName) {
            newReceive.otherPartyName = names[sender].name;
        }
        history[receiver].push(newReceive);
    }
    // 6. Display all the previous requests
}
