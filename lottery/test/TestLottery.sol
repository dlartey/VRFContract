pragma solidity ^0.8.11;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Lottery.sol";

contract TestLottery {
  function testInitialBalanceUsingDeployedContract() public {
    VRFv2Consumer lottery = VRFv2Consumer(DeployedAddresses.VRFv2Consumer());

    uint expected = 0;

    Assert.equal(lottery.getBalance(), expected, "Owner should have 0 ETH initially");
  }

  function testInitialPlayers() public {
    VRFv2Consumer lottery = VRFv2Consumer(DeployedAddresses.VRFv2Consumer());

    uint playersLength = 0;

    Assert.equal(lottery.getPlayers().length, playersLength, "0 players initially");
  }

  // function testEntry() public {
  //   VRFv2Consumer lottery = VRFv2Consumer(DeployedAddresses.VRFv2Consumer());

  //   //uint valu = 1 ether;
  //   payable(address(lottery)).transfer(10);
  //   //lottery.transfer('15000000000000000');

  // }

  // function testVerifyEntry() public{
  //   VRFv2Consumer lottery = VRFv2Consumer(DeployedAddresses.VRFv2Consumer());

  //   Assert.equal(lottery.getBalance(), 1, "Should have 1 Ether");
  // }

//   function testInitialBalanceWithNewMetaCoin() {
//     MetaCoin meta = new MetaCoin();

//     uint expected = 10000;

//     Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
//   }
}
