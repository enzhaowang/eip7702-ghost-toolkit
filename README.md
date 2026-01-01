# EIP-7702 Ghost Toolkit

This project demonstrates the power of **EIP-7702** by implementing a "Ghost Account" mechanism. It allows an Externally Owned Account (EOA) to temporarily or persistently delegate its code to a smart contract, enabling programmable behavior for standard wallets.

## 👻 What is Ghost Account?

The **Ghost Account** is a smart contract designed to be attached to an EOA via EIP-7702 delegation. Once an EOA delegates to this contract:

- **Auto-Forwarding:** Any ETH sent to the EOA is automatically intercepted and forwarded to a pre-defined "Vault" address.
- **Programmable EOA:** The EOA effectively behaves like a smart contract wallet without needing to migrate assets or change addresses.

This toolkit provides:
1.  **Solidity Contracts:** The logic contract (`GhostAccount.sol`) and Foundry tests simulating the EIP-7702 behavior.
2.  **Backend Script:** A TypeScript script using `viem` to sign the EIP-7702 authorization and broadcast the delegation transaction.

## 📂 Project Structure

- `contracts/` - Foundry project containing the smart contracts.
  - `src/GhostAccount.sol`: The implementation contract that forwards funds.
  - `test/GhostAccount.t.sol`: Tests validating the forwarding logic.
- `backend/` - Node.js project for interacting with the blockchain.
  - `src/index.ts`: Script to sign and send the EIP-7702 delegation transaction.

## 🚀 Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Node.js](https://nodejs.org/) & [pnpm](https://pnpm.io/)

### 1. Setup Contracts

Navigate to the `contracts` directory to build and deploy the logic contract.

```bash
cd contracts
forge install
forge build
```

**Deploy to blockchain :**

- Create a `.env` file in `contracts/` (see `.env(sample)`)

- Update 0xhacker_vault_address_here to real vault address


Run the deployment script:
```bash
forge script script/GhostAccountDeploy.s.sol --rpc-url $RPC_URL --broadcast
```

Copy the deployed **GhostAccount address**.

### 2. Run Delegation Script

Navigate to the `backend` directory to perform the EIP-7702 delegation.

```bash
cd backend
pnpm install
```

**Configuration:**

Create a `.env` file in `backend/` (see `.env(sample)`):
```env
PRIVATE_KEY=your_eoa_private_key      # The account you want to turn into a Ghost Account
RPC_URL=your_rpc_url                  # e.g. Sepolia RPC
LOGIC_CONTRACT_ADDRESS=0x...          # Address of the deployed GhostAccount
```

**Execute:**

```bash
pnpm start
```

This script will:
1.  Sign an EIP-7702 Authorization for your EOA.
2.  Broadcast a transaction to apply this authorization.
3.  Once confirmed, your EOA now has the code of `GhostAccount`.

## ⚠️ Disclaimer

This project is for **educational and demonstration purposes only**. EIP-7702 is a new standard and behavior on different networks may vary. Use with caution, especially with real funds.
