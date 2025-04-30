#!/bin/bash

# Enable debug output for troubleshooting
set -x

# Ensure script is executed in Termux
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
pkg install -y git nodejs yarn python make clang cronie termux-services
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

# Step 4: Ensure Project Folder Structure Exists
echo "Ensuring project folder structure exists..."
mkdir -p client server blockchain

# Step 5: Install Frontend Dependencies
echo "Installing frontend dependencies..."
cd client
rm -f package-lock.json  # Remove npm lock file to avoid conflicts
yarn install || echo "Frontend dependencies installation failed. Skipping..."
cd ..

# Step 6: Install Backend Dependencies
echo "Installing backend dependencies..."
cd server
rm -f package-lock.json  # Remove npm lock file to avoid conflicts
yarn install || echo "Backend dependencies installation failed. Skipping..."
cd ..

# Step 7: Install Blockchain Dependencies
echo "Installing blockchain dependencies..."
cd blockchain
rm -f package-lock.json  # Remove npm lock file to avoid conflicts
yarn install || echo "Blockchain dependencies installation failed. Skipping..."
cd ..

# Step 8: Setting Up Python Environment
echo "Setting up Python environment..."
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi
source venv/bin/activate

# Ensure requirements.txt exists
if [ ! -f "server/requirements.txt" ]; then
  echo "requirements.txt not found. Creating a placeholder file..."
  mkdir -p server
  echo "requests==2.31.0" > server/requirements.txt  # Add basic dependency
fi

pip install --upgrade pip
pip install -r server/requirements.txt || echo "Python dependency installation failed. Skipping..."
deactivate

# Step 9: Create Daily Script if Missing
echo "Creating daily script if missing..."
if [ ! -f "/data/data/com.termux/files/home/daily_pimetaconnect.sh" ]; then
  cat <<EOL > /data/data/com.termux/files/home/daily_pimetaconnect.sh
#!/bin/bash

echo "Starting daily PiMetaConnect task..." >> /data/data/com.termux/files/home/pimetaconnect.log
cd /data/data/com.termux/files/home/PiMetaConnect || { echo "PiMetaConnect directory not found" >> /data/data/com.termux/files/home/pimetaconnect.log; exit 1; }
source venv/bin/activate
python3 server/daily_task.py >> /data/data/com.termux/files/home/pimetaconnect.log 2>&1
deactivate
echo "Daily PiMetaConnect task completed." >> /data/data/com.termux/files/home/pimetaconnect.log
EOL
  chmod +x /data/data/com.termux/files/home/daily_pimetaconnect.sh
fi

# Step 10: Create Placeholder Daily Task Script
echo "Creating placeholder daily task script..."
if [ ! -f "server/daily_task.py" ]; then
  mkdir -p server
  cat <<EOL > server/daily_task.py
#!/usr/bin/env python3

import time

print("Running daily PiMetaConnect task...")
# Add your Pi Network interaction code here
# For example: API requests, mining operations, etc.
time.sleep(2)  # Simulate a task that takes some time
print("Daily task completed successfully.")
EOL
  chmod +x server/daily_task.py
fi

# Step 11: Enable Cron Service
echo "Enabling cron service..."
termux-services restart
if [ $? -ne 0 ]; then
  echo "Failed to enable cron service."
  exit 1
fi

# Step 12: Add Daily Script to Cron
echo "Adding daily script to cron for daily execution..."
CRON_JOB="0 8 * * * /data/data/com.termux/files/usr/bin/bash /data/data/com.termux/files/home/daily_pimetaconnect.sh"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
if [ $? -ne 0 ]; then
  echo "Failed to add daily script to cron."
  exit 1
fi

# Step 13: Restart Cron Service
echo "Restarting cron service..."
termux-services restart
if [ $? -ne 0 ]; then
  echo "Failed to restart cron service."
  exit 1
fi

echo "PiMetaConnect setup and scheduling completed successfully!"
