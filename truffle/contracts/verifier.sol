// license: MIT

pragma solidity ^0.8.17;

import "./IERC20.sol";
import "./ISBT.sol";
import "./hackyAOS/IhackyAOS.sol";
import "@openzeppelin/contracts/utils/Strings.sol";



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
    * @param value the value to check -> balance of each address must be >= value
    * @param message the message to verify the ring signature
    * @param token the token we check the balance of
    * @param addressesURI the URI of the addresses on IPFS
    * @param verifierData is a string which could be used id the verifier wants to be sure that the sbt has been minted for him (example : his address or somethings he asked the prover to write)
    */
    function verify(uint256[] memory addresses,uint256 value, uint256 message, address token, string memory addressesURI, string memory verifierData) public {
        require(addresses.length % 2 == 0, "addresses length must be even");
        uint256[] memory tees = new uint256[](addresses.length % 2);
        uint256 seed = 0;
        // verify the ring signature
        require(_checkRingSig.Verify(addresses, tees, seed, message), "Invalid ring signature"); // c'est quoi tees et seed ?
        
        for (uint i = 0; i < addresses.length; i+=2) {
            require(IERC20(token).balanceOf(pointsToAddresses([addresses[i],addresses[i+1]])) >= value, "Insufficient balance in at least one address");
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
    function verifyRoot(bytes32 root, uint256[] memory addresses) public view returns (bool) {
        return buildRoot(addresses) == root;
    }



    function pointsToAddresses(uint256[2] memory points) public pure returns (address) {
        string memory concat = "";
        uint160 adresse;
        
        concat = string.concat(Strings.toString(points[0]), Strings.toString(points[1]));
        // take the las 40 characters of the hash
        // adresse = string.concat("0x", bytes32Last40(keccak256(abi.encodePacked(concat))));
        adresse = bytes32ToUint160(keccak256(abi.encodePacked(concat)));
        
        return address(adresse);
    }

    function bytes32Last40(bytes32 _bytes32) public pure returns (string memory) {
        bytes memory bytesArray = abi.encodePacked(type(uint256).max, _bytes32);
        bytes memory last40Bytes = new bytes(40);
        for (uint256 i = 0; i < 40; i++) {
            last40Bytes[i] = bytesArray[bytesArray.length - 40 + i];
        }
        return string(last40Bytes);
    }

    function bytes32ToUint160(bytes32 _bytes) public pure returns (uint160) {
        require(_bytes.length == 20, "Bytes32ToUint160: Invalid bytes length");
        bytes20 bytes20Value = bytes20(_bytes);
        return uint160(bytes20Value);
    }

    

}