import { createWalletClient, createPublicClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { sepolia } from 'viem/chains';
import 'dotenv/config';

async function run7702Delegation() {
    const pk = process.env.PRIVATE_KEY as `0x${string}`;
    const logicAddr = process.env.LOGIC_CONTRACT_ADDRESS as `0x${string}`;
    
    const account = privateKeyToAccount(pk);
    const client = createWalletClient({
        account,
        chain: sepolia,
        transport: http(process.env.RPC_URL),
    });

    const publicClient = createPublicClient({
        chain: sepolia,
        transport: http(process.env.RPC_URL),
    });

    console.log(`🚀 Starting delegation for EOA: ${account.address}`);

    try {
        const nonce = await publicClient.getTransactionCount({
            address: account.address,
        });

        const unsignedAuth = await client.prepareAuthorization({
            account: account.address,
            contractAddress: logicAddr,
            executor: "self",
        });
        // 1. Sign the Authorization for EIP-7702
        // This creates the signature that allows the EOA to "borrow" the contract code
        const authorization = await client.signAuthorization(
           unsignedAuth
        );

        console.log("✅ Authorization signed successfully.");

        // 2. Send the Type-4 Transaction
        // We send this to ourselves (to: account.address) with the authorization list
        const hash = await client.sendTransaction({
            type: 'eip7702', // Explicitly setting the transaction type
            authorizationList: [authorization],
            to: account.address,
            value: 0n,
            nonce
        });

        console.log(`🔥 Transaction broadcasted! Hash: ${hash}`);
        console.log(`🔗 Check on Etherscan: https://sepolia.etherscan.io/tx/${hash}`);

    } catch (error) {
        console.error("❌ Execution failed:", error);
    }
}

run7702Delegation();
