# PiMetaConnect Whitepaper: Project Structure and Development Steps
**Date**: April 24, 2025  
**Version**: 1.0  
**Repository**: [PiMetaConnect Repository](https://github.com/Ze0ro99/PiMetaConnect)  
**Maintainer**: Ze0ro99  
**Email**: [kamelkadah910@gmail.com]

---

## 1. Folder Structure and Files

```
PiMetaConnect/
├── /client/
│   ├── /src/
│   │   ├── /components/
│   │   │   ├── SocialFeed.js
│   │   │   ├── LiveStream.js
│   │   │   ├── NFTDisplay.js
│   │   ├── /screens/
│   │   │   ├── HomeScreen.js
│   │   │   ├── MetaverseScreen.js
│   │   │   ├── ProfileScreen.js
│   │   ├── /assets/
│   │   ├── /navigation/
│   │   │   ├── AppNavigator.js
│   │   ├── /styles/
│   │   │   ├── theme.js
│   │   ├── App.js
│   ├── package.json
│   ├── .env
│
├── /server/
│   ├── /src/
│   │   ├── /controllers/
│   │   │   ├── userController.js
│   │   │   ├── contentController.js
│   │   │   ├── nftController.js
│   │   ├── /models/
│   │   │   ├── User.js
│   │   │   ├── Content.js
│   │   │   ├── NFT.js
│   │   ├── /routes/
│   │   │   ├── userRoutes.js
│   │   │   ├── contentRoutes.js
│   │   │   ├── nftRoutes.js
│   │   ├── /middleware/
│   │   │   ├── auth.js
│   │   ├── /config/
│   │   │   ├── db.js
│   │   ├── server.js
│   ├── package.json
│   ├── .env
│
├── /metaverse/
│   ├── /Assets/
│   │   ├── /Scenes/
│   │   │   ├── VirtualMall.unity
│   │   │   ├── EventSpace.unity
│   │   ├── /Scripts/
│   │   │   ├── ProductDisplay.cs
│   │   │   ├── UserAvatar.cs
│   ├── ProjectSettings/
│
├── /blockchain/
│   ├── /contracts/
│   │   ├── PiMetaNFT.sol
│   ├── /scripts/
│   │   ├── deploy.js
│   ├── hardhat.config.js
│   ├── package.json
│
├── /scripts/
│   ├── setup.sh
│
├── /docs/
│   ├── README.md
│   ├── WHITEPAPER.md
│
├── .gitignore
├── docker-compose.yml
├── LICENSE
```

---

## 2. Development Steps

### Setup Repository

1. Create a new Git repository on GitHub.
2. Clone the repository: `git clone https://github.com/Ze0ro99/PiMetaConnect.git`.
3. Create the folder structure as listed above.
4. Initialize Git: `git init`.

---

### Install Prerequisites

1. Install Node.js: `npm install -g npm`.
2. Install Yarn: `npm install -g yarn`.
3. Install Unity Hub and Unity Editor.
4. Install Hardhat: `npm install -g hardhat`.
5. Install Docker and Docker Compose.

---

### Create Files

1. Create all files listed in the folder structure.
2. Add `.gitignore` with:
   ```
   node_modules/
   build/
   dist/
   .env
   .DS_Store
   Thumbs.db
   *.log
   .env.local
   .env.development
   temp/
   tmp/
   *.bak
   *.swp
   package-lock.json
   ```
3. Add LICENSE (e.g., MIT License).
4. Add `docker-compose.yml` with the configuration provided in the document.

---

### Automation Script
````bash name=scripts/setup.sh
#!/bin/bash
echo "Starting PiMetaConnect setup..."

# Install Frontend Dependencies
echo "Installing frontend dependencies..."
cd client
yarn install
if [ $? -ne 0 ]; then
  echo "Error installing frontend dependencies."
  exit 1
fi

# Install Backend Dependencies
echo "Installing backend dependencies..."
cd ../server
yarn install
if [ $? -ne 0 ]; then
  echo "Error installing backend dependencies."
  exit 1
fi

# Install Blockchain Dependencies
echo "Installing blockchain dependencies..."
cd ../blockchain
yarn install
if [ $? -ne 0 ]; then
  echo "Error installing blockchain dependencies."
  exit 1
fi

# Build Unity Metaverse Project
echo "Building Unity metaverse project..."
cd ../metaverse
unity -batchmode -projectPath . -buildTarget WebGL -executeMethod BuildScript.Build
if [ $? -ne 0 ]; then
  echo "Error building Unity project."
  exit 1
fi

# Deploy NFT Smart Contracts
echo "Deploying NFT smart contracts..."
cd ../blockchain
npx hardhat run scripts/deploy.js --network localhost
if [ $? -ne 0 ]; then
  echo "Error deploying smart contracts."
  exit 1
fi

# Start Services Using Docker Compose
echo "Starting services with Docker Compose..."
cd ..
docker-compose up -d
if [ $? -ne 0 ]; then
  echo "Error starting Docker services."
  exit 1
fi

echo "PiMetaConnect setup and execution completed successfully!"
