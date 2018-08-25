pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/LibraryDemo.sol";

contract TestLibraryDemo {
  LibraryDemo libDemo = LibraryDemo(DeployedAddresses.LibraryDemo());

  // Testing the getFullName() function
  function testGetFullName() public {
  	bytes memory fullName = libDemo.getFullName("Prashant", "Saxena");

	bytes memory expectedFullName = "Prashant Saxena";

  	Assert.equal(string(fullName), string(expectedFullName), "getFullName()");
   }

   function testGetSalutation() public {
  	bytes memory salutation = libDemo.getSalutation("Mr. Prashant Saxena");

	bytes memory expectedSalutation = "Mr.";

  	Assert.equal(string(salutation), string(expectedSalutation), "getSalutation()");
		
	}
}