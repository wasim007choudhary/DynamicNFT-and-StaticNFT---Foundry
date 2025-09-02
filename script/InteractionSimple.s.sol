// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {SimpleNft} from "src/StaticNFT.sol";

contract MintSimpleNFT is Script {
    string public constant TOKEN_URI = "ipfs://QmPRQbtRCTuq8zKqzJTivHrFoZnpedMeHhNFeH2eH6gzRU";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("SimpleNft", block.chainid);
        mintNftOnTheDeployedContract(mostRecentlyDeployed);
    }

    function mintNftOnTheDeployedContract(address contractAddress) public {
        vm.startBroadcast();
        SimpleNft(contractAddress).mintNft(TOKEN_URI);
        vm.stopBroadcast();
    }
}
