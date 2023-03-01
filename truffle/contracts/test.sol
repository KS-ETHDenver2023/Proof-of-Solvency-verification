pragma solidity ^0.8.17;

import "./hackyAOS/hackyAOS.sol";

contract test{


    function checkVerify(uint256[] memory addresses, uint256[] memory tees, uint256 seed, uint256 message)public returns (bool){
        // check verify function from ./hackyAOS/hackyAOS.sol using data stored in test.py (need to format them)
        return(HackyAOSRing.Verify(addresses, tees, seed, message));
    }
}