#!/bin/bash

# Check if required secrets are available as environment variables
if [ -z "$VERCEL_TOKEN" ]; then
  echo "Error: VERCEL_TOKEN is not set. Please set it as an environment variable or secret."
  exit 1
fi

# Install Node.js (version 18)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Vercel CLI
npm install -g vercel

# Check installations
node -v
npm -v
vercel --version

echo "Setup complete. You can now run 'vercel' to deploy your project."
