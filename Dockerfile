# Build stage
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
# Update npm and install dependencies
RUN npm install -g npm@latest && \
    npm ci --omit=dev

# Copy source code and build
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine
WORKDIR /app

# Install serve globally with updated npm
RUN npm install -g npm@latest && \
    npm install -g serve

# Copy built assets from build stage
COPY --from=build /app/dist /app

# Environment variables
ENV PORT=5001
ENV NODE_ENV=production

# Expose port
EXPOSE 5001

# Run the application
CMD ["serve", "-s", ".", "-l", "5001"]
