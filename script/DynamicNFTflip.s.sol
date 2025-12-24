// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DynamicNFT} from "src/DynamicNFT.sol";

contract FlipNFT is Script {
    function run(uint256 tokenId, uint256 mood) external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("DynamicNFT", block.chainid);
        flipNFT(mostRecentDeployment, tokenId, mood);
    }

    function flipNFT(address contractAddress, uint256 tokenId, uint256 mood) public {
        vm.startBroadcast();

        DynamicNFT dNFT = DynamicNFT(contractAddress);

        // Decide the mood
        DynamicNFT.Mood changeMood = (mood == 0) ? DynamicNFT.Mood.HAPPY : DynamicNFT.Mood.SAD;

        dNFT.upturnMoodNFT(tokenId, changeMood);
        changeMood = dNFT.getMoodInfo(tokenId);
        string memory moodStr = (changeMood == DynamicNFT.Mood.HAPPY) ? "HAPPY" : "SAD";
        console.log("Mood of the TokenId %s flipped to %s at contract %s", tokenId, moodStr, contractAddress);
        vm.stopBroadcast();
    }
}
