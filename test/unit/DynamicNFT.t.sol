// SPDX-License-Identifier: MIT

import {DeployDynamicNFT} from "script/DeployDynamic.s.sol";
import {DynamicNFT} from "src/DynamicNFT.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

pragma solidity ^0.8.19;

contract DynamicNFTTest is Test {
    DeployDynamicNFT public deployer;
    DynamicNFT public dNFT;

    address public user = makeAddr("User");
    address public otherUser = makeAddr("otherUser");
    uint256 internal mintedTokenId;

    event SpinedMood(uint256 indexed tokenId, DynamicNFT.Mood beforeFlip, DynamicNFT.Mood afterFlip);

    function setUp() public {
        deployer = new DeployDynamicNFT();
        dNFT = deployer.run();
    }

    modifier minthelper() {
        vm.prank(user);
        mintedTokenId = dNFT.mintDynamicNFT();
        _;
    }
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\ CONSTRUCTOR \/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\

    function testNameAndSymbol() public view {
        string memory expectedName = "SPIRIT NFT";
        string memory expectedSymbol = "$ST";

        string memory actualName = dNFT.name();
        string memory actualSymbol = dNFT.symbol();

        console.log("Actual Name - ", actualName);
        console.log("Actual Symbol - ", actualSymbol);

        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }

    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\     MINT    \/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\

    function testDynamicMintFunction() public minthelper {
        console.log("user address", address(user));

        console.log("Owner is- ", dNFT.ownerOf(mintedTokenId));

        assertEq(dNFT.ownerOf(mintedTokenId), user);
        console.log("modd info ,", uint256(dNFT.getMoodInfo(mintedTokenId)));
        console.log("2nd info", uint256(DynamicNFT.Mood.HAPPY));
        assertEq(uint256(dNFT.getMoodInfo(mintedTokenId)), uint256(DynamicNFT.Mood.HAPPY));
        assertEq(dNFT.totalSupply(), 1);
        console.log("TokenId -- ", mintedTokenId);
        assertEq(mintedTokenId, 0);
    }

    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\     Burn    \/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\

    function testBurnFunction() public minthelper {
        uint256 totalsupplyBeforeBurn = dNFT.totalSupply();
        console.log("before Burn, total supply", dNFT.totalSupply());
        vm.prank(user);
        // uint256 moodBeforeBurn = uint256(dNFT.getMoodInfo(mintedTokenId));
        dNFT.burn(mintedTokenId);

        vm.expectRevert();
        dNFT.ownerOf(mintedTokenId);

        vm.expectRevert(
            abi.encodeWithSelector(DynamicNFT.DynamicNFT___upturnMoodNFT_InvalidTokenId.selector, mintedTokenId)
        );
        dNFT.getMoodInfo(mintedTokenId);
        console.log("After Burn, total supply", dNFT.totalSupply());
        assertEq(totalsupplyBeforeBurn - 1, dNFT.totalSupply());
    }

    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\ UpturnMoodNFT \/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\

    function testUpturnMoodRevertsIfCallerNotOwnerOrApproved() public minthelper {
        vm.expectRevert(
            abi.encodeWithSelector(
                DynamicNFT.DynamicNFT___upturnMoodNFT_CallerNotOwnerNorApproved.selector, mintedTokenId, otherUser
            )
        );
        vm.prank(otherUser);
        dNFT.upturnMoodNFT(mintedTokenId, DynamicNFT.Mood.SAD);
    }

    function testUpturnRevertsIfNonExistedTokenIdOrAfterBurn() public minthelper {
        vm.prank(user);
        dNFT.burn(mintedTokenId);

        vm.expectRevert(
            abi.encodeWithSelector(
                DynamicNFT.DynamicNFT___upturnMoodNFT_InvalidTokenIdOrCheckCallerBalance.selector, user, mintedTokenId
            )
        );
        vm.prank(user);
        dNFT.upturnMoodNFT(mintedTokenId, DynamicNFT.Mood.SAD);

        vm.expectRevert(
            abi.encodeWithSelector(
                DynamicNFT.DynamicNFT___upturnMoodNFT_InvalidTokenIdOrCheckCallerBalance.selector, user, 100
            )
        );
        vm.prank(user);
        dNFT.upturnMoodNFT(100, DynamicNFT.Mood.SAD);
    }

    function testUpturnWillRevertIfchangedToSameEnum() public minthelper {
        vm.expectRevert(DynamicNFT.DynamicNFT___upturnMoodNFT_NoMoodFlipToTheSameMood.selector);
        vm.prank(user);
        dNFT.upturnMoodNFT(mintedTokenId, DynamicNFT.Mood.HAPPY);
    }

    function testUpturnFunctionOnSuccesFlipAndEmitsEvent() public minthelper {
        vm.prank(user);
        dNFT.upturnMoodNFT(mintedTokenId, DynamicNFT.Mood.SAD);
        assertEq(uint256(dNFT.getMoodInfo(mintedTokenId)), uint256(DynamicNFT.Mood.SAD));

        vm.expectEmit(true, false, false, true);
        emit SpinedMood(mintedTokenId, DynamicNFT.Mood.SAD, DynamicNFT.Mood.HAPPY);
        vm.prank(user);
        dNFT.upturnMoodNFT(mintedTokenId, DynamicNFT.Mood.HAPPY);
        assertEq(uint256(dNFT.getMoodInfo(mintedTokenId)), uint256(DynamicNFT.Mood.HAPPY));
    }

    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\/ getMoodInfo /\/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\

    function testGetMoodInfoFunctionFully() public minthelper {
        vm.expectRevert(abi.encodeWithSelector(DynamicNFT.DynamicNFT___upturnMoodNFT_InvalidTokenId.selector, 90));
        dNFT.getMoodInfo(90);
        assertEq(0, uint256(dNFT.getMoodInfo(mintedTokenId)));
        vm.prank(user);
        dNFT.upturnMoodNFT(mintedTokenId, DynamicNFT.Mood.SAD);
        assertEq(1, uint256(dNFT.getMoodInfo(mintedTokenId)));
        vm.prank(user);
        dNFT.burn(mintedTokenId);
        vm.expectRevert(
            abi.encodeWithSelector(DynamicNFT.DynamicNFT___upturnMoodNFT_InvalidTokenId.selector, mintedTokenId)
        );
        dNFT.getMoodInfo(mintedTokenId);
    }

    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/       tokenURI      /\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\

    function testTokenUriRevrtsOnInavlidTokenOrBurnedToken() public minthelper {
        vm.expectRevert(
            abi.encodeWithSelector(DynamicNFT.DynamicNFT___tokenURI_URIqueryForNonExistentToken.selector, 100)
        );
        dNFT.tokenURI(100);

        vm.prank(user);
        dNFT.burn(mintedTokenId);
        vm.expectRevert(
            abi.encodeWithSelector(DynamicNFT.DynamicNFT___tokenURI_URIqueryForNonExistentToken.selector, mintedTokenId)
        );
        dNFT.tokenURI(mintedTokenId);
    }

    function testTokenURIAfterCheckPasses() public minthelper {
        string memory uriInfo = dNFT.tokenURI(mintedTokenId); // uriInfo is also here the happyUri as by default is happy in mint;

        // tokenURI not empty check
        assertTrue(bytes(uriInfo).length > 0);

        //check if the prefix is in the full tokenUri of the token with the help of the helper function created below
        string memory prefixData = "data:application/json;base64,";
        assertTrue(_helperStringURI(uriInfo, prefixData));

        //tokenUri should change after upturn function is called
        vm.prank(user);
        dNFT.upturnMoodNFT(mintedTokenId, DynamicNFT.Mood.SAD);
        string memory sadUri = dNFT.tokenURI(mintedTokenId);
        assertTrue(_helperStringURI(sadUri, prefixData)); //caution if prefix is same, which it should be
        //  assertTrue(keccak256(abi.encodePacked(uriInfo)) != keccak256(abi.encodePacked(sadUri)));
        //for a single string bytes and abi.encodePacked ==
        assertTrue(keccak256(bytes(sadUri)) != keccak256(bytes(uriInfo)));
    }

    //Helper Function for TokenURI as it contains string!!
    function _helperStringURI(string memory fullStringUri, string memory prefixURI) internal pure returns (bool) {
        bytes memory fullBytes = bytes(fullStringUri);
        bytes memory prefixBytes = bytes(prefixURI);

        if (fullBytes.length < prefixBytes.length) return false;

        for (uint256 i = 0; i < prefixBytes.length; i++) {
            if (fullBytes[i] != prefixBytes[i]) return false;
        }

        return true;
    }

    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/   tOTALsUPPLY ++ -- /\/\/\/\/\/\/\/\/\/\\
    //\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\

    function testTotalSupplyIncrementsAndDecrements() public {
        vm.startPrank(user);

        uint256 t1 = dNFT.mintDynamicNFT();

        uint256 t2 = dNFT.mintDynamicNFT();

        vm.stopPrank();

        assertEq(dNFT.totalSupply(), 2);

        uint256 beforeBurnTS = dNFT.totalSupply();
        vm.prank(user);

        dNFT.burn(t1);

        assertEq(dNFT.totalSupply(), beforeBurnTS - 1);

        vm.prank(user);
        dNFT.burn(t2);
        assertEq(dNFT.totalSupply(), 0);
    }
}
