// license: MIT

pragma solidity ^0.8.17;

import "./IERC20.sol";
import "./ISBT.sol";
import "./hackyAOS/hackyAOS.sol";
// import "./AOS/AOSring.sol";
// import "./merklesolcrypto.sol";

contract verifier {

    ISBT _sbt;

    constructor(address sbt) {
        _sbt = ISBT(sbt);
    }

    function verify(address[] memory addresses,uint256 value, uint256 message, address token, string memory addressesURI, string memory verifierData) public {
        uint256[] memory tees = new uint256[](addresses.length);
        uint256 seed = 0;
        // verify the ring signature
        require(HackyAOSRing.Verify(addresses, tees, seed, message), "Invalid ring signature"); // c'est quoi tees et seed ?
        
        for (uint i = 0; i < addresses.length; i++) {
            require(IERC20(token).balanceOf(addresses[i]) >= value, "Insufficient balance in at least one address");
        }
        bytes32 root = buildRoot(addresses); // build merkle root to save in sbt

        // mint sbt
        _sbt.mint(msg.sender, token, addressesURI, root, message, verifierData);        
    }



    // merkle tree functions

    // build root from a list of addresses
    function buildRoot(address[] memory addresses) public pure returns (bytes32) {
        bytes32[] memory leaves = new bytes32[](addresses.length);
        for (uint i = 0; i < addresses.length; i++) {
            leaves[i] = keccak256(abi.encodePacked(addresses[i]));
        }
        return buildRootFromLeaves(leaves);
    }

    // build root from a list of leaves
    function buildRootFromLeaves(bytes32[] memory leaves) private pure returns (bytes32) {
        if (leaves.length == 0) {
            return 0x0;
        }
        if (leaves.length == 1) {
            return leaves[0];
        }
        if (leaves.length % 2 == 1) {
            bytes32[] memory tmp = new bytes32[](leaves.length + 1);
            for (uint i = 0; i < leaves.length; i++) {
                tmp[i] = leaves[i];
            }
            tmp[leaves.length] = leaves[leaves.length - 1];
            leaves = tmp;
        }
        bytes32[] memory parents = new bytes32[](leaves.length / 2);
        for (uint i = 0; i < leaves.length; i += 2) {
            parents[i / 2] = keccak256(abi.encodePacked(leaves[i], leaves[i + 1]));
        }
        return buildRootFromLeaves(parents);
    }

    // check if a merkle root is valid
    function verifyRoot(bytes32 root, address[] memory addresses) public pure returns (bool) {
        return buildRoot(addresses) == root;
    }

}