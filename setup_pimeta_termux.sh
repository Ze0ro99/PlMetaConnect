#!/bin/bash

# Ensure script is executed with Termux
if [ "$(uname -o)" != "Android" ]; then
  echo "This script is designed to run in Termux on Android."
  exit 1
fi

echo "Starting PiMetaConnect setup in Termux environment..."

# Step 1: Update and Upgrade Termux Packages
echo "Updating Termux packages..."
pkg update -y && pkg upgrade -y
if [ $? -ne 0 ]; then
  echo "Failed to update Termux packages."
  exit 1
fi

# Step 2: Install Required Packages
echo "Installing required packages..."
pkg install -y git nodejs yarn python make clang
if [ $? -ne 0 ]; then
  echo "Failed to install required packages."
  exit 1
fi

# Step 3: Clone PiMetaConnect Repository
echo "Cloning PiMetaConnect repository..."
if [ ! -d "PiMetaConnect" ]; then
  git clone https://github.com/Ze0ro99/PiMetaConnect.git
fi
if [ $? -ne 0 ]; then
  echo "Failed to clone PiMetaConnect repository."
  exit 1
fi

cd PiMetaConnect

# Step 4: Install Frontend Dependencies
echo "Installing frontend dependencies..."
cd client
yarn install
if [ $? -ne 0 ]; then
  echo "Failed to install frontend dependencies."
  exit 1
fi

# Step 5: Install Backend Dependencies
echo "Installing backend dependencies..."
cd ../server
yarn install
if [ $? -ne 0 ]; then
  echo "Failed to install backend dependencies."
  exit 1
fi

# Step 6: Install Blockchain Dependencies
echo "Installing blockchain dependencies..."
cd ../blockchain
yarn install
if [ $? -ne 0 ]; then
  echo "Failed to install blockchain dependencies."
  exit 1
fi

# Step 7: Setting Up Python Environment
echo "Setting up Python environment..."
cd ..
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi
source venv/bin/activate
pip install -r server/requirements.txt
if [ $? -ne 0 ]; then
  echo "Failed to set up Python environment."
  deactivate
  exit 1
fi
deactivate

# Step 8: Run Pi Sandbox (Placeholder)
echo "Running Pi Sandbox..."
# Placeholder for Pi Sandbox setup
# Add the sandbox setup logic here

# Step 9: Start Services Using Docker Compose (Optional)
echo "Skipping Docker services as Docker is not supported in Termux."

echo "PiMetaConnect setup completed successfully!"
