#!/bin/bash
set -e

# === MetaCheck Script for PiMetaConnect Repository ===
# This script checks for essential files, sets up a basic project structure,
# downloads a preview image, generates a README, imports Pi Network info,
# lists example public repos, installs dependencies, and provides status info.

# --------- 1. Package.json Creation ---------
if [ ! -f package.json ]; then
cat > package.json <<EOF
{
  "name": "PiMetaConnect",
  "version": "1.0.0",
  "description": "PiMetaConnect: A vibrant platform blending social media, metaverse, and NFTs to empower users and creators in the Pi Network ecosystem with Pi-powered transactions.",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "author": "Ze0ro99",
  "license": "MIT",
  "email": "kamelkadah910@gmail.com"
}
EOF
fi

# --------- 2. index.js Creation ---------
if [ ! -f index.js ]; then
  echo "console.log('Welcome to PiMetaConnect!');" > index.js
fi

# --------- 3. manifest.json Creation ---------
if [ ! -f manifest.json ]; then
cat > manifest.json <<EOF
{
  "appName": "PiMetaConnect",
  "apiKey": "",
  "version": "1.0.0",
  "developer": "Ze0ro99",
  "contact": "kamelkadah910@gmail.com"
}
EOF
fi

# --------- 4. Download App Preview Image ---------
README_IMAGE_NAME="app_preview.png"
README_IMAGE_URL="https://raw.githubusercontent.com/Ze0ro99/PiMetaConnect/main/app_preview.png"
if [ ! -f "$README_IMAGE_NAME" ]; then
  wget -q -O "$README_IMAGE_NAME" "$README_IMAGE_URL" || \
  wget -q -O "$README_IMAGE_NAME" "https://via.placeholder.com/800x400.png?text=PiMetaConnect+Preview"
fi

# --------- 5. README.md Generation ---------
cat > README.md <<EOF
# PiMetaConnect

![App Preview]($README_IMAGE_NAME)

PiMetaConnect is a vibrant platform blending social media, metaverse, and NFTs to empower users and creators in the Pi Network ecosystem with Pi-powered transactions.

**Developed by [Ze0ro99](mailto:kamelkadah910@gmail.com)**

## Basic Information
- Developer email: [kamelkadah910@gmail.com](mailto:kamelkadah910@gmail.com)
- Compatible with Pi Network tools and within GitHub free usage and Pi Network policies.

## App Image
![App Preview]($README_IMAGE_NAME)

## Pi Network Integration
- manifest.json is included with Pi Network developer info.
- Data from some Pi Network repos and active developers:
EOF

# --------- 6. Add Pi Network Repos Info ---------
for repo in pi-apps pios; do
  echo -e "\n### pi-apps/$repo" >> README.md
  curl -sL "https://raw.githubusercontent.com/pi-apps/$repo/main/README.md" | head -20 >> README.md || echo "*Could not import $repo*" >> README.md
done

# --------- 7. List Example Public Repos ---------
echo -e "\n### KOSASIH's Public Repos" >> README.md
curl -s "https://api.github.com/users/KOSASIH/repos?per_page=2" | jq -r '.[] | "- [\(.name)](\(.html_url))"' >> README.md

# --------- 8. Install Dependencies ---------
echo -e "\n=== Installing npm dependencies... ==="
npm install --legacy-peer-deps || npm install --force

# --------- 9. Run the Application ---------
echo -e "\n=== Running the application... ==="
npm start

# --------- 10. Repository File Status ---------
echo -e "\n=== Repository file status summary ==="
ls -lh package.json index.js manifest.json README.md "$README_IMAGE_NAME"

echo -e "\n=== Git status ==="
git status

echo -e "\n=== All checks and setup are complete! ==="