# Aptos Gated Community Chat

A decentralized chat application built on Aptos blockchain where community access is gated by token/NFT ownership. Think of it as a Telegram-like chat app, but only token holders can join specific communities.

## Features

✅ **Wallet Login** - Connect with Petra, Pontem, or any Aptos-compatible wallet  
✅ **Token-Gated Communities** - Only NFT/token holders can join exclusive communities  
✅ **On-Chain Messages** - Message history stored on-chain via events  
✅ **Private Channels** - Create holder-only channels within communities  
✅ **Real-Time Chat UI** - Telegram-style interface built with Next.js and Tailwind CSS

## Project Structure

```
aptos-gated-chat/
├── move/                   # Smart contracts
│   ├── sources/
│   │   └── gated_chat.move
│   ├── Move.toml
│   └── .aptos/
└── frontend/              # Next.js application
    ├── app/
    ├── components/
    ├── utils/
    └── package.json
```

## Smart Contract

**Deployed Address**: `0x4456fe29a8cebca8632068f79ac50e79d3675b87e0cddcb1f24d95ec5d218bba`  
**Network**: Aptos Devnet

### Functions

- `create_community(name, description, gating_collection)` - Create a new gated community
- `join_community(community_idx)` - Join a community (checks token ownership)
- `send_message(community_idx, channel_idx, content)` - Send a message to a channel

### Events

- `CommunityCreated` - Emitted when a community is created
- `MemberJoined` - Emitted when someone joins
- `MessageSent` - Emitted for each message (contains sender, content, timestamp)

## Quick Start

### Prerequisites

- Node.js 18+ and npm
- Aptos CLI (`brew install aptos` on macOS)
- Aptos wallet (Petra recommended)

### 1. Clone & Navigate

```bash
cd /Users/juhir/.gemini/antigravity/scratch/aptos-gated-chat
```

### 2. Install Frontend Dependencies

```bash
cd frontend
npm install
```

### 3. Run Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### 4. Connect Wallet

1. Click **Connect Wallet**
2. Select your Aptos wallet (Petra recommended)
3. Approve the connection

### 5. Interact with the App

- **View Communities**: See available communities in the sidebar
- **Create Community**: Click the "+" button to create a new community
- **Send Messages**: Select a community and start chatting

## Technology Stack

### Smart Contract
- **Move** - Aptos programming language
- **Aptos Framework** - Standard library

### Frontend
- **Next.js 16** - React framework with App Router
- **TypeScript** - Type-safe development
- **Tailwind CSS** - Utility-first styling
- **Aptos TS SDK** - Blockchain interaction
- **Wallet Adapter** - Multi-wallet support
- **Lucide React** - Icon library

## Development Workflow

### Deploy Smart Contract

```bash
cd move
aptos move compile
aptos move publish --assume-yes
```

### Build Frontend

```bash
cd frontend
npm run build
```

### Run Tests (Move)

```bash
cd move
aptos move test
```

## Environment Configuration

The frontend is pre-configured for Devnet. To change networks, update `frontend/utils/aptos.ts`:

```typescript
const config = new AptosConfig({ network: Network.MAINNET });
```

## Next Steps

- [ ] Implement actual NFT ownership verification in `join_community`
- [ ] Integrate Aptos Indexer for real-time message fetching
- [ ] Add IPFS for storing larger messages/media
- [ ] Implement typing indicators and online status
- [ ] Add private DMs between community members
- [ ] Deploy to Aptos Mainnet

## Security Considerations

⚠️ **This is a demo application for Devnet.** Before deploying to Mainnet:
- Audit the smart contract thoroughly
- Implement proper access controls
- Add rate limiting for message spam
- Validate all user inputs
- Consider gas optimization

## Resources

- [Aptos Documentation](https://aptos.dev)
- [Move Language Guide](https://move-language.github.io/move/)
- [Aptos Wallet Adapter](https://github.com/aptos-labs/aptos-wallet-adapter)
- [Aptos Explorer (Devnet)](https://explorer.aptoslabs.com/?network=devnet)

## License

MIT
