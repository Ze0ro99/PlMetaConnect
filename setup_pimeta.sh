#!/bin/bash
echo "Starting PiMetaConnect complete repository build setup..."

# Step 1: Check and Install Node.js
echo "Checking for Node.js..."
if ! command -v node &> /dev/null; then
  echo "Node.js not found. Installing Node.js..."
  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo "Node.js is already installed."
fi

# Step 2: Check and Install Yarn
echo "Checking for Yarn..."
if ! command -v yarn &> /dev/null; then
  echo "Yarn not found. Installing Yarn..."
  npm install -g yarn
else
  echo "Yarn is already installed."
fi

# Step 3: Check and Install Unity Hub and Unity Editor (Free Personal License)
echo "Checking for Unity Editor..."
if ! command -v unity &> /dev/null; then
  echo "Unity Editor not found. Installing Unity Hub and Unity Editor..."
  wget -O unityhub.deb https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage
  chmod +x unityhub.deb
  sudo dpkg -i unityhub.deb
  echo "Please open Unity Hub to log in and download Unity Editor manually (Free Personal License)."
else
  echo "Unity Editor is already installed."
fi

# Step 4: Check and Install Hardhat
echo "Checking for Hardhat..."
if ! command -v npx hardhat &> /dev/null; then
  echo "Hardhat not found. Installing Hardhat..."
  npm install -g hardhat
else
  echo "Hardhat is already installed."
fi

# Step 5: Check and Install Docker and Docker Compose
echo "Checking for Docker..."
if ! command -v docker &> /dev/null; then
  echo "Docker not found. Installing Docker..."
  sudo apt-get install -y docker.io
else
  echo "Docker is already installed."
fi

echo "Checking for Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
  echo "Docker Compose not found. Installing Docker Compose..."
  sudo apt-get install -y docker-compose
else
  echo "Docker Compose is already installed."
fi

# Step 6: Install Frontend Dependencies
echo "Installing frontend dependencies..."
cd client || { echo "Error: client directory not found."; exit 1; }
yarn install
if [ $? -ne 0 ]; then
  echo "Error installing frontend dependencies."
  exit 1
fi

# Step 7: Install Backend Dependencies
echo "Installing backend dependencies..."
cd ../server || { echo "Error: server directory not found."; exit 1; }
yarn install
if [ $? -ne 0 ]; then
  echo "Error installing backend dependencies."
  exit 1
fi

# Step 8: Install Blockchain Dependencies
echo "Installing blockchain dependencies..."
cd ../blockchain || { echo "Error: blockchain directory not found."; exit 1; }
yarn install
if [ $? -ne 0 ]; then
  echo "Error installing blockchain dependencies."
  exit 1
fi

# Step 9: Build Unity Metaverse Project
echo "Building Unity metaverse project..."
cd ../metaverse || { echo "Error: metaverse directory not found."; exit 1; }
unity -batchmode -projectPath . -buildTarget WebGL -executeMethod BuildScript.Build
if [ $? -ne 0 ]; then
  echo "Error building Unity project."
  exit 1
fi

# Step 10: Deploy NFT Smart Contracts
echo "Deploying NFT smart contracts..."
cd ../blockchain || { echo "Error: blockchain directory not found for deployment."; exit 1; }
npx hardhat run scripts/deploy.js --network localhost
if [ $? -ne 0 ]; then
  echo "Error deploying smart contracts."
  exit 1
fi

# Step 11: Start Services Using Docker Compose
echo "Starting services with Docker Compose..."
cd ..
docker-compose up -d
if [ $? -ne 0 ]; then
  echo "Error starting Docker services."
  exit 1
fi

# Finalizing
echo "PiMetaConnect setup completed successfully! You are ready to start developing."
