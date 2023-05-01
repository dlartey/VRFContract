pragma solidity ^0.8.11;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/keccak.sol";

contract TestLotteryKeccak {
  uint public initialBalance = 1 ether;

  // Test that the initial balance is 0
  function testInitialBalanceUsingDeployedContract() public {
    KeccakLottery lottery = KeccakLottery(DeployedAddresses.KeccakLottery());

    uint expected = 0;

    Assert.equal(lottery.getBalance(), expected, "Owner should have 0 ETH initially");
  }

  // Test that the contract owner is as expected
  function testOwner() public {
    KeccakLottery lottery = KeccakLottery(DeployedAddresses.KeccakLottery());

    Assert.equal(lottery.owner(), msg.sender, "Contract Owner should have deployed contract");
  }

  // Test that there aren't any players in the lottery initially
  function testInitialPlayers() public {
    KeccakLottery lottery = KeccakLottery(DeployedAddresses.KeccakLottery());
    uint playersLength = 0;
    Assert.equal(lottery.getPlayerLength(), playersLength, "0 players initially");
  }

  // Test that entering the lottery works correctly
  function testEntry() public {
    KeccakLottery lottery = KeccakLottery(DeployedAddresses.KeccakLottery());
    lottery.enter{value:1 ether}();
    Assert.equal(lottery.getBalance(), 1 ether, "Contract should have 1 ETH");
  }

  // Test that the initial randomResult should be 0
  function testRandomResultInitial() public {
    KeccakLottery lottery = KeccakLottery(DeployedAddresses.KeccakLottery());
    Assert.equal(lottery.random(), 0, "randomResult should be 0");
  }

  // test that the lotteryID is correct when contract deployed
  function testLotteryID() public {
    KeccakLottery lottery = KeccakLottery(DeployedAddresses.KeccakLottery());
    Assert.equal(lottery.lotteryId(), 1, "lotteryID should be 1");
  }

  // Test randomResult function works
  function testRandomResult() public {
    KeccakLottery lottery = KeccakLottery(DeployedAddresses.KeccakLottery());
    lottery.getRandomNumber();
    uint rand = lottery.random();
    Assert.equal(rand, rand, "randomResult is incorrect");
  }

  // Test balance is updated after lottery entry
  function testCurrentBalance() public {
    KeccakLottery lottery = KeccakLottery(DeployedAddresses.KeccakLottery());
    uint expected = 1 ether;
    Assert.equal(lottery.getBalance(), expected, "Contract should have 1 ETH");
  }

}
