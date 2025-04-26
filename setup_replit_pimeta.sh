#!/bin/bash

# Script to set up and run PiMetaConnect on Replit
echo "Starting setup for PiMetaConnect on Replit..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "Error: Node.js not found!"
    exit 1
else
    echo "Node.js is installed."
fi

# Clone repository
if [ ! -d "PiMetaConnect" ]; then
    echo "Cloning the repository..."
    git clone https://github.com/Ze0r099/PiMetaConnect.git
    cd PiMetaConnect
else
    echo "Repository already exists."
    cd PiMetaConnect
fi

# Install frontend dependencies
if [ -d "client" ]; then
    echo "Installing frontend dependencies..."
    cd client
    npm install
    cd ..
else
    echo "Warning: client directory not found!"
fi

# Install backend dependencies
if [ -d "server" ]; then
    echo "Installing backend dependencies..."
    cd server
    npm install
    cd ..
else
    echo "Warning: server directory not found!"
fi

# Install blockchain dependencies
if [ -d "blockchain" ]; then
    echo "Installing blockchain dependencies..."
    cd blockchain
    npm install
    cd ..
else
    echo "Warning: blockchain directory not found!"
fi

# Setup complete
echo "Setup completed! Use these commands in separate shells:"
echo "Frontend: cd PiMetaConnect/client && npm start"
echo "Backend: cd PiMetaConnect/server && npm start"
echo "Blockchain: cd PiMetaConnect/blockchain && npx hardhat node"
