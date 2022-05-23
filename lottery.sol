//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public players;

    constructor(){
        // address of who deployed the contract
        manager = msg.sender;
    } 

// receive payment to contract
    receive() external payable {
        // add validation 
        require(msg.value == 0.001 ether);
        players.push(payable(msg.sender));
    }

// get the contract balance
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

// generate random numbers
    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    // pick a winner
    function pickWinner() public {
        // validations, only manager can pick
        require(msg.sender == manager);
        // atleast 3 players
        require(players.length > 3);

// generate random number index
        uint randomNumber = random() % players.length;
        address payable winner;
        // select the winner
        winner = players[randomNumber];
        // transfer the contract balance to winner
        winner.transfer(getBalance());

// resetting the players array to zero, for next round
        players = new address payable[](0);

    }
}