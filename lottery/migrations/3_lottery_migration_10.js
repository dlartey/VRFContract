const Lottery10 = artifacts.require("VRFv2Consumer10");
// This should be the name of the contract in solidity, not the name of the file
module.exports = function (deployer) {
    // This adds the VRF contrac to the subscription manager to consume LINK
  deployer.deploy(Lottery10,10957);
};