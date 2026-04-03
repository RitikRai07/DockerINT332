# Docker Images - In Detail

## What is a Docker Image?

A Docker image is a lightweight, standalone, executable package that contains:
- Application code
- Runtime environment
- System tools and libraries
- Environment variables
- Default commands

---

## Creating Docker Images

### Method 1: Using Dockerfile

A Dockerfile is a text file with instructions to build an image.

#### Basic Dockerfile Example

```dockerfile
# Base image
FROM ubuntu:20.04

# Metadata
LABEL author="DevOps Team"
LABEL version="1.0"

# Install packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    nano

# Set working directory
WORKDIR /app

# Copy files
COPY . /app

# Expose port
EXPOSE 8080

# Set environment variable
ENV APP_NAME=myapp

# Run command when container starts
CMD ["bash"]
```

### Build image from Dockerfile

```bash
# Build with tag
docker build -t myimage:1.0 .

# Build with custom Dockerfile
docker build -f Dockerfile -t myimage:v1 .

# Build with build arguments
docker build --build-arg VERSION=1.0 -t myimage:1.0 .

# Build without cache
docker build --no-cache -t myimage:1.0 .
```

---

## Dockerfile Instructions

| Instruction | Purpose | Example |
|-------------|---------|---------|
| `FROM` | Base image | `FROM ubuntu:20.04` |
| `RUN` | Execute command | `RUN apt-get install nginx` |
| `COPY` | Copy files from host | `COPY app.js /app/` |
| `ADD` | Copy and extract | `ADD archive.tar /app/` |
| `WORKDIR` | Set working directory | `WORKDIR /app` |
| `EXPOSE` | Document port | `EXPOSE 8080` |
| `ENV` | Set environment variable | `ENV NODE_ENV=production` |
| `CMD` | Default command | `CMD ["node", "app.js"]` |
| `ENTRYPOINT` | Executable | `ENTRYPOINT ["python"]` |
| `USER` | Run as user | `USER appuser` |
| `VOLUME` | Mount point | `VOLUME /app/data` |

---

## Image Layers

Docker images are built in layers:

```dockerfile
FROM ubuntu:20.04           # Layer 1
RUN apt-get update          # Layer 2
RUN apt-get install nginx   # Layer 3
COPY app.conf /etc/nginx/   # Layer 4
CMD ["nginx", "-g", "daemon off;"] # Layer 5
```

Each layer is cached. If a layer doesn't change, Docker reuses it.

---

## Tagging Images

### Tag an image
```bash
docker tag old_name:old_tag new_name:new_tag

# Example
docker tag myimage:1.0 myimage:latest
docker tag myimage:1.0 myregistry.com/myimage:1.0
```

### Image naming convention
```
[REGISTRY/]NAME[:TAG]

Examples:
ubuntu
nginx:1.19
docker.io/ubuntu:20.04
myregistry.com/myapp:1.0
```

---

## Viewing Image Information

### List all images
```bash
docker images
```

### View image details
```bash
docker inspect image_name
```

### View image history (layers)
```bash
docker history image_name
```

### Search for images
```bash
docker search nginx
```

---

## Pushing Images to Registry

### Login to Docker Hub
```bash
docker login
docker login registry.example.com
```

### Push image to registry
```bash
docker push myimage:1.0
docker push myregistry.com/myimage:1.0
```

### Logout
```bash
docker logout
```

---

## Best Practices for Dockerfile

✅ **DO:**
- Use specific base image tags (avoid `latest`)
- Minimize layers by combining RUN commands
- Use `.dockerignore` to exclude unnecessary files
- Run as non-root user when possible
- Clean up package manager cache

❌ **DON'T:**
- Use `latest` tag in production
- Run as root without necessity
- Copy entire directory when not needed
- Create large images with unnecessary dependencies

---

## Example: Custom Nginx Image

```dockerfile
FROM nginx:alpine

LABEL author="DevOps" \
      version="1.0" \
      description="Custom Nginx"

# Copy custom config
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy HTML files
COPY index.html /usr/share/nginx/html/index.html

# Create non-root user
RUN addgroup -g 1001 -S nginx && \
    adduser -S -D -H -u 1001 -h /var/cache/nginx \
    -s /sbin/nologin -c "Nginx user" -G nginx nginx

USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### Build and run
```bash
docker build -t custom-nginx:v1 .
docker run -d -p 8080:80 custom-nginx:v1
```

