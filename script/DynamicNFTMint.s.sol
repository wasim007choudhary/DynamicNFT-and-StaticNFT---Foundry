// SPDX-License-Identifer: MIT

pragma solidity ^0.8.19;

import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Script, console} from "forge-std/Script.sol";
import {DynamicNFT} from "src/DynamicNFT.sol";

contract MintDynamicNFT is Script {
    function run() external {
        address mostRecentDeployedContract = DevOpsTools.get_most_recent_deployment("DynamicNFT", block.chainid);
        uint256 tokenId = mintNFT(mostRecentDeployedContract);
    }

    function mintNFT(address contractAddress) public returns (uint256) {
        vm.startBroadcast();
        DynamicNFT dNFT = DynamicNFT(contractAddress);
        uint256 tokenId = dNFT.mintDynamicNFT();
        console.log("Token Id is - ", tokenId);
        return tokenId;
    }
}
