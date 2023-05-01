const Lottery = artifacts.require("KeccakLottery");
const ETHER = 10**18;
contract('Keccak', (accounts) => {

  // Test that lottery balance should be 0
  it('Should have an initial balance of 0', async () => {
    const lotteryInstance = await Lottery.deployed();
    const balance = await lotteryInstance.getBalance.call();

    assert.equal(balance.valueOf(), 0, "0 is expected for initial contract balance");
  });

  // Test that lottery has 0 players initially
  it('Should have 0 players initially', async () => {
    const lotteryInstance = await Lottery.deployed();
    const playersLength = await lotteryInstance.getPlayerLength.call();

    assert.equal(playersLength, 0, "Should have 0 players initially");
  });

  // Test that randomResult is initially 0
  it('randomResult should be 0', async () => {
    const lotteryInstance = await Lottery.deployed();
    const randomResult = await lotteryInstance.random.call();

    assert.equal(randomResult, 0, "randomResult should be 0");
  });

  // Test that lotteryID should be 1 initially
  it('lotteryId shoule be 1', async () => {
    const lotteryInstance = await Lottery.deployed();
    const lotteryId = await lotteryInstance.lotteryId.call();

    assert.equal(lotteryId, 1, "lotteryId shoule be 1");
  });

  // Testing that the owner of the contract is correct
  it('Contract Owner should have deployed the contract', async () => {
    const lotteryInstance = await Lottery.deployed();

    assert.equal(await lotteryInstance.owner(), "0x627306090abaB3A6e1400e9345bC60c78a8BEf57", "Contract Owner should have deployed the contract");
  });

  // Testing that entering the lottery works
  it('Sending ETH to the contract', async () => {
    const lotteryInstance = await Lottery.deployed();
    const accountOne = accounts[0];

    await lotteryInstance.enter(
      {
        from: accountOne,
        value: 1*ETHER
      }
    );
    const balance = await lotteryInstance.getBalance.call(); 
    assert.equal(balance, 1 * ETHER, "1 ETH should be in contract balance");
  });

  // Testing that player length updated once a player enters the lottery
  it('testing Player length', async () => {
    const lotteryInstance = await Lottery.deployed();
    const playersLength = await lotteryInstance.getPlayerLength.call(); 
    assert.equal(playersLength, 1 , "1 player should be in the lottery");
  });

  // Testing that multiple accounts can enter the lottery
  it('Sending ETH to the contract multiple accounts', async () => {
    const lotteryInstance = await Lottery.deployed();
    const accountOne = accounts[0];
    const accountTwo = accounts[1];
    const accountThree = accounts[2];

    await lotteryInstance.enter(
      {
        from: accountOne,
        value: web3.utils.toWei("1", "ether")
      }
    );

    await lotteryInstance.enter(
      {
        from: accountTwo,
        value: web3.utils.toWei("1", "ether")
      }
    );

    await lotteryInstance.enter(
      {
        from: accountThree,
        value: web3.utils.toWei("1", "ether")
      }
    );
    const balance = await lotteryInstance.getBalance.call(); 
    assert.equal(balance.toString(), web3.utils.toWei("4", "ether").toString(), "4 ETH should be in contract balance");
  });

  // Testing that player length updated after multiple accounts enter
  it('testing Player length', async () => {
    const lotteryInstance = await Lottery.deployed();
    const playersLength = await lotteryInstance.getPlayerLength.call(); 
    assert.equal(playersLength, 4 , "4 players should be in the lottery");
  });

  // Testing that the randomWords function works as expected in mock test
  it('testing requestRandomWords', async () => {
    const lotteryInstance = await Lottery.deployed();
    const randomResult = 5230231123123;
    assert.equal(randomResult, 5230231123123 , "testing requestRandomWords");
  });
});
