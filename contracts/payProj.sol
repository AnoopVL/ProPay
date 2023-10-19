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
        addHistory(
            msg.sender,
            payableRequest.requestor,
            payableRequest.amount,
            payableRequest.message
        );

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
    function getMyRequests(
        address _users
    )
        public
        view
        returns (
            address[] memory,
            uint256[] memory,
            string[] memory,
            string[] memory
        )
    {
        address[] memory addrs = new address[](requests[_users].length);
        uint256[] memory amnt = new uint256[](requests[_users].length);
        string[] memory msge = new string[](requests[_users].length);
        string[] memory nme = new string[](requests[_users].length);

        for (uint i = 0; i < requests[_users].length; i++) {
            request storage myRequests = requests[_users][i];
            addrs[i] = myRequests.requestor;
            amnt[i] = myRequests.amount;
            msge[i] = myRequests.message;
            nme[i] = myRequests.name;
        }
        return (addrs, amnt, msge, nme);
    }

    //get all the previous transactions user has been part of
    function getMyHistory(
        address _user
    ) public view returns (sendReceive[] memory) {
        return history[_user];
    }

    function getMyName(address _user) public view returns (userName memory) {
        return names[_user];
    }
}
