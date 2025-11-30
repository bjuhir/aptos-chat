# Step-by-Step Deployment Guide: Aptos Gated Community Chat

This guide walks you through building and deploying the Aptos Gated Community Chat from scratch.

## Prerequisites Setup

### 1. Install Aptos CLI

**macOS (Homebrew)**:
```bash
brew install aptos
```

**Linux**:
```bash
wget -qO- https://aptos.dev/scripts/install_cli.py | python3
```

Verify installation:
```bash
aptos --version
```

### 2. Install Node.js & npm

Download from [nodejs.org](https://nodejs.org/) (v18 or later recommended)

Verify:
```bash
node --version
npm --version
```

### 3. Install an Aptos Wallet

- **Petra Wallet** (Recommended): Install from [petra.app](https://petra.app/)
- Switch to **Devnet** in wallet settings

---

## Part 1: Smart Contract Development

### Step 1: Initialize Move Project

```bash
# Create project directory
mkdir aptos-gated-chat
cd aptos-gated-chat
mkdir move
cd move

# Initialize Move package
aptos move init --name GatedChat
```

### Step 2: Configure Aptos Account

```bash
# Generate new account and fund it on Devnet
aptos init --network devnet
```

This will:
- Generate a new private key
- Create an account on Devnet
- Fund it with test APT tokens
- Save config to `.aptos/config.yaml`

**Note the generated address** - you'll need it later!

### Step 3: Update Move.toml

Edit `Move.toml` and add your address under `[addresses]`:

```toml
[addresses]
gated_chat = "YOUR_ADDRESS_HERE"
```

### Step 4: Create Smart Contract

Create `sources/gated_chat.move` with the following structure:

```move
module gated_chat::gated_chat {
    // Imports
    use std::string::String;
    use std::vector;
    use std::signer;
    use aptos_framework::event;
    use aptos_framework::timestamp;
    
    // Data structures for Community, Channel, Message
    // Functions: create_community, join_community, send_message
    // Events: CommunityCreated, MemberJoined, MessageSent
}
```

*(See full implementation in `sources/gated_chat.move`)*

### Step 5: Compile the Contract

```bash
aptos move compile
```

Expected output: `✅ BUILDING GatedChat`

### Step 6: Deploy to Devnet

```bash
aptos move publish --assume-yes
```

You should see:
```
✅ Transaction submitted: https://explorer.aptoslabs.com/txn/...
✅ success: true
```

**Save the transaction hash** to verify on [Aptos Explorer](https://explorer.aptoslabs.com/?network=devnet).

---

## Part 2: Frontend Development

### Step 1: Initialize Next.js Project

```bash
# From project root
cd ..
npx create-next-app@latest frontend \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --no-src-dir \
  --import-alias "@/*"
```

When prompted:
- **React Compiler**: Select "Yes" (optional)

### Step 2: Install Aptos Dependencies

```bash
cd frontend
npm install @aptos-labs/ts-sdk @aptos-labs/wallet-adapter-react --legacy-peer-deps
npm install @aptos-labs/wallet-adapter-ant-design antd --legacy-peer-deps
npm install lucide-react clsx tailwind-merge
```

### Step 3: Create Project Structure

```bash
mkdir components utils
```

### Step 4: Configure Aptos Client

Create `utils/aptos.ts`:

```typescript
import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";

export const MODULE_ADDRESS = "YOUR_MODULE_ADDRESS_HERE";
export const MODULE_NAME = "gated_chat";

const config = new AptosConfig({ network: Network.DEVNET });
export const aptos = new Aptos(config);
```

**Replace `YOUR_MODULE_ADDRESS_HERE`** with your deployed contract address.

### Step 5: Create Wallet Provider

Create `components/WalletProvider.tsx`:

```typescript
"use client";

import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";
import { PropsWithChildren } from "react";

export const WalletProvider = ({ children }: PropsWithChildren) => {
  return (
    <AptosWalletAdapterProvider autoConnect={true}>
      {children}
    </AptosWalletAdapterProvider>
  );
};
```

### Step 6: Update Root Layout

Edit `app/layout.tsx`:

```typescript
import { WalletProvider } from "@/components/WalletProvider";

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <WalletProvider>{children}</WalletProvider>
      </body>
    </html>
  );
}
```

### Step 7: Build the Chat UI

Create `app/page.tsx` with:
- Wallet connection button
- Community sidebar
- Chat interface
- Message input

*(See full implementation in `app/page.tsx`)*

### Step 8: Build and Test

```bash
# Build for production
npm run build

# Run development server
npm run dev
```

Open [http://localhost:3000](http://localhost:3000)

---

## Part 3: Verification & Testing

### Step 1: Connect Wallet

1. Open the app in your browser
2. Click **Connect Wallet**
3. Select **Petra** (or your wallet)
4. Approve the connection

### Step 2: Create a Community

1. Click the **+** button in the sidebar
2. Enter a community name
3. Approve the transaction in your wallet
4. Wait for confirmation (~2-5 seconds)

### Step 3: Send Messages

1. Select a community from the sidebar
2. Type a message in the input box
3. Click **Send** or press Enter
4. (For on-chain messages, uncomment the transaction code in `page.tsx`)

### Step 4: Verify on Explorer

1. Go to [Aptos Explorer](https://explorer.aptoslabs.com/?network=devnet)
2. Search for your module address
3. View the **Events** tab to see:
   - `CommunityCreated` events
   - `MessageSent` events
   - `MemberJoined` events

---

## Part 4: Advanced Features (Optional)

### A. Implement NFT Gating

Update `join_community` in Move to check NFT ownership:

```move
// Check if user owns required NFT
let token_balance = token::balance_of(user_addr, gating_collection);
assert!(token_balance > 0, E_NOT_TOKEN_HOLDER);
```

### B. Integrate Aptos Indexer

Use GraphQL to fetch message history:

```typescript
const query = `
  query GetMessages($module_address: String!) {
    events(
      where: {
        account_address: {_eq: $module_address}
        type: {_eq: "MessageSent"}
      }
      order_by: {transaction_version: desc}
    ) {
      data
    }
  }
`;
```

### C. Add IPFS Storage

For larger messages or media:

1. Install `ipfs-http-client`
2. Upload to IPFS and store hash on-chain
3. Retrieve from IPFS for display

---

## Troubleshooting

### Build Errors

**Error: Module not found**
```bash
npm install --legacy-peer-deps
```

**Move compilation fails**
- Ensure `Move.toml` has correct address
- Run `aptos move clean` then recompile

### Wallet Connection Issues

- Ensure wallet is on **Devnet**
- Clear browser cache and reconnect
- Try a different wallet

### Transaction Failures

- Check account has sufficient APT (use faucet if needed)
- Verify module address in `utils/aptos.ts`
- Check Explorer for error messages

---

## Production Deployment Checklist

- [ ] Audit smart contract code
- [ ] Test with multiple wallets
- [ ] Implement proper error handling
- [ ] Add loading states and toast notifications
- [ ] Set up Aptos Indexer integration
- [ ] Configure environment variables for addresses
- [ ] Deploy frontend to Vercel/Netlify
- [ ] Switch network to Mainnet
- [ ] Fund account with real APT for gas
- [ ] Redeploy contract to Mainnet
- [ ] Update `MODULE_ADDRESS` in frontend
- [ ] Monitor gas costs and optimize

---

## Support & Resources

- **Aptos Discord**: [discord.gg/aptosnetwork](https://discord.gg/aptosnetwork)
- **Aptos Docs**: [aptos.dev](https://aptos.dev)
- **Move Tutorial**: [move-language.github.io](https://move-language.github.io/move/)
- **Wallet Adapter Repo**: [github.com/aptos-labs/aptos-wallet-adapter](https://github.com/aptos-labs/aptos-wallet-adapter)

---

**Congratulations!** 🎉 You've built and deployed a token-gated chat app on Aptos!
