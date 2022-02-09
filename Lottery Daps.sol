// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;
contract Lottery{
    address public manager;
    address payable[] public participants;
    constructor()
    {
        manager=msg.sender;
    }
    function alreadyEntered() view private returns(bool)
    {
    // This function will make sure if participants have already taken participate or not
        for(uint i=0;i<participants.length;i++)
        {
            if(participants[i]== msg.sender) 
            return true;
        }
        return false;
    }
    function TakePart() external payable returns(uint)
    {
        require(msg.sender!= manager,"Manager can not take part in lottery");       
        // Manager can not take part in lottery
        require(alreadyEntered() == false,"You have already participated in the lottery"); 
        // Participants can take part only once
        require(msg.value==1 ether,"You have to pay minimum one ether to take participate in lottery");       
        // Minimum amount of 1 wei need to paid
        participants.push(payable(msg.sender));
        return participants.length;
    }
    modifier onlyManager() {
        require(msg.sender == manager,"Only manager can call this function");
        _;
    }
    function getBalance() public view onlyManager returns (uint)
    {
        return address(this).balance;
    }
    function random() public view onlyManager returns(uint)
    {
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
    function selectWinner() public onlyManager
    {
        require(participants.length >= 3,"Error! Number of participants should be more than 3");
        uint random_value = random();
        uint index = random_value % participants.length;
        address payable winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
    }
