# Container and Host Interaction

## Container-Host Communication

Docker containers run isolated from the host, but they can still communicate with the host system. Here are the methods:

---

## 1. Port Mapping

### Accessing container services from host

```bash
# Run Nginx on port 8080
docker run -d -p 8080:80 --name webserver nginx

# Host machine can access at http://localhost:8080
```

### Multiple ports
```bash
# Map multiple ports
docker run -d \
  -p 8080:80 \      # HTTP
  -p 8443:443 \     # HTTPS
  --name webserver \
  nginx
```

### Host IP and port
```bash
# Access from another machine
http://host-ip:8080
http://192.168.1.100:8080
```

---

## 2. Volume Mounting (File Sharing)

### Mount host directory to container

```bash
# Mount current directory
docker run -it -v $(pwd):/app ubuntu bash

# Inside container, /app contains all files from host current directory
```

### Create file in container, access from host

```bash
# Run container with volume
docker run -it -v /tmp/mydata:/data ubuntu bash

# Inside container
echo "Hello from container" > /data/test.txt

# On host machine
ls /tmp/mydata          # File exists here too!
cat /tmp/mydata/test.txt  # Shows: Hello from container
```

### Persistent data example

```bash
# Database with persistent storage
docker run -d \
  --name mysql_db \
  -v mysql_data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql

# Data persists even after container is removed
```

---

## 3. Environment Variables

### Pass host environment to container

```bash
# Pass single variable
docker run -e COLLEGE=CSE -it ubuntu bash

# Inside container
echo $COLLEGE  # Shows: CSE
```

### Pass multiple variables

```bash
docker run \
  -e APP_NAME=myapp \
  -e LOG_LEVEL=debug \
  -e DATABASE_URL=localhost:5432 \
  -it ubuntu bash
```

### From environment file
```bash
# Create .env file
echo "APP_NAME=myapp" > .env
echo "LOG_LEVEL=info" >> .env

# Use environment file
docker run --env-file .env -it ubuntu bash
```

---

## 4. Container Execution and Interaction

### Execute commands in running container

```bash
# Enter shell
docker exec -it container_name /bin/bash

# Run single command
docker exec container_name ls /
docker exec container_name pwd

# Create file
docker exec container_name touch /tmp/test.txt

# Check file from container
docker exec container_name cat /tmp/test.txt
```

### Create and verify data in container

```bash
# Start container
docker run -d --name myapp ubuntu sleep 1000

# Create directory
docker exec myapp mkdir /app

# Create file with content
docker exec myapp bash -c 'echo "Hello Docker" > /app/data.txt'

# View file
docker exec myapp cat /app/data.txt

# List files
docker exec myapp ls /app
```

---

## 5. Networking

### Container-to-Container Communication

```bash
# Create bridge network
docker network create mynetwork

# Run containers on same network
docker run -d --name web --network mynetwork nginx
docker run -d --name app --network mynetwork ubuntu sleep 1000

# Ping between containers
docker exec app ping web
```

### Expose ports for external access

```bash
# Expose port in Dockerfile
# EXPOSE 8080

# Run container
docker run -d -p 8080:8080 myapp

# Access from host
curl http://localhost:8080
```

---

## 6. Logs and Monitoring

### View container logs

```bash
# All logs
docker logs container_name

# Follow logs (stream)
docker logs -f container_name

# Last N lines
docker logs --tail 50 container_name

# Timestamps
docker logs --timestamps container_name
```

### Inspect container

```bash
# View all details
docker inspect container_name

# Specific information
docker inspect -f '{{.NetworkSettings.IPAddress}}' container_name
```

### Get resource usage

```bash
# View CPU and memory usage
docker stats container_name

# All containers
docker stats
```

---

## 7. Copy Files Between Host and Container

### Copy from host to container

```bash
docker cp ./local_file.txt container_name:/path/in/container/

# Example
docker cp index.html webserver:/usr/share/nginx/html/
```

### Copy from container to host

```bash
docker cp container_name:/path/in/container/file.txt ./local_path/

# Example
docker cp webserver:/etc/nginx/nginx.conf ./backup/
```

---

## Practical Examples

### Example 1: Web Development

```bash
# Run web server with local code
docker run -d \
  --name dev_server \
  -p 8000:8000 \
  -v $(pwd):/app \
  -e DEBUG=true \
  python:3.9 \
  python -m http.server 8000 --directory /app

# Edit files on host, changes reflect in container
```

### Example 2: Database with Data Persistence

```bash
# Create volume
docker volume create pgdata

# Run PostgreSQL
docker run -d \
  --name postgres_db \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:13

# Data persists after container removal
docker rm postgres_db
docker run -d --name postgres_db -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:13
# Same data is available
```

### Example 3: Application Configuration

```bash
# Create config file
cat > app.conf << EOF
database=postgres
port=8000
debug=true
EOF

# Run with config
docker run -d \
  --name myapp \
  -v $(pwd)/app.conf:/etc/app/config \
  -e CONFIG_PATH=/etc/app/config \
  myapp-image

# Access config inside container
docker exec myapp cat /etc/app/config
```

### Example 4: Logs Access

```bash
# Run application
docker run -d \
  --name myapp \
  -v $(pwd)/logs:/app/logs \
  myapp-image

# View logs from host
tail -f logs/app.log

# Also viewable via Docker
docker logs -f myapp
```

---

## Quick Reference

| Operation | Command |
|-----------|---------|
| Port map | `docker run -p 8080:80 image` |
| Mount directory | `docker run -v /host:/container image` |
| Set env var | `docker run -e VAR=value image` |
| Execute command | `docker exec -it container cmd` |
| View logs | `docker logs container` |
| Copy file | `docker cp file container:/path` |
| Network create | `docker network create name` |
| Container IP | `docker inspect container -f {{.Networks...IPAddress}}` |

