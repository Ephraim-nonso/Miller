// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;


contract Content {
    
    uint public balances;
    uint creationFee = 100 wei;
    uint premiumFee = 10000 wei;
    uint platformReward = 300;
    uint creatorReward = 9700;



    struct Creators{

        address _address;
        uint publicationNumber;
        bool created;
    }

    struct SpecificContent{
        address readersAddress;

    }

    enum choice{
        premium,
        free
    }
    event CreatorChoice(choice _e);

    mapping(uint => Creators) public creatorList;
    mapping(address => bool) public createList;
    mapping(uint => SpecificContent) public specificContentReaders;
    uint index = 1;
    uint readerIndex = 1;

    function create(choice _choice, uint _creationFee) payable public { 
        _creationFee = creationFee;
        require (msg.value >= creationFee);
        payable (address(this)).transfer(creationFee);
        balances += msg.value;
        if(createList[msg.sender] == true){
            Creators storage c = creatorList[index];
            c.publicationNumber++;
        }
        Creators storage creator = creatorList[index];
        creator._address = msg.sender;
        creator.publicationNumber++;
        creator.created = true;
        index++;
        emit CreatorChoice(_choice);
    }

    function readContent(address addr) payable public {
        require (msg.value >= premiumFee);
        payable (address(this)).transfer(platformReward);
        payable (addr).transfer(creatorReward);
        balances += platformReward;
        SpecificContent storage specific = specificContentReaders[readerIndex];
        specific.readersAddress = msg.sender;
        readerIndex++;
    }

    // function platformReturns() payable public{

    // }

}
