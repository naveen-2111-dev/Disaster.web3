// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract DisasterManagements {
    
    struct Disaster {
        string Image;
        string DisasterCause;
        string description;
        string location;
        string Date;
        bool Volunteers;
        uint256 VolunteersCount;
        uint256 AmountNeeded;
        uint256 id;
        address payable Demander;
    }

    mapping(uint256 => Disaster) public disasters;
    uint256 postCount = 0;
    uint256 TotVolCount = 0;

    function DemandFund(string memory _image, string memory _cause, string memory _location, uint256 _volCount, string memory _description, string memory _data, uint256 _amount) external returns(uint256) {
        require(_amount > 0, "Request amount must be greater than zero!");

        postCount++;

        disasters[postCount] = Disaster({
            id: postCount,
            Image: _image,
            DisasterCause: _cause,
            description: _description,
            location: _location,
            Date: _data,
            Volunteers: true,
            VolunteersCount: _volCount,
            AmountNeeded: _amount,
            Demander: payable(msg.sender)
        });

        return postCount;
    }

    function Fundder(uint256 _id) public payable {
        Disaster memory disasterItem = disasters[_id];
        require(_id > 0 && _id <= postCount," invalid id/...");
        require(msg.value > 0 && msg.value <= disasterItem.AmountNeeded, "enter amount or fund alredy collected/...");
        
        (bool sendMoney,) = disasterItem.Demander.call{value: msg.value}("");
        require(sendMoney, "failed to send money");
    }

    function Volunteer(uint256 _id) public {
        Disaster memory volunteer = disasters[_id];
        require(_id > 0 && _id <= postCount, "invalid id/...");
        TotVolCount++;
        require(TotVolCount <= volunteer.VolunteersCount, "alredy vols joined/...");
    }
}