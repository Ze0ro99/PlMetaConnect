#!/bin/bash

# Exit on error
set -e

# Define project root directory
PROJECT_DIR="."

# List of unnecessary files to delete
UNNECESSARY_FILES=(
  ".DS_Store"         # MacOS temporary files
  "Thumbs.db"         # Windows temporary files
  "*.log"             # Log files
  "*.tmp"             # Temporary files
  "*.bak"             # Backup files
  "node_modules"      # Optional: Uncomment to remove node_modules
)

# List of unnecessary directories to delete
UNNECESSARY_DIRS=(
  "__pycache__"       # Python cache
  ".idea"             # IDE-specific settings (e.g., IntelliJ)
  ".vscode"           # VS Code-specific settings
  "dist"              # Build artifacts
  "build"             # Build artifacts
  "coverage"          # Test coverage reports
)

# Function to delete unnecessary files
cleanup_files() {
  echo "Cleaning up unnecessary files..."
  for pattern in "${UNNECESSARY_FILES[@]}"; do
    find "$PROJECT_DIR" -type f -name "$pattern" -exec rm -f {} \;
  done
  echo "Unnecessary files removed."
}

# Function to delete unnecessary directories
cleanup_dirs() {
  echo "Cleaning up unnecessary directories..."
  for dir in "${UNNECESSARY_DIRS[@]}"; do
    find "$PROJECT_DIR" -type d -name "$dir" -exec rm -rf {} \;
  done
  echo "Unnecessary directories removed."
}

# Function to remove empty directories
remove_empty_dirs() {
  echo "Removing empty directories..."
  find "$PROJECT_DIR" -type d -empty -delete
  echo "Empty directories removed."
}

# Function to list remaining files and directories
list_remaining() {
  echo "Remaining project structure:"
  tree "$PROJECT_DIR"
}

# Run cleanup functions
cleanup_files
cleanup_dirs
remove_empty_dirs
list_remaining

echo "Cleanup completed successfully!"
chmod +x cleanup-tremex.sh
