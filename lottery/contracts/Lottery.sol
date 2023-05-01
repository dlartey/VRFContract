// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.
pragma solidity ^0.8.11;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

// Reference: https://remix.ethereum.org/#url=https://docs.chain.link/samples/VRF/VRFv2Consumer.sol
// Lines 14-15, 25-32, 38-98, 118

// Reference: https://github.com/jspruance/block-explorer-tutorials/blob/main/apps/Lottery/lottery/contracts/Lottery.sol
// Lines 115-138, lines 18-22, 100-108
contract VRFv2Consumer is VRFConsumerBaseV2 {
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    // Added code
    address public owner;
    address payable[] public players;
    mapping(uint => address payable) public lotteryHistory;
    uint public lotteryId;
    uint public randomResult;
    // End of addition

    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus)
        public s_requests; /* requestId --> requestStatus */
    VRFCoordinatorV2Interface COORDINATOR;

    uint64 s_subscriptionId;
    uint256[] public requestIds;
    uint256 public lastRequestId; 

    bytes32 keyHash =
        0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;

    constructor(
        uint64 subscriptionId
    )
        VRFConsumerBaseV2(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D)
    {
        COORDINATOR = VRFCoordinatorV2Interface(
            0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D
        );
        s_subscriptionId = subscriptionId;
        owner = msg.sender;
    }

    // Assumes the subscription is funded sufficiently.
    function requestRandomWords()
        external
        onlyowner
        returns (uint256 requestId)
    {
        // Will revert if subscription is not set and funded.
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        randomResult = _randomWords[0];
        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(
        uint256 _requestId
    ) external view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    // Gets the balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Gets everyone entered into the lottery
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

     // Gets everyone entered into the lottery
    function getPlayerLength() public view returns (uint) {
        return players.length;
    }

    // Enters everyone into the lottery
    function enter() public payable {
        require(msg.value > .01 ether);
        players.push(payable(msg.sender));
    }

    // Pays the lottery Winner
    function payWinner() public onlyowner {
        require(
            randomResult > 0,
            "Must have a source of randomness before choosing winner"
        );
        uint index = randomResult % players.length;
        players[index].transfer(address(this).balance);
        lotteryHistory[lotteryId] = players[index];
        lotteryId++;
        // reset the state of the contract
        players = new address payable[](0);
    }

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }
}
