const Lottery = artifacts.require("VRFv2Consumer");
// This should be the name of the contract in solidity, not the name of the file
module.exports = function (deployer) {
  deployer.deploy(Lottery,10957);
};