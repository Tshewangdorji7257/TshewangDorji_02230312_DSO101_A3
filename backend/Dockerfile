FROM node:20-alpine

WORKDIR /app

# Copy package files from backend directory
COPY ./backend/package*.json ./

# Install dependencies
RUN npm install

# Copy application source code
COPY ./backend/src ./src

# Create data directory for database
RUN mkdir -p /app/data /tmp && chmod 777 /app/data /tmp

ENV PORT=5000
ENV DB_PATH=/app/data/todos.db
ENV NODE_ENV=production

EXPOSE 5000

CMD ["node", "src/server.js"]
