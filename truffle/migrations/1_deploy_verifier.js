const SimpleStorage = artifacts.require("verifier");
module.exports = function (deployer) {
  deployer.deploy(SimpleStorage, "0x250B63aFab3Ce46D0D8679fD5D996C4f517a262F", "0xDf5564227440F5a7Fb2c500a23490F0F846309c6");
};
