const SimpleStorage = artifacts.require("verifier");
module.exports = function (deployer) {
  deployer.deploy(SimpleStorage, "0x7a8a5b5Fd0880DF2118c3360D9c013dDA754FacF", "0x7709708E7Aff121164bBA336aEb9653f7467cC2A");
};
