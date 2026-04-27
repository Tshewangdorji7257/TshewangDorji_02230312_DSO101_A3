import express from "express";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

// Cache buster: 2026-04-27-0900
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = express();
const PORT = process.env.PORT || 3000;
const API_URL = process.env.VITE_API_URL || "https://todo-backend-test-0srz.onrender.com";

console.log("================================");
console.log("Starting Frontend Server");
console.log("Port:", PORT);
console.log("API URL:", API_URL);
console.log("================================");

// Middleware to inject API URL into index.html
app.use((req, res, next) => {
  if (req.url === "/" || req.url === "/index.html") {
    const indexPath = path.join(__dirname, "dist", "index.html");
    
    fs.readFile(indexPath, "utf8", (err, data) => {
      if (err) {
        console.error("Error reading index.html:", err);
        return res.status(500).send("Error loading app");
      }

      const configScript = `<script>
        window.__APP_CONFIG__ = window.__APP_CONFIG__ || {
          API_URL: "${API_URL}"
        };
      </script>`;

      const modifiedHtml = data.replace("</head>", `${configScript}</head>`);
      
      res.setHeader("Content-Type", "text/html; charset=utf-8");
      res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
      res.send(modifiedHtml);
    });
  } else {
    next();
  }
});

// Serve static files with proper cache headers
app.use(express.static(path.join(__dirname, "dist"), {
  setHeaders: (res, filePath) => {
    if (filePath.endsWith(".html")) {
      res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    }
  }
}));

// SPA fallback
app.get("*", (req, res) => {
  const indexPath = path.join(__dirname, "dist", "index.html");
  
  fs.readFile(indexPath, "utf8", (err, data) => {
    if (err) {
      console.error("Error reading index.html for fallback:", err);
      return res.status(500).send("Error loading app");
    }

    const configScript = `<script>
      window.__APP_CONFIG__ = window.__APP_CONFIG__ || {
        API_URL: "${API_URL}"
      };
    </script>`;

    const modifiedHtml = data.replace("</head>", `${configScript}</head>`);
    
    res.setHeader("Content-Type", "text/html; charset=utf-8");
    res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    res.send(modifiedHtml);
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`✓ Server running on http://0.0.0.0:${PORT}`);
  console.log("✓ API URL injected:", API_URL);
});
