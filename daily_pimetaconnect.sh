#!/bin/bash

# Log the start of the task
echo "Starting daily PiMetaConnect task..." >> /data/data/com.termux/files/home/pimetaconnect.log

# Navigate to the project directory
cd /data/data/com.termux/files/home/PiMetaConnect || { echo "PiMetaConnect directory not found"; exit 1; }

# Ensure the daily_task.py file exists
if [ ! -f "server/daily_task.py" ]; then
  echo "daily_task.py not found. Creating the file..."
  mkdir -p server
  cat <<EOL > server/daily_task.py
import requests

# Log the start of the task
print("Running daily PiMetaConnect task...")

# Pi Network API Key
PI_API_KEY = "kcjvvsyns799iypcrhjvy77que5wenovq3bofnwpnzrz6onyjds7i22ouezsneol"

# Example API request to Pi Network
url = "https://api.minepi.com/v2/daily_task"
headers = {
    "Authorization": f"Bearer {PI_API_KEY}",
    "Content-Type": "application/json",
}
data = {
    "task": "Daily Mining",
    "details": "Performing daily mining operation on Pi Network",
}

try:
    response = requests.post(url, headers=headers, json=data)
    response.raise_for_status()
    print(f"Task completed successfully: {response.json()}")
except requests.exceptions.RequestException as e:
    print(f"Error during task execution: {e}")
EOL
fi

# Activate the Python environment
if [ -d "venv" ]; then
  source venv/bin/activate
else
  echo "Virtual environment not found. Please run the setup script first."
  exit 1
fi

# Run the daily task script
python3 server/daily_task.py >> /data/data/com.termux/files/home/pimetaconnect.log 2>&1

# Deactivate the Python environment
deactivate

# Log the completion of the task
echo "Daily PiMetaConnect task completed." >> /data/data/com.termux/files/home/pimetaconnect.log
