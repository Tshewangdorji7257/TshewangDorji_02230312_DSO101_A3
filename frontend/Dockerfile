FROM node:20-alpine AS build

WORKDIR /app

# Add build argument to break cache on every deploy
ARG BUILD_TIME=unknown

# Copy package files from frontend directory
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy source code from frontend directory
COPY src ./src
COPY public ./public
COPY index.html ./
COPY vite.config.js ./

# Accept build argument for API URL with default fallback
ARG VITE_API_URL=https://dsoa3-backend-latest.onrender.com
ARG REACT_APP_API_URL=https://dsoa3-backend-latest.onrender.com
ENV VITE_API_URL=${VITE_API_URL}
ENV REACT_APP_API_URL=${REACT_APP_API_URL}

# Build the application
RUN npm run build


# Production stage
FROM node:20-alpine

WORKDIR /app

# Install serve to run the static site
RUN npm install -g serve

# Copy built application from build stage
COPY --from=build /app/dist ./dist

# Create runtime config with correct backend URL
RUN echo "window.__APP_CONFIG__ = { API_URL: 'https://dsoa3-backend-latest.onrender.com' };" > dist/config.js

ENV PORT=3000

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
