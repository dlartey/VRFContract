// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.

// Reference: https://remix.ethereum.org/#url=https://docs.chain.link/samples/VRF/VRFv2Consumer.sol
// Lines 5-115

// Reference: https://github.com/jspruance/block-explorer-tutorials/blob/main/apps/Lottery/lottery/contracts/Lottery.sol
// Lines 122-165
pragma solidity ^0.8.11;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract VRFv2Consumer10 is VRFConsumerBaseV2 {
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    // Added code
    address public owner;
    address payable[] public players;
    mapping(uint => address payable) public lotteryHistory;
    uint public lotteryId;
    uint256[] random;
    // End of addition

    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus)
        public s_requests; /* requestId --> requestStatus */
    VRFCoordinatorV2Interface COORDINATOR;

    // Your subscription ID.
    uint64 s_subscriptionId;

    // past requests Id.
    uint256[] public requestIds;
    uint256 public lastRequestId; // same as randomResult

    bytes32 keyHash =
        0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 callbackGasLimit = 400000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords = 5;

    /**
     * GOERLI COORDINATOR: 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D
     */
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
        random = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(
        uint256 _requestId
    ) external view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    // additions
    // Gets the balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Gets everyone entered into the lottery
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    // Enters everyone into the lottery
    function enter() public payable {
        require(msg.value > .01 ether);
        // address of player entering lottery
        players.push(payable(msg.sender));
    }

    function payWinner() public onlyowner {
        // Ensure that randomResult is different each time or the same index in the array
        // always wins
        // The require statement only works for the 1st time, after that it is the same
        require(
            s_requests[lastRequestId].fulfilled,
            "Must have a 10 random words before choosing winner"
        );
        
        // Initialise index to 0
        uint index = 0;
        // Loop over random words generated
        for (uint i = 0; i < random.length; ++i){
            index = (index + (random[i] % players.length)) % players.length;
        }
        // Run migrations & copy
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
