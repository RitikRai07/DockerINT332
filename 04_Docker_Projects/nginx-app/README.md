# Nginx Docker Project

## Overview

This is a custom Nginx web server running in Docker. It demonstrates containerization of a web server with security best practices.

## Project Structure

```
nginx-app/
├── Dockerfile           # Container definition
├── index.html          # Web content
├── default.conf        # Nginx configuration
└── README.md           # This file
```

## Features

✅ **Alpine Linux** - Lightweight base image  
✅ **Non-root user** - Security best practice  
✅ **Custom configuration** - Optimized Nginx settings  
✅ **Gzip compression** - Performance optimization  
✅ **Security headers** - XSS and clickjacking protection  
✅ **Caching** - Optimized static file serving  

## Build Instructions

### Method 1: Using Docker

```bash
# Navigate to project directory
cd nginx-app

# Build image
docker build -t custom-nginx:v1 .

# Run container
docker run -d -p 8080:80 --name nginx-server custom-nginx:v1

# View logs
docker logs nginx-server

# Access browser
http://localhost:8080
```

### Method 2: Build with Labels

```bash
docker build \
    --label version=1.0 \
    --label author="DevOps Team" \
    -t custom-nginx:v1 .
```

## Usage

### Run container

```bash
# Basic run
docker run -d -p 8080:80 custom-nginx:v1

# With name and additional options
docker run -d \
    --name nginx-web \
    -p 8080:80 \
    --memory 512m \
    --cpus 1 \
    --restart=unless-stopped \
    custom-nginx:v1
```

### Stop container

```bash
docker stop nginx-web
```

### Remove container

```bash
docker rm nginx-web
```

### View logs

```bash
docker logs nginx-web
docker logs -f nginx-web    # Follow logs
```

### Execute commands

```bash
# Enter container shell
docker exec -it nginx-web /bin/sh

# View Nginx configuration
docker exec nginx-web cat /etc/nginx/conf.d/default.conf

# Test Nginx configuration
docker exec nginx-web nginx -t
```

## Dockerfile Explanation

### Base Image
```dockerfile
FROM nginx:alpine
```
- Uses official Nginx image
- Alpine Linux keeps image small (~50MB vs 200MB+)

### Labels
```dockerfile
LABEL author="DevOps Team" \
      version="1.0" \
      description="Custom Nginx Web Server"
```
- Metadata for image identification

### Copy Configuration
```dockerfile
COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
```
- Custom Nginx configuration
- Custom HTML content

### Security - Non-root User
```dockerfile
RUN addgroup -g 1001 -S nginx && \
    adduser -S -D -H -u 1001 ...
USER nginx
```
- Creates dedicated nginx user
- Runs container as non-root (security best practice)

### Port Exposure
```dockerfile
EXPOSE 80
```
- Declares port 80 as service port

### Start Command
```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```
- Runs Nginx in foreground (required for Docker)

## Configuration Features

### Gzip Compression
```nginx
gzip on;
gzip_types text/plain text/css ...;
```
- Compresses responses for faster loading

### Security Headers
```nginx
add_header X-Frame-Options "SAMEORIGIN";
add_header X-Content-Type-Options "nosniff";
add_header X-XSS-Protection "1; mode=block";
```
- Protection against common web attacks

### Caching
```nginx
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 30d;
}
```
- Static files cached for 30 days

## Troubleshooting

### Container won't start

```bash
# Check logs
docker logs container_name

# Try running with different command
docker run -it custom-nginx:v1 /bin/sh

# Verify image
docker images | grep custom-nginx
```

### Port already in use

```bash
# Use different port
docker run -d -p 8081:80 custom-nginx:v1

# Find what's using port 8080
# (System specific command)
```

### Access denied

```bash
# Check file permissions
docker exec -it nginx-web ls -la /usr/share/nginx/html

# Fix permissions
docker exec nginx-web chown -R nginx:nginx /usr/share/nginx/html
```

## Customization

### Change port mapping

```bash
docker run -d -p 9000:80 custom-nginx:v1
# Access at http://localhost:9000
```

### Mount custom HTML

```bash
docker run -d \
    -p 8080:80 \
    -v $(pwd)/myhtml:/usr/share/nginx/html \
    custom-nginx:v1
```

### Add environment variables

```bash
docker run -d \
    -p 8080:80 \
    -e APP_NAME="My Web App" \
    custom-nginx:v1
```

## Performance Tips

✅ Use Alpine Linux for smaller images  
✅ Enable gzip compression  
✅ Use caching headers  
✅ Optimize images and CSS  
✅ Set resource limits  
✅ Use HTTP/2 protocol  

## Security Best Practices

✅ Run as non-root user  
✅ Use security headers  
✅ Keep base image updated  
✅ Remove unnecessary packages  
✅ Use read-only root filesystem  
✅ Regular security scanning  

## Deployment

### Push to Docker Hub

```bash
# Login
docker login

# Tag image
docker tag custom-nginx:v1 yourusername/custom-nginx:v1

# Push
docker push yourusername/custom-nginx:v1
```

### Docker Compose

```yaml
version: '3'
services:
  nginx:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    environment:
      APP_NAME: "Docker Lab"
    restart: unless-stopped
    mem_limit: 512m
```

## Learning Resources

- [Nginx Documentation](https://nginx.org/en/docs/)
- [Docker Official Nginx Image](https://hub.docker.com/_/nginx)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

