#!/bin/sh

# Use environment variable if set, otherwise use the correct default
API_URL="${VITE_API_URL:-https://todo-backend-test-0srz.onrender.com}"

# Generate config.js with environment variables
cat > dist/config.js << EOF
window.__APP_CONFIG__ = window.__APP_CONFIG__ || {
  API_URL: "${API_URL}"
};
EOF

echo "✓ config.js generated with API_URL: ${API_URL}"

# Start the server
exec serve -s dist -l ${PORT:-3000}
