# Quick Start Guide 🚀

Get the Aptos Gated Community Chat running in 5 minutes!

## Prerequisites

- ✅ Aptos CLI installed (`aptos --version` should work)
- ✅ Node.js 18+ installed
- ✅ Aptos wallet (Petra recommended)

## Step 1: Navigate to Project

```bash
cd /Users/juhir/.gemini/antigravity/scratch/aptos-gated-chat
```

## Step 2: Start the App

```bash
cd frontend
npm run dev
```

You should see:
```
✓ Ready in 971ms
▲ Next.js 16.0.5 (Turbopack)
- Local: http://localhost:3001
```

## Step 3: Open in Browser

Open http://localhost:3001

## Step 4: Connect Your Wallet

1. Click **"Connect Wallet"** button (or the wallet selector)
2. Choose **Petra Wallet** (or your preferred wallet)
3. Click **"Connect"** in the wallet popup
4. Approve the connection

## Step 5: Explore the App

### View Communities
- See "Aptos Devs" and "NFT Collectors" in the sidebar
- Click on any community to view its chat

### Send a Message
1. Select a community
2. Type your message in the input box
3. Press **Enter** or click **Send**

### Create a Community
1. Click the **+** button in the sidebar
2. Enter a community name
3. Approve the transaction in your wallet
4. Wait 2-5 seconds for confirmation

## Smart Contract Info

**Module Address**: `0x4456fe29a8cebca8632068f79ac50e79d3675b87e0cddcb1f24d95ec5d218bba`  
**Network**: Aptos Devnet  
**Explorer**: [View Contract](https://explorer.aptoslabs.com/account/0x4456fe29a8cebca8632068f79ac50e79d3675b87e0cddcb1f24d95ec5d218bba?network=devnet)

## Troubleshooting

### "Site can't be reached"
```bash
# Kill any existing process and restart
lsof -ti:3001 | xargs kill -9
npm run dev
```

### Wallet not connecting
- Ensure wallet is on **Devnet** (check settings)
- Try refreshing the page
- Try a different wallet (Pontem, Martian)

### Build errors
```bash
npm install --legacy-peer-deps
npm run build
```

### Hydration warnings
Already fixed! If you see them, clear cache (Cmd+Shift+R)

## What's Next?

Once you're up and running:

1. **Test creating a community** - Triggers a real blockchain transaction
2. **Check the explorer** - View your transactions on Aptos Explorer
3. **Invite friends** - Share the link (needs their wallet)
4. **Read the docs** - See `README.md` and `DEPLOYMENT_GUIDE.md`

## Need Help?

- 📖 Check `DEPLOYMENT_GUIDE.md` for detailed instructions
- 🐛 Look at `PROJECT_SUMMARY.md` for architecture details
- 💡 Review `walkthrough.md` for feature explanations

---

**You're all set!** 🎉 Enjoy your token-gated chat on Aptos!
