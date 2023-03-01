const SimpleStorage = artifacts.require("verifier");
module.exports = function (deployer) {
  deployer.deploy(SimpleStorage, "0x26F31025D1c0A8a6F6Be75885fCD9A8713e911c7", "0x4be29fA49717486b44465eBbeFF4b7103A676BDe");
};
