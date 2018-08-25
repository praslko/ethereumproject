pragma solidity ^0.4.23;



import "bytes/BytesLib.sol";



/// @title Contract for LibraryDemo

/// @author Prashant Saxena <pras.lko@gmail.com>


/// @notice Demonstrates usage of a package from  ethPM registry



contract LibraryDemo {
    
	using BytesLib for bytes;
    
    
	
	function getFullName(bytes _fName, bytes _lName)
    
	public
 
        pure   
	returns (bytes)
    
	{
		
		bytes memory fullName = _fName.concat(" ").concat(_lName);
        
		return fullName;
	
	}


	function getSalutation(bytes _fullName)
    
	public
 
        pure   
	returns (bytes)
    
	{
		
		bytes memory salutation = _fullName.slice(0, 3);
        
		return salutation;
	
	}
}