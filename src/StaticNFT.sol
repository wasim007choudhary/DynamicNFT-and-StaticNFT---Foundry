// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract SimpleNft is ERC721, ERC721Burnable {
    error SimpleNft___mintNft_ItCannotBeEmpty();

    uint256 private s_tokenCounter;
    uint256 private s_totalSupply;
    mapping(uint256 tokenId => string tokenUri) public s_TokenIdToURI;

    constructor() ERC721("FreedomNFT", "$FN") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory _tokenUri) public {
        if (bytes(_tokenUri).length == 0) {
            revert SimpleNft___mintNft_ItCannotBeEmpty();
        }

        _safeMint(msg.sender, s_tokenCounter);
        s_TokenIdToURI[s_tokenCounter] = _tokenUri;
        s_tokenCounter++;
        s_totalSupply++;
    }

    function burn(uint256 tokenId) public override {
        super.burn(tokenId);
        delete s_TokenIdToURI[tokenId];
        s_totalSupply--;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory _TokenUri) {
        return s_TokenIdToURI[_tokenId];
    }

    function totalSupply() public view returns (uint256) {
        return s_totalSupply;
    }

    function tokenCounter() external view returns (uint256) {
        return s_tokenCounter;
    }
}
