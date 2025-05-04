#!/bin/bash
set -e

echo "Starting PiMetaConnect consolidated setup..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "Node.js not found. Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js is already installed."
fi

# Check Yarn
if ! command -v yarn &> /dev/null; then
    echo "Yarn not found. Installing Yarn..."
    npm install -g yarn
else
    echo "Yarn is already installed."
fi

# Install dependencies for frontend, backend, and blockchain
for dir in client server blockchain; do
    if [ -d "$dir" ]; then
        echo "Installing dependencies for $dir..."
        cd "$dir"
        yarn install
        cd ..
    else
        echo "Warning: $dir directory not found!"
    fi
done

# Blockchain-specific setup
if [ -d "blockchain" ]; then
    echo "Setting up blockchain environment..."
    cd blockchain
    yarn add hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers
    if [ ! -f "hardhat.config.js" ]; then
        echo "require('@nomiclabs/hardhat-waffle'); module.exports = { solidity: '0.8.0', networks: { localhost: { url: 'http://127.0.0.1:8545' } } };" > hardhat.config.js
    fi
    cd ..
else
    echo "Warning: blockchain directory not found!"
fi

echo "Setup complete! Please refer to the README for further instructions."