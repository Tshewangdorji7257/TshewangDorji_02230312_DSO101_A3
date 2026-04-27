#!/bin/sh

# Use environment variable if set, otherwise use the correct default
API_URL="${VITE_API_URL:-https://todo-backend-test-0srz.onrender.com}"

echo "Starting frontend with API_URL: ${API_URL}"
echo "Current directory: $(pwd)"
echo "Files in dist/:"
ls -la dist/ | head -20

# Generate config.js with environment variables  
cat > dist/config.js << EOF
window.__APP_CONFIG__ = window.__APP_CONFIG__ || {
  API_URL: "${API_URL}"
};
EOF

echo "✓ config.js generated:"
cat dist/config.js

# Verify it was created
if [ -f dist/config.js ]; then
  echo "✓ config.js file exists and is readable"
else
  echo "✗ ERROR: config.js was not created!"
fi

# Start the server
echo "Starting serve on port ${PORT:-3000}..."
exec serve -s dist -l ${PORT:-3000} --no-clipboard
