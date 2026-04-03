# Docker Run - Detailed Examples

## Basic Docker Run Syntax

```bash
docker run [OPTIONS] IMAGE [COMMAND]
```

---

## Common Run Options

### 1. Interactive and Terminal (-it)

Run container with interactive terminal:

```bash
# Interactive Ubuntu
docker run -it ubuntu bash

# Interactive Alpine
docker run -it alpine sh

# Stay in container even after command ends
docker run -it --name mycontainer ubuntu /bin/bash
```

### 2. Detached Mode (-d)

Run container in background:

```bash
# Run in background
docker run -d nginx

# Run in background with name
docker run -d --name webserver nginx
```

### 3. Port Mapping (-p)

Map ports between host and container:

```bash
# Map single port
docker run -d -p 8080:80 nginx
# Host port 8080 → Container port 80

# Map multiple ports
docker run -d -p 8080:80 -p 443:443 nginx

# Map to all interfaces
docker run -d -p 0.0.0.0:8080:80 nginx

# Map with random port
docker run -d -p 8080 nginx
```

### 4. Environment Variables (-e)

Set environment variables:

```bash
# Single variable
docker run -it -e COLLEGE=CSE ubuntu bash

# Multiple variables
docker run -d -e APP_ENV=production -e LOG_LEVEL=info myapp

# From file
docker run -d --env-file .env myapp
```

Inside container:
```bash
echo $COLLEGE  # Shows: CSE
```

### 5. Container Name (--name)

Assign friendly name to container:

```bash
docker run -d --name mywebserver nginx

# Use name in commands
docker stop mywebserver
docker logs mywebserver
docker exec -it mywebserver bash
```

### 6. Volumes (-v)

Mount directories/volumes:

```bash
# Mount host directory
docker run -it -v /host/path:/container/path ubuntu bash

# Mount named volume
docker run -d -v mydata:/app/data ubuntu

# Read-only mount
docker run -it -v /data:/data:ro ubuntu bash
```

### 7. Working Directory (-w)

Set working directory in container:

```bash
docker run -it -w /app ubuntu bash
# Inside container, you'll be in /app
```

### 8. Memory and CPU Limits

```bash
# Limit memory
docker run -d --memory 512m nginx

# Limit CPU
docker run -d --cpus 1.5 nginx

# Both limits
docker run -d --memory 1g --cpus 2 myapp
```

### 9. Keep Container Running (--restart)

Auto-restart policy:

```bash
# No restart
docker run -d --restart=no ubuntu sleep 100

# Always restart
docker run -d --restart=always nginx

# Restart unless stopped
docker run -d --restart=unless-stopped nginx

# Restart with max retry count
docker run -d --restart=on-failure:5 myapp
```

### 10. Remove Container on Exit (--rm)

```bash
# Container auto-removed after exit
docker run -it --rm ubuntu bash

# Useful for testing
docker run --rm image_name test_command
```

---

## Practical Examples

### Example 1: Web Server

```bash
docker run -d \
  --name webserver \
  -p 8080:80 \
  --memory 512m \
  --restart=unless-stopped \
  nginx
```

### Example 2: Database

```bash
docker run -d \
  --name mysql_db \
  -e MYSQL_ROOT_PASSWORD=admin123 \
  -e MYSQL_DATABASE=myapp \
  -v mysql_data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:5.7
```

### Example 3: Node.js App

```bash
docker run -d \
  --name nodeapp \
  -p 3000:3000 \
  -e NODE_ENV=production \
  -v /app/logs:/app/logs \
  --restart=always \
  node-app:v1
```

### Example 4: Development Environment

```bash
docker run -it \
  --name dev \
  -v $(pwd):/workspace \
  -w /workspace \
  -e USER=developer \
  ubuntu bash
```

### Example 5: Testing

```bash
docker run --rm \
  -v $(pwd):/app \
  -w /app \
  node:14 \
  npm test
```

---

## Exit vs Detach

### Exit Container (stop it)
```bash
# In interactive container, press Ctrl+C or type:
exit
```

### Detach (keep running)
```bash
# In interactive container, press:
Ctrl+P, then Ctrl+Q
```

---

## Common Run Scenarios

| Scenario | Command |
|----------|---------|
| Quick test | `docker run --rm ubuntu ls /` |
| Web server | `docker run -d -p 8080:80 nginx` |
| Database | `docker run -d -e MYSQL_ROOT_PASSWORD=pass mysql` |
| Development | `docker run -it -v $(pwd):/app ubuntu bash` |
| Background job | `docker run -d myapp` |
| Debugging | `docker run -it ubuntu /bin/bash` |

---

## Tips & Tricks

✅ Use `--name` for easy reference  
✅ Use `-d` for background services  
✅ Use `-it` for interactive work  
✅ Use `--rm` to avoid container clutter  
✅ Use `-v` to persist data  
✅ Use `-e` for configuration  
✅ Use `--restart` for production containers  
✅ Use `--memory` and `--cpus` for resource management  

