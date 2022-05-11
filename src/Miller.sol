// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;


contract Content {
    
    address payable Owner;
    uint public balances;
    uint creationFee = 100 wei;
    uint premiumFee = 10000 wei;
    uint platformReward = 300;
    uint creatorReward = 9700;
    
    constructor(address payable _Owner){
    Owner = _Owner;
    }
    
    modifier onlyOwner(){
    require (msg.sender == Owner, "you cant call this function");
    _;
    }

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
    uint public index = 1;
    uint readerIndex = 1;

    function create(choice _choice) payable public { 
        require (msg.value >= creationFee);
        balances += msg.value;
        if(createList[msg.sender] == true){
            Creators storage c = creatorList[index];
            c.publicationNumber++;
        }
        else{
        Creators storage creator = creatorList[index];
        creator._address = msg.sender;
        creator.publicationNumber++;
        creator.created = true;
        index++;
        }
        emit CreatorChoice(_choice);
    }

    function readContent(choice readerChoice, address addr) payable public {
        if(readerChoice == choice.premium){
            require (msg.value >= premiumFee);
            balances += platformReward;
            readPremium(addr);
            SpecificContent storage specific = specificContentReaders[readerIndex];
            specific.readersAddress = msg.sender;
            readerIndex++;
        } 
        else{
            SpecificContent storage specific = specificContentReaders[readerIndex];
            specific.readersAddress = msg.sender;
            readerIndex++;
        }
    }
    
     function withdraw(uint amount) public onlyOwner  {
        require(amount <= balances, "you are not authorized");
        balances -= amount;
        Owner.transfer(amount);
    }

    function readPremium(address addr) private{
        payable (addr).transfer(creatorReward);
    }
}
