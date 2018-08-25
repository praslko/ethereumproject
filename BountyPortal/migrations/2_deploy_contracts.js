var BountyPortal = artifacts.require("../contracts/BountyPortal.sol");

module.exports = function(deployer) {
  // NOTE: Address in following statement may need to be changed to match with an available address in test environment
  //       This is Bounty Portal contract owner address in  local development environment
  deployer.deploy(BountyPortal, "0x0678636e25DaCf509872F7226A9Bf66b3261E2D2");
  };
