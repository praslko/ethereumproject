var LibraryDemo = artifacts.require("../contracts/LibraryDemo.sol");

module.exports = function(deployer) {
  deployer.deploy(LibraryDemo);
};
