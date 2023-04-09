const Lottery = artifacts.require("VRFv2Consumer");

contract('VRFv2Consumer', (accounts) => {
  it('Should have an initial balance of 0', async () => {
    const lotteryInstance = await Lottery.deployed();
    const balance = await lotteryInstance.getBalance.call();

    assert.equal(balance.valueOf(), 0, "0 is expected for initial contract balance");
  });

  it('Should have 0 players initially', async () => {
    const lotteryInstance = await Lottery.deployed();
    const balance = await lotteryInstance.getPlayers.call();

    assert.equal(balance.length(), 0, "Should have 0 players initially");
  });


  // it('Sending ETH to the contract', async () => {
  //   const lotteryInstance = await Lottery.deployed();
  //   const accountOne = accounts[0];

  //   await lotteryInstance.enter.send(
  //     {
  //       from: accountOne,
  //       value: '15000000000000000',
  //       gas: 300000,
  //       gasPrice: null
  //     }
  //   );
  //   const balance = await lotteryInstance.getBalance.call();
  //   assert.equal(balance.valueOf(), 15000000000000000, "0.15 ETH should be in contract balance");
  // });

  // it('should call a function that depends on a linked library', async () => {
  //   const metaCoinInstance = await MetaCoin.deployed();
  //   const metaCoinBalance = (await metaCoinInstance.getBalance.call(accounts[0])).toNumber();
  //   const metaCoinEthBalance = (await metaCoinInstance.getBalanceInEth.call(accounts[0])).toNumber();

  //   assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, 'Library function returned unexpected function, linkage may be broken');
  // });
  // it('should send coin correctly', async () => {
  //   const metaCoinInstance = await MetaCoin.deployed();

  //   // Setup 2 accounts.
  //   const accountOne = accounts[0];
  //   const accountTwo = accounts[1];

  //   // Get initial balances of first and second account.
  //   const accountOneStartingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
  //   const accountTwoStartingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

  //   // Make transaction from first account to second.
  //   const amount = 10;
  //   await metaCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

  //   // Get balances of first and second account after the transactions.
  //   const accountOneEndingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
  //   const accountTwoEndingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

  //   assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
  //   assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  // });
});
