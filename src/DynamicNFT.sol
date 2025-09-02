// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DynamicNFT is ERC721, ERC721Burnable {
    event SpinedMood(uint256 indexed tokenId, Mood beforeFlip, Mood afterFlip);

    error DynamicNFT___tokenURI_URIqueryForNonExistentToken(uint256 tokenId);
    error DynamicNFT___upturnMoodNFT_CallerNotOwnerNorApproved(uint256 tokenId, address caller);
    error DynamicNFT___upturnMoodNFT_InvalidTokenIdOrCheckCallerBalance(address caller, uint256 tokenId);
    error DynamicNFT___upturnMoodNFT_InvalidTokenId(uint256 tokenId);
    error DynamicNFT___upturnMoodNFT_NoMoodFlipToTheSameMood();

    enum Mood {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_happySvgImageURI;
    string private s_sadSvgImageURI;
    uint256 private s_totalSupply;

    mapping(uint256 tokenId => Mood) private s_tokenIdToMood;

    constructor(string memory happySvgImageURI, string memory sadSvgImageURI) ERC721("SPIRIT NFT", "$ST") {
        s_tokenCounter = 0;
        s_happySvgImageURI = happySvgImageURI;
        s_sadSvgImageURI = sadSvgImageURI;
    }

    function mintDynamicNFT() public returns (uint256) {
        uint256 tokenID = s_tokenCounter;
        _safeMint(msg.sender, tokenID);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY; // setting mood to happy
        s_tokenCounter++;
        s_totalSupply++;
        return tokenID;
    }

    function burn(uint256 tokenId) public override {
        super.burn(tokenId);
        delete s_tokenIdToMood[tokenId];
        s_totalSupply--;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function upturnMoodNFT(uint256 tokenId, Mood newMood) public {
        address owner = _ownerOf(tokenId);

        if (owner == address(0)) {
            revert DynamicNFT___upturnMoodNFT_InvalidTokenIdOrCheckCallerBalance(msg.sender, tokenId);
        } else if (!_isAuthorized(owner, msg.sender, tokenId)) {
            revert DynamicNFT___upturnMoodNFT_CallerNotOwnerNorApproved(tokenId, msg.sender);
        }

        Mood presentMood = getMoodInfo(tokenId);
        if (presentMood == newMood) {
            revert DynamicNFT___upturnMoodNFT_NoMoodFlipToTheSameMood();
        }
        if (presentMood == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
        Mood afterMoodFlip = getMoodInfo(tokenId);

        emit SpinedMood(tokenId, presentMood, afterMoodFlip);
    }

    function getMoodInfo(uint256 tokenId) public view returns (Mood) {
        if (_ownerOf(tokenId) == address(0)) {
            revert DynamicNFT___upturnMoodNFT_InvalidTokenId(tokenId);
        }
        return s_tokenIdToMood[tokenId];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (_ownerOf(tokenId) == address(0)) {
            revert DynamicNFT___tokenURI_URIqueryForNonExistentToken(tokenId);
        }
        Mood mood = s_tokenIdToMood[tokenId];
        string memory imageURI = mood == Mood.HAPPY ? s_happySvgImageURI : s_sadSvgImageURI;
        string memory moodValue = mood == Mood.HAPPY ? "Happy" : "Sad";

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "NFT which reflects the mood as Happy or Sad according to the Emotional State Of the Owner.", "attributes": [{"trait_type": "Emotion", "value": "',
                            moodValue,
                            '"}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function totalSupply() public view returns (uint256) {
        return s_totalSupply;
    }
}
