// SPDX-License-Identifier: MIT
// Reference: https://github.com/jspruance/block-explorer-tutorials/blob/main/smart-contracts/solidity/Lottery.sol lines 4-66
pragma solidity ^0.8.11;
contract KeccakLottery{

    address public owner;
    address payable[] public players;
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;
    uint public random;

    constructor(){
        owner = msg.sender;
        lotteryId = 1;
    }

    function getWinners() public view returns (address[] memory){
        address[] memory ret = new address[](lotteryId);
        for (uint i = 1; i < lotteryId; i++)
            ret[i] = getWinnerByLottery(i);
        return ret;
    }

    function getWinnerByLottery(uint lottery) public view returns (address payable){
        return lotteryHistory[lottery];
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory){
        return players;
    }

    function enter() public payable{
        require(msg.value >= .01 ether);

        players.push(payable(msg.sender));
    }

    function getRandomNumber() public{
        // Hashing the owner address and the current time
        // abi.encode concatenates them together
        random = uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    // Gets everyone entered into the lottery
    function getPlayerLength() public view returns (uint) {
        return players.length;
    }

    function payWinner() public onlyOwner{        
        uint index = random % players.length;
        players[index].transfer(address(this).balance);
        lotteryHistory[lotteryId] = players[index];
        lotteryId++;
        // reset the state of the contract (create a new array with length 0)
        players = new address payable[](0);
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        // Run other code after the require statement
        _;
    }
}