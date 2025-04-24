#!/bin/bash
echo "Starting PiMetaConnect setup..."

# Step 1: Install Frontend Dependencies
echo "Installing frontend dependencies..."
cd client || { echo "Error: client directory not found."; exit 1; }
yarn install
if [ $? -ne 0 ]; then
  echo "Error installing frontend dependencies."
  exit 1
fi

# Step 2: Install Backend Dependencies
echo "Installing backend dependencies..."
cd ../server || { echo "Error: server directory not found."; exit 1; }
yarn install
if [ $? -ne 0 ]; then
  echo "Error installing backend dependencies."
  exit 1
fi

# Step 3: Install Blockchain Dependencies
echo "Installing blockchain dependencies..."
cd ../blockchain || { echo "Error: blockchain directory not found."; exit 1; }
yarn install
if [ $? -ne 0 ]; then
  echo "Error installing blockchain dependencies."
  exit 1
fi

# Step 4: Build Unity Metaverse Project
echo "Building Unity metaverse project..."
cd ../metaverse || { echo "Error: metaverse directory not found."; exit 1; }
unity -batchmode -projectPath . -buildTarget WebGL -executeMethod BuildScript.Build
if [ $? -ne 0 ]; then
  echo "Error building Unity project."
  exit 1
fi

# Step 5: Deploy NFT Smart Contracts
echo "Deploying NFT smart contracts..."
cd ../blockchain || { echo "Error: blockchain directory not found for deployment."; exit 1; }
npx hardhat run scripts/deploy.js --network localhost
if [ $? -ne 0 ]; then
  echo "Error deploying smart contracts."
  exit 1
fi

# Step 6: Start Services Using Docker Compose
echo "Starting services with Docker Compose..."
cd ..
docker-compose up -d
if [ $? -ne 0 ]; then
  echo "Error starting Docker services."
  exit 1
fi

echo "PiMetaConnect setup and execution completed successfully!"
