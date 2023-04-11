// SPDX-License-Identifier: MIT
// Reference: https://github.com/jspruance/block-explorer-tutorials/blob/main/smart-contracts/solidity/Lottery.sol lines 4-91
// Reference: https://www.youtube.com/watch?v=HR679xTt8tg lines 4-91
pragma solidity ^0.8.11;
// This defines solidity version we are using

contract KeccakLottery{
    // Owner: Address of person who deployed contract
    address public owner;

    // To create an array specify types of objects in the array
    // payable is used for any addresses/functions that can receive ETH
    address payable[] public players;
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;
    uint public random;

    // Constructor doesn't take any arguments
    // Setting the address of the person who deployed the contract to the owner state variable
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

    // memory indicates that this is just stored temporarily for the function life cycle
    function getPlayers() public view returns (address payable[] memory){
        return players;
    }

    // To enter someone into the lottery, add their address into the players array
    function enter() public payable{
        require(msg.value >= .01 ether);

        players.push(payable(msg.sender));
    }

    // No native number random generator in solidity
    // Blockchain is deterministic (If you know state of system at any given point in time, future states are predictable)
    // Blockchain is also transparent
    // Use pseudo random number generator (not 100% safe) using a hashing function 

    // Hashing algorithm is native to solidity
    function getRandomNumber() public{
        // Hashing the owner address and the current time
        // abi.encode concatenates them together
        random = uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    // we want to get an index from the players array
    // Restrict use of this function to the owner of the contract
    function payWinner() public onlyOwner{
        // We can also create a custom modifier
        //require(msg.sender == owner);
        
        // Gives us an integer between 0 & players.length-1
        uint index = random % players.length;

        // Take the winner & transfer to that account balance of the current smart contract
        players[index].transfer(address(this).balance);

        // Update the history
        lotteryHistory[lotteryId] = players[index];

        // re entry attack (drain smart contract of its funds)
        // first do transfer then update state
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