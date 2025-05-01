#!/bin/bash

# Exit on error
set -e

# Define project structure
PROJECT_NAME="PiMetaConnect"
COMPONENTS_DIR="$PROJECT_NAME/src/components"
SERVICES_DIR="$PROJECT_NAME/src/services"
STYLES_DIR="$PROJECT_NAME/src/styles"
PUBLIC_DIR="$PROJECT_NAME/public"

# Create directories
echo "Creating project structure..."
mkdir -p "$COMPONENTS_DIR" "$SERVICES_DIR" "$STYLES_DIR" "$PUBLIC_DIR"

# Create package.json
cat <<EOL > "$PROJECT_NAME/package.json"
{
  "name": "pimetaconnect",
  "version": "1.0.0",
  "description": "A social platform integrated with Pi Network.",
  "main": "src/index.js",
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1"
  },
  "devDependencies": {},
  "keywords": [],
  "author": "Ze0ro99",
  "license": "MIT"
}
EOL
echo "Created package.json."

# Create README.md
cat <<EOL > "$PROJECT_NAME/README.md"
# PiMetaConnect
A social platform integrated with the Pi Network.

## Features
- **Login/Logout**: Authenticate users using a mock Pi SDK.
- **Wallet Component**: Display user wallet balance.
- **Dark Mode Support**: Includes dark mode styling.

## Structure
\`\`\`
PiMetaConnect/
├── src/
│   ├── components/
│   │   ├── LoginComponent.js
│   │   ├── WalletComponent.js
│   ├── services/
│   │   ├── mock-pi-sdk.js
│   ├── styles/
│   │   ├── dark-mode.css
│   ├── App.js
│   ├── index.js
├── public/
├── README.md
├── package.json
\`\`\`

## Installation
1. Clone the repository:
   \`git clone <repo-url>\`
2. Navigate to the project directory:
   \`cd PiMetaConnect\`
3. Install dependencies:
   \`npm install\`
4. Start the development server:
   \`npm start\`
EOL
echo "Created README.md."

# Create App.js
cat <<EOL > "$PROJECT_NAME/src/App.js"
import React, { useState } from "react";
import LoginComponent from "./components/LoginComponent";
import WalletComponent from "./components/WalletComponent";
import "./styles/dark-mode.css";

const App = () => {
  const [user, setUser] = useState(null);

  return (
    <div>
      <h1>PiMetaConnect</h1>
      <LoginComponent setUser={setUser} />
      <WalletComponent user={user} />
    </div>
  );
};

export default App;
EOL
echo "Created App.js."

# Create index.js
cat <<EOL > "$PROJECT_NAME/src/index.js"
import React from "react";
import ReactDOM from "react-dom";
import App from "./App";

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById("root")
);
EOL
echo "Created index.js."

# Create LoginComponent.js
cat <<EOL > "$COMPONENTS_DIR/LoginComponent.js"
import React, { useState } from "react";
import mockPiSDK from "../services/mock-pi-sdk";

const LoginComponent = ({ setUser }) => {
  const [error, setError] = useState("");

  const handleLogin = async () => {
    try {
      const user = await mockPiSDK.login();
      setUser(user);
      setError("");
    } catch (err) {
      setError("Login failed. Please try again.");
    }
  };

  const handleLogout = () => {
    setUser(null);
  };

  return (
    <div className="login-container">
      <h2>Login</h2>
      <button onClick={handleLogin}>Login</button>
      <button onClick={handleLogout}>Logout</button>
      {error && <p className="error">{error}</p>}
    </div>
  );
};

export default LoginComponent;
EOL
echo "Created LoginComponent.js."

# Create WalletComponent.js
cat <<EOL > "$COMPONENTS_DIR/WalletComponent.js"
import React, { useState } from "react";
import mockPiSDK from "../services/mock-pi-sdk";

const WalletComponent = ({ user }) => {
  const [balance, setBalance] = useState(null);
  const [error, setError] = useState("");

  const fetchWalletBalance = async () => {
    if (!user) {
      setError("User not logged in.");
      return;
    }

    try {
      const response = await mockPiSDK.getWalletBalance(user.userId);
      if (response.success) {
        setBalance(response.balance);
        setError("");
      } else {
        setError("Failed to fetch wallet balance.");
      }
    } catch (err) {
      setError("An error occurred while fetching wallet balance.");
    }
  };

  return (
    <div className="wallet-container">
      <h2>Wallet</h2>
      {user ? (
        <div>
          <button onClick={fetchWalletBalance}>Show Wallet Balance</button>
          {balance !== null && <p>Balance: {balance} Pi</p>}
        </div>
      ) : (
        <p>Please log in to view wallet balance.</p>
      )}
      {error && <p className="error">{error}</p>}
    </div>
  );
};

export default WalletComponent;
EOL
echo "Created WalletComponent.js."

# Create mock-pi-sdk.js
cat <<EOL > "$SERVICES_DIR/mock-pi-sdk.js"
const mockPiSDK = {
  login: async () => {
    return new Promise((resolve) => {
      setTimeout(() => resolve({ userId: "12345", username: "PiUser" }), 1000);
    });
  },
  getWalletBalance: async (userId) => {
    return new Promise((resolve) => {
      setTimeout(() => resolve({ success: true, balance: 100 }), 1000);
    });
  },
};

export default mockPiSDK;
EOL
echo "Created mock-pi-sdk.js."

# Create dark-mode.css
cat <<EOL > "$STYLES_DIR/dark-mode.css"
body {
  background-color: #121212;
  color: #ffffff;
}

button {
  background-color: #1e88e5;
  color: #ffffff;
  padding: 10px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

button:hover {
  background-color: #1565c0;
}

.login-container, .wallet-container {
  margin: 20px auto;
  padding: 20px;
  background-color: #1e1e1e;
  border-radius: 10px;
  text-align: center;
}

.error {
  color: #f44336;
}
EOL
echo "Created dark-mode.css."

echo "Project setup complete. Navigate to $PROJECT_NAME and run 'npm install' to install dependencies."
