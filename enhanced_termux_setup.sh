#!/bin/bash
set -e

echo "Starting PiMetaConnect setup in Termux environment..."

# Ensure Termux environment
if [ "$(uname -o)" != "Android" ]; then
    echo "This script is designed to run in Termux on Android."
    exit 1
fi

# Update and install required packages
echo "Updating Termux packages..."
pkg update -y && pkg upgrade -y
pkg install -y git nodejs yarn python make clang

# Clone the repository
echo "Cloning repository..."
if [ ! -d "PiMetaConnect" ]; then
    git clone https://github.com/Ze0ro99/PiMetaConnect.git
fi

# Navigate and install dependencies
cd PiMetaConnect
for dir in client server blockchain; do
    if [ -d "$dir" ]; then
        echo "Installing dependencies for $dir..."
        cd "$dir"
        yarn install || npm install
        cd ..
    fi
done

echo "Termux setup complete!"