// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeploySimpleNft} from "script/DeployStatic.s.sol";
import {SimpleNft} from "src/StaticNFT.sol";
import {Test, console} from "forge-std/Test.sol";

contract SimpleNftTest is Test {
    DeploySimpleNft public deployer;
    SimpleNft public sNft;
    address public USER = makeAddr("User");
    string public constant TOKEN_URI = "ipfs://QmPRQbtRCTuq8zKqzJTivHrFoZnpedMeHhNFeH2eH6gzRU";

    function setUp() public {
        deployer = new DeploySimpleNft();
        sNft = deployer.run();
    }

    function testNameAndSymbol() public view {
        string memory expectedName = "FreedomNFT";
        string memory expectedSymbol = "$FN";

        string memory actualName = sNft.name();
        string memory actualSymbol = sNft.symbol();

        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }

    ///////////////////////////////////////////////////////////////////
    ////////////////////// mintNft Function Test //////////////////////
    ///////////////////////////////////////////////////////////////////
    function testMintRevertsIfEmptyTokenUri() public {
        vm.expectRevert(SimpleNft.SimpleNft___mintNft_ItCannotBeEmpty.selector);
        vm.prank(USER);
        sNft.mintNft("");
    }

    function testMintFunctionWithValidURI() public {
        uint256 totalSupplyBefore = sNft.totalSupply();
        vm.prank(USER);

        sNft.mintNft(TOKEN_URI);
        uint256 expectedTokenId = 0;
        uint256 actualTokenId = sNft.tokenCounter() - 1; // as after mint it increments, thus -1 to get the previous id
        console.log("ActualTokenUId - ", actualTokenId);
        assertEq(expectedTokenId, actualTokenId);
        string memory expectedTokenUri = TOKEN_URI;
        string memory actualTokenUri = sNft.tokenURI(actualTokenId);
        console.log("actual Token Uri - ", actualTokenUri);
        assert(keccak256(abi.encodePacked(expectedTokenUri)) == keccak256(abi.encodePacked(actualTokenUri)));
        uint256 tokenSupplyAfter = sNft.totalSupply();
        assertTrue(tokenSupplyAfter == totalSupplyBefore + 1);
    }
    ///////////////////////////////////////////////////////////////////
    //////////////////////  burn Function Test   //////////////////////
    ///////////////////////////////////////////////////////////////////

    function testBurnFullFunction() public {
        vm.prank(USER);
        sNft.mintNft(TOKEN_URI);
        uint256 totalSupplyBefore = sNft.totalSupply();
        console.log(totalSupplyBefore);

        vm.prank(USER);
        sNft.burn(0);
        uint256 totalSupplyAfter = sNft.totalSupply();
        assertTrue(totalSupplyBefore != totalSupplyAfter);
        assertEq(sNft.tokenURI(0), "");
        vm.expectRevert();
        sNft.ownerOf(0);
    }
}
