// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {SimpleNft} from "src/StaticNFT.sol";

contract DeploySimpleNft is Script {
    SimpleNft freedomNft;

    function run() external returns (SimpleNft) {
        vm.startBroadcast();
        freedomNft = new SimpleNft();
        vm.stopBroadcast();
        return freedomNft;
    }
}
