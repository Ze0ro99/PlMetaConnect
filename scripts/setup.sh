#!/bin/bash
set -e

echo "Starting PiMetaConnect setup..."

# Step 1: Check and install Node.js and Yarn
if ! command -v node &> /dev/null; then
  echo "Node.js not found. Installing Node.js..."
  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo "Node.js is already installed."
fi

if ! command -v yarn &> /dev/null; then
  echo "Yarn not found. Installing Yarn..."
  npm install -g yarn
else
  echo "Yarn is already installed."
fi

# Step 2: Install frontend dependencies
cd client
yarn install
cd ..

# Step 3: Install backend dependencies
cd server
yarn install
cd ..

# Step 4: Install blockchain dependencies and setup Hardhat
cd blockchain
if [ ! -f "package.json" ]; then
  npm init -y
fi
yarn add hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers
if [ ! -f "hardhat.config.js" ]; then
  echo "require('@nomiclabs/hardhat-waffle'); module.exports = { solidity: '0.8.0', networks: { localhost: { url: 'http://127.0.0.1:8545' } } };" > hardhat.config.js
fi
cd ..

echo "Setup complete! Please register your app in the Pi Developer Portal and start the project as described in the README."
