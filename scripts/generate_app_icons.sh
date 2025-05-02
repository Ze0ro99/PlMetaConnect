#!/bin/bash
# Ensure Pillow is installed
pip install Pillow

# Run the Python script to generate icons (provided in your repo as newfile.py or similar)
python scripts/generate_app_icons.py

echo "App icons generated. Please upload the generated files (e.g., client/assets/icons/app_icon_512x512.png) when registering in the Pi Developer Portal."
