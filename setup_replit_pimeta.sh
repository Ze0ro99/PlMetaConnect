#!/bin/bash

# Script to set up and run PiMetaConnect on Replit from a mobile device

echo "Starting setup for PiMetaConnect on Replit..."

# 1. Check for required tools (Replit has Node.js and npm by default)
echo "Checking for required tools..."

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "Error: Node.js not found! Replit should have Node.js by default."
    exit 1
else
    echo "Node.js is installed."
fi

# Check for Docker (Replit has limited Docker support in the free plan)
if ! command -v docker &> /dev/null; then
    echo "Warning: Docker not installed. Replit does not fully support Docker in the free plan."
    echo "Skipping Docker services for now."
else
    echo "Docker is installed."
fi

# 2. Clone the repository if not already present
if [ ! -d "PiMetaConnect" ]; then
    echo "Cloning the repository..."
    git clone https://github.com/Ze0r099/PiMetaConnect.git
    cd PiMetaConnect
else
    echo "Repository already exists."
    cd PiMetaConnect
fi

# 3. Install dependencies for the frontend (/client/)
if [ -d "client" ]; then
    echo "Installing frontend dependencies..."
    cd client
    npm install
    cd ..
else
    echo "Warning: client directory not found!"
fi

# 4. Install dependencies for the backend (/server/)
if [ -d "server" ]; then
    echo "Installing backend dependencies..."
    cd server
    npm install
    cd ..
else
    echo "Warning: server directory not found!"
fi

# 5. Install dependencies for smart contracts (/blockchain/)
if [ -d "blockchain" ]; then
    echo "Installing smart contract dependencies..."
    cd blockchain
    npm install
    cd ..
else
    echo "Warning: blockchain directory not found!"
fi

# 6. Instructions to run the components
echo "Setup completed successfully! To run the components, open separate Shell windows in Replit and use the following commands:"

echo "To run the frontend:"
echo "cd PiMetaConnect/client && npm start"

echo "To run the backend:"
echo "cd PiMetaConnect/server && npm start"

echo "To run a testnet for smart contracts:"
echo "cd PiMetaConnect/blockchain && npx hardhat node"

echo "Note: Replit does not support running the metaverse (/metaverse/) directly as it requires Unity."
echo "To run the metaverse, use a computer and install Unity (Personal Edition - free)."

echo "All steps above are 100% free!"
