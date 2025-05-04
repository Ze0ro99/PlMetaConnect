#!/bin/bash

# Smart Repository Manager for PiMetaConnect
# Author: Ze0ro99
# Email: kamelkadah910@gmail.com

# Exit on any error
set -e

# Constants
REPO_URL="https://github.com/Ze0ro99/PiMetaConnect.git"
PI_RELATED_REPOS=(
  "https://github.com/KOSASIH/pi-nexus-autonomous-banking-network"
  "https://github.com/KOSASIH/eulers-shield"
  "https://github.com/KOSASIH/Pi-CryptoConnect"
  "https://github.com/KOSASIH/PiWallet-Pro"
  "https://github.com/KOSASIH/Stellar-Pi-Nexus-SPN"
)
GIT_USERNAME="Ze0ro99"
GIT_EMAIL="kamelkadah910@gmail.com"
APPLICATION_IMAGE_URL="https://path/to/your/image.png"  # Update with actual image URL
BRANCH_NAME="main"

# Ensure Git is configured
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

# Clone or pull the repository
if [ ! -d "PiMetaConnect" ]; then
  echo "Cloning repository..."
  git clone "$REPO_URL"
else
  echo "Repository already exists. Pulling latest changes..."
  cd "PiMetaConnect"
  git pull origin "$BRANCH_NAME"
  cd ..
fi

cd "PiMetaConnect"

# Function to create a missing file
create_file() {
  local file_name=$1
  local content=$2

  if [ ! -f "$file_name" ]; then
    echo "Creating missing file: $file_name"
    echo -e "$content" > "$file_name"
  else
    echo "File $file_name already exists. Skipping creation."
  fi
}

# Check for required files and create if missing
echo "Checking for required files..."
create_file "README.md" "# PiMetaConnect\n\n![Application Image](${APPLICATION_IMAGE_URL})\n\nContact: ${GIT_EMAIL}"
create_file "LICENSE" "MIT License\n\nCopyright (c) $(date +%Y) ${GIT_USERNAME}"
create_file "manifest.json" "{\n  \"name\": \"PiMetaConnect\",\n  \"email\": \"${GIT_EMAIL}\",\n  \"description\": \"A vibrant platform blending social media, metaverse, and NFTs for the Pi Network ecosystem.\"\n}"

# Replace placeholders or usernames with the user's email
echo "Replacing placeholders with email..."
grep -rl "username" . | xargs sed -i "s/username/${GIT_EMAIL}/g"

# Import necessary information from Pi-related repositories
echo "Importing information from Pi Network repositories..."
for repo in "${PI_RELATED_REPOS[@]}"; do
  echo "Fetching details from $repo..."
  temp_dir=$(mktemp -d)
  git clone --depth=1 "$repo" "$temp_dir"
  cp -r "$temp_dir"/* ./
  rm -rf "$temp_dir"
done

# Add, commit, and push changes to GitHub
echo "Committing and pushing changes..."
git add .
git commit -m "Automated updates and integration for Pi Developers Portal"
git push origin "$BRANCH_NAME"

echo "Script executed successfully!"