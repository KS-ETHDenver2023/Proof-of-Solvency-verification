pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ISBT is IERC721 {

    // get sbt data 

    /**
    * @notice burn the sbt which id is tokenId
    * @param tokenId is the id of the sbt to burn
    */
    function burn(uint256 tokenId) external;

    /**
    * @notice mint a sbt for the receiver
    * @param receiver is the address of the receiver of the sbt
    * @param token is the address of the token that is linked to the sbt
    * @param tokenURI is the uri where we can get the addresses used to generate the proof (stored on ipfs)
    * @param merkleRoot is the merkle root of the addresses (to ensure that the addresses have not been modified)
    * @param signature is the zk proof generated in the frontend (which has been verified by the verifier)
    * @param verifier is a string which could be used id the verifier wants to be sure that the sbt has been minted for him (example : his address or somethings he asked the prover to write)
    */
    function mint(address receiver, address token, string memory tokenURI, bytes32 merkleRoot, uint256 signature, string memory verifier) external;

    // admin functions
    /**
    * @param admin is the address of the admin to add/remove
    * @param isAdmin is true if the admin is added, false if the admin is removed
    */
    function editAdmin(address admin, bool isAdmin) external;

    /**
    * @param minter is the address of the minter to add/remove
    * @param isMinter is true if the minter is added, false if the minter is removed
    */
    function editMinter(address minter, bool isMinter) external;

    /**
    * @param burner is the address of the burner to add/remove
    * @param isBurner is true if the burner is added, false if the burner is removed
    */
    function editBurner(address burner, bool isBurner) external;
}

