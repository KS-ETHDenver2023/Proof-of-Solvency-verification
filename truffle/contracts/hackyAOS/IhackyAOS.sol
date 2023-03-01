pragma solidity ^0.8.17;


interface IHackyAOSRing{  

	function Verify( uint256[] memory addresses, uint256[] memory tees, uint256 seed, uint256 message ) external pure returns (bool);
	
}

