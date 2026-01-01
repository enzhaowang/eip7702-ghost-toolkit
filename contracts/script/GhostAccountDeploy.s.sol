// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import {Script} from "forge-std/Script.sol";
import {GhostAccount} from "../src/GhostAccount.sol";


contract GhostAccountDeploy is Script{

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new GhostAccount();

        vm.stopBroadcast();
    }

}