pragma solidity ^0.8.11;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Lottery1.sol";

contract TestLottery {
  uint public initialBalance = 1 ether;

  function testInitialBalanceUsingDeployedContract() public {
    VRFv2Consumer10 lottery = VRFv2Consumer10(DeployedAddresses.VRFv2Consumer10());

    uint expected = 0;

    Assert.equal(lottery.getBalance(), expected, "Owner should have 0 ETH initially");
  }

  function testOwner() public {
    VRFv2Consumer10 lottery = VRFv2Consumer10(DeployedAddresses.VRFv2Consumer10());

    Assert.equal(lottery.owner(), msg.sender, "Contract Owner should have deployed contract");
  }

  function testInitialPlayers() public {
    VRFv2Consumer10 lottery = VRFv2Consumer10(DeployedAddresses.VRFv2Consumer10());

    uint playersLength = 0;

    Assert.equal(lottery.getPlayerLength(), playersLength, "0 players initially");
  }

  function testEntry() public {
    VRFv2Consumer10 lottery = VRFv2Consumer10(DeployedAddresses.VRFv2Consumer10());
    lottery.enter{value:1 ether}();
    Assert.equal(lottery.getBalance(), 1 ether, "Contract should have 1 ETH");
  }

  function testRandomResult() public {
    VRFv2Consumer10 lottery = VRFv2Consumer10(DeployedAddresses.VRFv2Consumer10());
    Assert.equal(lottery.randomResult(), 0, "randomResult should be 0");
  }

  function testLotteryID() public {
    VRFv2Consumer10 lottery = VRFv2Consumer10(DeployedAddresses.VRFv2Consumer10());
    Assert.equal(lottery.lotteryId(), 0, "lotteryID should be 0");
  }

  function testlastRequestId() public {
    VRFv2Consumer10 lottery = VRFv2Consumer10(DeployedAddresses.VRFv2Consumer10());
    Assert.equal(lottery.lastRequestId(), 0, "lastRequestId should be 0");
  }
}
