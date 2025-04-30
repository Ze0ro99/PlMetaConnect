#!/bin/bash

echo "Starting daily PiMetaConnect task..." >> /data/data/com.termux/files/home/pimetaconnect.log

# Navigate to the project directory
cd /data/data/com.termux/files/home/PiMetaConnect

# Activate the Python environment
source venv/bin/activate

# Run the daily script
python3 server/daily_task.py >> /data/data/com.termux/files/home/pimetaconnect.log 2>&1

# Deactivate the Python environment
deactivate

echo "Daily PiMetaConnect task completed." >> /data/data/com.termux/files/home/pimetaconnect.log
