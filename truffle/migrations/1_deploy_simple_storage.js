const SimpleStorage = artifacts.require("verifier");
module.module.exports = function (deployer) {
  deployer.deploy(SimpleStorage, "temp_sbt", "tsbt");
};
