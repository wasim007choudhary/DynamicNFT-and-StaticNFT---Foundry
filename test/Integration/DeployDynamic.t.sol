// SPDX-License-Identifer: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DynamicNFT} from "src/DynamicNFT.sol";
import {DeployDynamicNFT} from "script/DeployDynamic.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployDynamicScriptTest is Test {
    DeployDynamicNFT public deployer;

    function setUp() public {
        deployer = new DeployDynamicNFT();
    }

    function testSvgToImageUriFunction() public {
        string memory svgRToConvert = vm.readFile("img/happy.svg");
        //  '<svg viewBox="0 0 200 200" width="400" height="400" xmlns="http://www.w3.org/2000/svg"><circle cx="100" cy="100" fill="yellow" r="78" stroke="black" stroke-width="3" /><g class="eyes"><circle cx="70" cy="82" r="12" /><circle cx="127" cy="82" r="12" /></g><path d="m136.81 116.53c.69 26.17-64.11 42-81.52-.73" style="fill:none; stroke: black; stroke-width: 3;" /></svg>';
        string memory expectedImageURI =
        //"data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIgLz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI3MCIgY3k9IjgyIiByPSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8L2c+CiAgICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAvPgo8L3N2Zz4=";
         string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svgRToConvert))));

        string memory actualImageUri = deployer.svgToImageURI(svgRToConvert);
        console.log("expected ImageURI - ", expectedImageURI);
        console.log("Actual ImageURI - ", actualImageUri);

        assert(keccak256(abi.encodePacked(expectedImageURI)) == keccak256(abi.encodePacked(actualImageUri)));
    }
}
