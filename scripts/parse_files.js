const fs = require('fs');
const path = require('path');

// Retrieve secrets from environment variables
const { SECRET_KEY } = process.env;

if (!SECRET_KEY) {
  console.error("Error: SECRET_KEY is not set. Please set it as an environment variable or secret.");
  process.exit(1);
}

console.log("SECRET_KEY retrieved successfully.");

// Example: Files to parse
const filesToParse = ['public/terms.html', 'docs/docs_terms-of-service.md'];

filesToParse.forEach((file) => {
  const filePath = path.join(__dirname, '..', file);
  if (fs.existsSync(filePath)) {
    const content = fs.readFileSync(filePath, 'utf-8');
    console.log(`Content of ${file}:\n`);
    console.log(content);
  } else {
    console.error(`File not found: ${file}`);
  }
});
``
