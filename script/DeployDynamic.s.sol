//  SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DynamicNFT} from "src/DynamicNFT.sol";
import {Script, console} from "forge-std/Script.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployDynamicNFT is Script {
    function run() external returns (DynamicNFT) {
        string memory happySvg = vm.readFile("./img/happy.svg");
        string memory sadSvg = vm.readFile("./img/sad.svg");

        vm.startBroadcast();
        DynamicNFT dNFT = new DynamicNFT(svgToImageURI(happySvg), svgToImageURI(sadSvg));
        vm.stopBroadcast();
        return dNFT;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURLprefix = "data:image/svg+xml;base64,";
        string memory encodedBase64svgPostFix = Base64.encode(bytes(string(abi.encodePacked(svg))));

        return string(abi.encodePacked(baseURLprefix, encodedBase64svgPostFix));
    }
}
