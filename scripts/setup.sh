#!/bin/bash
echo "Starting PiMetaConnect setup..."

# Check for Python and Pillow
echo "Checking Python and Pillow..."
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python3 is not installed. Please install it."
    exit 1
fi
if ! python3 -c "import PIL" &> /dev/null; then
    echo "Installing Pillow..."
    pip install Pillow
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install Pillow."
        exit 1
    fi
fi

# Generate app icons
echo "Generating app icons..."
cd scripts
python3 generate_app_icons.py
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to generate app icons."
    exit 1
fi
cd ..

# Install frontend dependencies
echo "Installing frontend dependencies..."
cd client
yarn install
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install frontend dependencies."
    exit 1
fi

# Install backend dependencies
echo "Installing backend dependencies..."
cd ../server
yarn install
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install backend dependencies."
    exit 1
fi

# Install blockchain dependencies
echo "Installing blockchain dependencies..."
cd ../blockchain
yarn install
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install blockchain dependencies."
    exit 1
fi

# Build Unity metaverse project
echo "Building Unity metaverse project..."
cd ../metaverse
unity -batchmode -projectPath . -buildTarget WebGL -executeMethod BuildScript.Build
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to build Unity project."
    exit 1
fi

# Deploy NFT smart contracts
echo "Deploying NFT smart contracts..."
cd ../blockchain
npx hardhat run scripts/deploy.js --network localhost
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to deploy smart contracts."
    exit 1
fi

# Start services with Docker Compose
echo "Starting services with Docker Compose..."
cd ..
docker-compose up -d
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to start Docker services."
    exit 1
fi

echo "PiMetaConnect setup and execution completed successfully!"
