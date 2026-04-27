#!/bin/sh

# Use environment variable if set, otherwise use the correct default
API_URL="${VITE_API_URL:-https://todo-backend-test-0srz.onrender.com}"

echo "================================"
echo "Starting Frontend Server"
echo "Port: ${PORT:-3000}"
echo "API URL: ${API_URL}"
echo "================================"

# Inject API_URL into index.html before the main script
# Create a modified index.html with config injected
cat > dist/index-with-config.html << 'HTMLEOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>To-Do App</title>
  </head>
  <body>
    <div id="root"></div>
    <script>
      window.__APP_CONFIG__ = window.__APP_CONFIG__ || {
        API_URL: "REPLACE_API_URL_HERE"
      };
    </script>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
HTMLEOF

# Replace the placeholder with actual API_URL
sed -i "s|REPLACE_API_URL_HERE|${API_URL}|g" dist/index-with-config.html

# Backup original and replace
cp dist/index.html dist/index.html.bak
cp dist/index-with-config.html dist/index.html

echo "✓ index.html updated with API_URL: ${API_URL}"
echo "✓ Starting serve..."

# Start the server
exec serve -s dist -l ${PORT:-3000}
