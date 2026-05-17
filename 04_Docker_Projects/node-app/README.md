# Node.js Docker Project

## Overview

This is a Docker Node.js application demonstrating containerization of a Node.js Express server. It includes REST API endpoints, health checks, and Docker best practices.

## Project Structure

```
node-app/
├── Dockerfile              # Container definition
├── package.json           # Dependencies
├── app.js                 # Application code
├── .dockerignore          # Files to exclude
└── README.md              # This file
```

## Features

✅ **Alpine Linux** - Lightweight base image  
✅ **Express.js** - Web framework  
✅ **Health Check** - Automated container health monitoring  
✅ **Non-root user** - Security best practice  
✅ **REST API** - Multiple endpoints  
✅ **Graceful Shutdown** - Proper signal handling  
✅ **Memory Monitoring** - Real-time stats  
✅ **Logging** - Detailed request logging  

## Build Instructions

### Method 1: Using Docker

```bash
# Navigate to project directory
cd node-app

# Build image
docker build -t node-demo:v1 .

# Run container
docker run -d -p 3000:3000 --name node-app node-demo:v1

# View logs
docker logs node-app

# Access browser
http://localhost:3000
```

### Method 2: Build with Custom Tag

```bash
docker build \
    -t myregistry/node-demo:v1 \
    --label version=1.0 \
    --label author="DevOps Team" \
    .
```

## Usage

### Run container

```bash
# Basic run
docker run -d -p 3000:3000 node-demo:v1

# With name and environment
docker run -d \
    --name nodeapp \
    -p 3000:3000 \
    -e NODE_ENV=production \
    node-demo:v1

# With resource limits
docker run -d \
    --name nodeapp \
    -p 3000:3000 \
    --memory 512m \
    --cpus 1 \
    node-demo:v1

# With logging
docker run -d \
    --name nodeapp \
    -p 3000:3000 \
    --log-driver json-file \
    --log-opt max-size=10m \
    --log-opt max-file=3 \
    node-demo:v1
```

### Container management

```bash
# Stop container
docker stop nodeapp

# Start stopped container
docker start nodeapp

# Remove container
docker rm nodeapp

# View logs
docker logs nodeapp
docker logs -f nodeapp        # Follow logs
docker logs --tail 50 nodeapp # Last 50 lines
```

### Execute commands

```bash
# Enter container shell
docker exec -it nodeapp /bin/sh

# Check node version
docker exec nodeapp node --version

# Check npm version
docker exec nodeapp npm --version

# List files
docker exec nodeapp ls -la
```

## API Endpoints

### 1. Home Endpoint

```bash
curl http://localhost:3000
```

Response:
```json
{
  "message": "🐳 Welcome to Docker DevOps Lab - Node.js App",
  "status": "running",
  "timestamp": "2024-01-15T10:30:45.123Z",
  "version": "1.0.0",
  "environment": "production"
}
```

### 2. Health Check

```bash
curl http://localhost:3000/health
```

Response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:45.123Z",
  "uptime": 234.567
}
```

### 3. Application Info

```bash
curl http://localhost:3000/api/info
```

Response:
```json
{
  "appName": "Docker Node.js Lab",
  "version": "1.0.0",
  "nodejs": "v14.21.0",
  "platform": "linux",
  "environment": "production",
  "port": 3000
}
```

### 4. Docker Info

```bash
curl http://localhost:3000/api/docker-info
```

Response:
```json
{
  "container": "Running in Docker",
  "image": "node:14-alpine",
  "features": ["Express.js Framework", "Alpine Linux", ...],
  "endpoints": [...]
}
```

### 5. Environment Variables

```bash
curl http://localhost:3000/api/env
```

Response:
```json
{
  "NODE_ENV": "production",
  "PORT": 3000,
  "APP_NAME": "Node Docker App"
}
```

### 6. Memory Usage

```bash
curl http://localhost:3000/api/memory
```

Response:
```json
{
  "rss": "45 MB",
  "heapTotal": "38 MB",
  "heapUsed": "22 MB",
  "external": "1 MB"
}
```

## Dockerfile Explanation

### Base Image
```dockerfile
FROM node:14-alpine
```
- Official Node.js image
- Alpine Linux keeps size small (~150MB)

### Working Directory
```dockerfile
WORKDIR /app
```
- Sets working directory for all commands

### Copy Dependencies
```dockerfile
COPY package*.json ./
```
- package.json and package-lock.json (if exists)

### Install Dependencies
```dockerfile
RUN npm install --production
```
- Installs only production dependencies
- Excludes devDependencies (smaller image)

### Copy Application
```dockerfile
COPY app.js .
```
- Copies application code

### Security - Non-root User
```dockerfile
RUN addgroup -g 1001 -S appuser
USER appuser
```
- Creates dedicated app user
- Runs container as non-root

### Health Check
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s ...
```
- Docker automatically monitors container health
- Restarts if unhealthy

## Environment Variables

```bash
# Set environment variables at runtime
docker run -e NODE_ENV=production \
           -e APP_NAME="My App" \
           -e PORT=3000 \
           node-demo:v1
```

Inside container, access via `process.env.VARIABLE_NAME`

## Volume Mounting

### Mount source code

```bash
# Development with live reload
docker run -it \
    -v $(pwd):/app \
    -w /app \
    -p 3000:3000 \
    node:14-alpine \
    npm run dev
```

### Mount logs directory

```bash
docker run -d \
    -p 3000:3000 \
    -v logs:/app/logs \
    node-demo:v1
```

## Networking

### Access between containers

```bash
# Create network
docker network create mynet

# Run database
docker run -d --name db --network mynet postgres

# Run app with network
docker run -d \
    --name app \
    --network mynet \
    -p 3000:3000 \
    -e DATABASE_URL=postgresql://db:5432/mydb \
    node-demo:v1
```

## Performance Tips

✅ Use Alpine Linux base  
✅ Install only production dependencies  
✅ Use .dockerignore to exclude files  
✅ Enable gzip compression  
✅ Use persistent volume for logs  
✅ Set resource limits  
✅ Use health checks  
✅ Implement proper logging  

## Security Best Practices

✅ Run as non-root user  
✅ Keep dependencies updated  
✅ Don't hardcode secrets  
✅ Use .dockerignore  
✅ Scan images for vulnerabilities  
✅ Use security headers  
✅ Implement rate limiting  
✅ Validate input  

## Troubleshooting

### Container won't start

```bash
# Check logs
docker logs nodeapp

# Check if port in use
docker ps -a

# Rebuild image
docker build -t node-demo:v1 .
```

### Port 3000 already in use

```bash
# Use different port
docker run -d -p 3001:3000 node-demo:v1

# Or find and stop existing container
docker ps
docker stop container_id
```

### Dependencies not installing

```bash
# Check package.json syntax
docker run -it node:14-alpine npm list

# Rebuild with verbose output
docker build --verbose -t node-demo:v1 .
```

### Container exits immediately

```bash
# Check application logs
docker logs nodeapp

# Try running interactively
docker run -it node-demo:v1 /bin/sh

# Run with npm start
docker run -it node:14-alpine npm start
```

## Deployment

### Push to Docker Hub

```bash
# Login
docker login

# Tag image
docker tag node-demo:v1 yourusername/node-demo:v1

# Push
docker push yourusername/node-demo:v1
```

### Docker Compose Example

```yaml
version: '3.8'
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      APP_NAME: "Docker Lab"
    restart: unless-stopped
    mem_limit: 512m
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 3s
      retries: 3
```

Run with Docker Compose:

```bash
docker-compose up -d
docker-compose logs -f
docker-compose stop
```

## Learning Resources

- [Node.js Documentation](https://nodejs.org/en/docs/)
- [Express.js Guide](https://expressjs.com/)
- [Docker Official Node Image](https://hub.docker.com/_/node)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

