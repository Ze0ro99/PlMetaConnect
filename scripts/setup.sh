#!/bin/bash
echo "Starting PiMetaConnect setup..."

# التحقق من تثبيت Python وPillow
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

# توليد أيقونات التطبيق
echo "Generating app icons..."
cd scripts
python3 generate_app_icons.py
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to generate app icons."
    exit 1
fi
cd ..

# تثبيت تبعيات الـ Frontend
echo "Installing frontend dependencies..."
cd client
yarn install
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install frontend dependencies."
    exit 1
fi

# تثبيت تبعيات الـ Backend
echo "Installing backend dependencies..."
cd ../server
yarn install
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install backend dependencies."
    exit 1
fi

# تثبيت تبعيات الـ Blockchain
echo "Installing blockchain dependencies..."
cd ../blockchain
yarn install
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install blockchain dependencies."
    exit 1
fi

# بناء مشروع الميتافيرس في Unity
echo "Building Unity metaverse project..."
cd ../metaverse
unity -batchmode -projectPath . -buildTarget WebGL -executeMethod BuildScript.Build
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to build Unity project."
    exit 1
fi

# نشر العقود الذكية لـ NFT
echo "Deploying NFT smart contracts..."
cd ../blockchain
npx hardhat run scripts/deploy.js --network localhost
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to deploy smart contracts."
    exit 1
fi

# تشغيل الخدمات باستخدام Docker Compose
echo "Starting services with Docker Compose..."
cd ..
docker-compose up -d
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to start Docker services."
    exit 1
fi

echo "PiMetaConnect setup and execution completed successfully!"
