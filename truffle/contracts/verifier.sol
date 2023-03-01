// license: MIT

pragma solidity ^0.8.17;

import "./IERC20.sol";
import "./ISBT.sol";
import "./hackyAOS/IhackyAOS.sol";



contract verifier {

    ISBT _sbt;
    IHackyAOSRing _checkRingSig;

    constructor(address sbt, address checkRingSig) {
        _sbt = ISBT(sbt);
        _checkRingSig = IHackyAOSRing(checkRingSig);
    }


    /**
    * @dev verify a ring signature, check balances of the provided value and mint an sbt if it is valid
    * @param addresses the addresses of the ring (length must be even) (addresses = [key1-x, key1-y, key2-x, key2-y, ..., keyN-x, keyN-y])
    * @param tees the tees of the ring (length must be addresses.length/2) (tees = [tee1, tee2, ..., teeN])
    * @param seed the seed of the ring
    * @param value the value to check -> balance of each address must be >= value
    * @param message the message to verify the ring signature
    * @param token the token we check the balance of. Null address if we check the balance of the native token
    * @param addressesURI the URI of the addresses on IPFS
    * @param verifierData is a string which could be used id the verifier wants to be sure that the sbt has been minted for him (example : his address or somethings he asked the prover to write)
    */
    function verify(uint256[] memory addresses, uint256[] memory tees, uint256 seed, uint256 value, uint256 message, address token, string memory addressesURI, string memory verifierData) public {
        require(addresses.length % 2 == 0 && tees.length == addresses.length / 2, "Invalid proof");
        // verify if the message is valid -> int(eth address of the msg.sender) == message
        require(uint160(msg.sender) == message, "Invalid message");

        // verify the ring signature
        require(_checkRingSig.Verify(addresses, tees, seed, message), "Invalid ring signature"); // c'est quoi tees et seed ?
        
        if(token == address(0)){
            for (uint i = 0; i < addresses.length; i+=2) {
                require(pointToAddress([addresses[i],addresses[i+1]]).balance >= value, "Insufficient balance in at least one address");
            }
        }
        else{
            for (uint i = 0; i < addresses.length; i+=2) {
                require(IERC20(token).balanceOf(pointToAddress([addresses[i],addresses[i+1]])) >= value, "Insufficient balance in at least one address");
            }
        }

        bytes32 root = buildRoot(addresses); // build merkle root to save in sbt

        // mint sbt
        _sbt.mint(msg.sender, token, addressesURI, root, message, verifierData);        
    }



    // merkle tree functions

    /**
    * @dev build root from a list of addresses
    * @param addresses the addresses to build the merkle tree from
    */
    function buildRoot(uint256[] memory addresses) public pure returns (bytes32) {
        bytes32[] memory leaves = new bytes32[](addresses.length);
        for (uint i = 0; i < addresses.length; i++) {
            leaves[i] = keccak256(abi.encodePacked(addresses[i]));
        }
        return buildRootFromLeaves(leaves);
    }

    /**
    * @dev build root from a list of leaves
    * @param leaves the leaves to build the merkle tree from
    */
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

    /**
    * check if a merkle root is valid
    * @param root the root to check
    * @param addresses the addresses to check the root against
    */
    function verifyRoot(bytes32 root, uint256[] memory addresses) public pure returns (bool) {
        return buildRoot(addresses) == root;
    }


    /**
    * @dev convert a point from SECP256k1 to an ethereum address
    * @param points the point to convert -> [x,y]
    */
    function pointToAddress(uint256[2] memory points) public pure returns (address) {
        // convert uint256[2] to hex string
        bytes32 x = bytes32(points[0]);
        bytes32 y = bytes32(points[1]);
        bytes memory public_key = abi.encodePacked(x, y);
        bytes32 hash = keccak256(public_key);
        address ethereum_address = address(uint160(uint256(hash)));

        return ethereum_address;
    }
}