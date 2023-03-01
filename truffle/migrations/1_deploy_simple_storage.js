const SimpleStorage = artifacts.require("verifier");
module.exports = function (deployer) {
  deployer.deploy(SimpleStorage, "0xF0d7935a33b6126115D21Ec49403e4ce378A42Dd", "0xbEeB29483e810290B2610593B30C589672CCE3c8");
};
