#!/bin/bash

# Comprehensive script to set up and run PiMetaConnect project on Replit, ensuring everything is free

echo "Starting full setup for PiMetaConnect project..."

# Step 1: Check for required tools (Node.js, npm, tmux)
echo "Checking for required tools..."
if ! command -v node &> /dev/null; then
    echo "Error: Node.js not found! Replit should have Node.js by default."
    exit 1
else
    echo "Node.js is installed: $(node --version)"
fi

if ! command -v npm &> /dev/null; then
    echo "Error: npm not found! Replit should have npm by default."
    exit 1
else
    echo "npm is installed: $(npm --version)"
fi

# Install tmux for running multiple processes in parallel (Replit supports tmux in free plan)
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        apt-get update && apt-get install -y tmux
    else
        echo "Error: tmux not found and cannot be installed automatically on this system."
        exit 1
    fi
else
    echo "tmux is installed: $(tmux -V)"
fi

# Step 2: Ensure working directory is correct
echo "Setting up working directory..."
if [ ! -d "PiMetaConnect" ]; then
    echo "Cloning the repository..."
    git clone https://github.com/Ze0r099/PiMetaConnect.git
    cd PiMetaConnect
else
    echo "Repository already exists."
    cd PiMetaConnect
fi

# Step 3: Set up blockchain dependencies and Hardhat
echo "Setting up blockchain dependencies..."
cd blockchain

# Check if package.json exists, if not, initialize it and install Hardhat
if [ ! -f "package.json" ]; then
    echo "Initializing package.json in blockchain directory..."
    npm init -y
    echo "Installing Hardhat and dependencies..."
    npm install --save-dev hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers
fi

# Check if Hardhat is installed
if ! command -v npx &> /dev/null || ! npx hardhat --version &> /dev/null; then
    echo "Error: Hardhat not installed correctly. Installing now..."
    npm install --save-dev hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers
fi

# Create a basic Hardhat config if it doesn't exist
if [ ! -f "hardhat.config.js" ]; then
    echo "Creating Hardhat configuration..."
    echo "require('@nomiclabs/hardhat-waffle'); module.exports = { solidity: '0.8.0', networks: { localhost: { url: 'http://127.0.0.1:8545' } } };" > hardhat.config.js
fi

# Create a sample contract if none exists
if [ ! -d "contracts" ]; then
    echo "Creating sample contract..."
    mkdir contracts
    echo "pragma solidity ^0.8.0; contract PiMetaNFT { string public name = 'PiMetaNFT'; }" > contracts/PiMetaNFT.sol
fi

# Create a deploy script if it doesn't exist
if [ ! -d "scripts" ] || [ ! -f "scripts/deploy.js" ]; then
    echo "Creating deploy script..."
    mkdir -p scripts
    echo "async function main() { const PiMetaNFT = await ethers.getContractFactory('PiMetaNFT'); const piMetaNFT = await PiMetaNFT.deploy(); await piMetaNFT.deployed(); console.log('PiMetaNFT deployed to:', piMetaNFT.address); } main().then(() => process.exit(0)).catch((error) => { console.error(error); process.exit(1); });" > scripts/deploy.js
fi

# Create artifacts directory
echo "Creating blockchain/artifacts directory..."
mkdir -p artifacts

# Step 4: Compile smart contracts
echo "Compiling smart contracts..."
npx hardhat compile
if [ $? -ne 0 ]; then
    echo "Error: Failed to compile smart contracts. Check Hardhat setup and contract syntax."
    exit 1
fi

# Step 5: Copy the compiled artifact (PiMetaNFT.json) to the frontend directory
echo "Copying compiled artifact to frontend directory..."
cd ..
mkdir -p client/src/contracts
if [ -f "blockchain/artifacts/contracts/PiMetaNFT.sol/PiMetaNFT.json" ]; then
    cp blockchain/artifacts/contracts/PiMetaNFT.sol/PiMetaNFT.json client/src/contracts/PiMetaNFT.json
    echo "Artifact copied successfully to client/src/contracts/PiMetaNFT.json"
else
    echo "Error: PiMetaNFT.json not found in blockchain/artifacts/contracts/PiMetaNFT.sol/. Compilation may have failed."
    exit 1
fi

# Step 6: Deploy smart contracts
echo "Starting Hardhat node for local testnet..."
cd blockchain
npx hardhat node &
HARDHAT_PID=$!
sleep 10  # Wait to ensure Hardhat node starts

# Check if Hardhat node is running
if ! ps -p $HARDHAT_PID > /dev/null; then
    echo "Error: Hardhat node failed to start."
    exit 1
fi

echo "Deploying smart contracts..."
npx hardhat run scripts/deploy.js --network localhost
if [ $? -ne 0 ]; then
    echo "Error: Failed to deploy smart contracts."
    kill $HARDHAT_PID
    exit 1
fi
cd ..

# Step 7: Install dependencies for frontend and backend
echo "Installing frontend dependencies..."
if [ -d "client" ]; then
    cd client
    if [ ! -f "package.json" ]; then
        echo "Initializing package.json in client directory..."
        npm init -y
    fi
    npm install
    cd ..
else
    echo "Error: client directory not found! Please ensure it exists."
    kill $HARDHAT_PID
    exit 1
fi

echo "Installing backend dependencies..."
if [ -d "server" ]; then
    cd server
    if [ ! -f "package.json" ]; then
        echo "Initializing package.json in server directory..."
        npm init -y
    fi
    npm install
    # Ensure server binds to 0.0.0.0
    if [ -f "index.js" ]; then
        if ! grep -q "app.listen(PORT, '0.0.0.0'" index.js; then
            echo "Updating server to bind to 0.0.0.0..."
            echo "const express = require('express'); const app = express(); const PORT = process.env.PORT || 3000; app.get('/', (req, res) => res.send('PiMetaConnect Backend')); app.listen(PORT, '0.0.0.0', () => console.log('Server running on port ' + PORT));" > index.js
        fi
    else
        echo "Creating basic server file..."
        echo "const express = require('express'); const app = express(); const PORT = process.env.PORT || 3000; app.get('/', (req, res) => res.send('PiMetaConnect Backend')); app.listen(PORT, '0.0.0.0', () => console.log('Server running on port ' + PORT));" > index.js
        npm install express
    fi
    cd ..
else
    echo "Error: server directory not found! Please ensure it exists."
    kill $HARDHAT_PID
    exit 1
fi

# Step 8: Run the application using tmux for parallel execution
echo "Starting all components using tmux..."

# Create a new tmux session
tmux new-session -d -s pimeta

# Split the tmux window into three panes
tmux split-window -h
tmux split-window -v

# Run frontend in the first pane
tmux select-pane -t 0
tmux send-keys "cd PiMetaConnect/client && npm start" C-m

# Run backend in the second pane
tmux select-pane -t 1
tmux send-keys "cd PiMetaConnect/server && npm start" C-m

# Keep Hardhat node running in the third pane
tmux select-pane -t 2
tmux send-keys "cd PiMetaConnect/blockchain && npx hardhat node" C-m

# Attach to the tmux session to see output
tmux attach-session -t pimeta

# Step 9: Git operations (optional, uncomment if needed)
# echo "Committing changes to Git..."
# git add .
# git commit -m "Complete setup and deployment of PiMetaConnect"
# git push origin main

echo "All steps are 100% free! PiMetaConnect is now running."
