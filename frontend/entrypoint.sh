#!/bin/sh

# Generate config.js with environment variables
cat > dist/config.js << EOF
window.__APP_CONFIG__ = window.__APP_CONFIG__ || {
  API_URL: "${VITE_API_URL:-https://be-todo.onrender.com}"
};
EOF

echo "✓ config.js generated with API_URL: ${VITE_API_URL:-https://be-todo.onrender.com}"

# Start the server
exec serve -s dist -l ${PORT:-3000}
