# Docker Practice Questions & Answers

This file contains practice questions from the PPT lectures with detailed answers.

---

## Basic Docker Commands

### Q1: Check Docker version and installation

**Question:** How do you verify that Docker is properly installed on your system?

**Answer:**
```bash
docker --version
# Output: Docker version 20.10.x, build xxxxxxx

# For more details
docker info
```

---

### Q2: Pull and run a basic image

**Question:** Pull the Ubuntu image from Docker Hub and run an interactive container.

**Answer:**
```bash
# Pull image
docker pull ubuntu

# Run container interactively
docker run -it ubuntu bash

# Inside container you can run commands
ls /
pwd
cat /etc/os-release
```

---

### Q3: Run Nginx container with port mapping

**Question:** Run a Nginx container that exposes port 8080 on the host, mapped to port 80 inside the container.

**Answer:**
```bash
docker run -d -p 8080:80 nginx

# Visit browser: http://localhost:8080
```

---

### Q4: Run container with environment variables

**Question:** Run an Ubuntu container with environment variable COLLEGE=CSE and verify it inside the container.

**Answer:**
```bash
# Run container with environment variable
docker run -it -e COLLEGE=CSE ubuntu bash

# Inside container, display variable
echo $COLLEGE
# Output: CSE
```

---

### Q5: List containers

**Question:** Show the difference between `docker ps` and `docker ps -a`.

**Answer:**
```bash
# Running containers only
docker ps

# All containers (running and stopped)
docker ps -a

# Additional info
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
```

---

## Container Management

### Q6: Stop and start a container

**Question:** Stop a running container named "mycontainer" and then start it again.

**Answer:**
```bash
# Stop container
docker stop mycontainer

# Start stopped container
docker start mycontainer

# Verify status
docker ps -a
```

---

### Q7: Remove stopped containers

**Question:** Remove a container with ID abc123def456.

**Answer:**
```bash
# Remove specific container
docker rm abc123def456

# Or remove by name
docker rm mycontainer

# Remove all stopped containers
docker container prune
```

---

### Q8: View container logs

**Question:** Check the logs of a container named "webserver". How do you see logs in real-time?

**Answer:**
```bash
# View all logs
docker logs webserver

# View last 50 lines
docker logs --tail 50 webserver

# Follow logs in real-time
docker logs -f webserver
docker logs --follow webserver
```

---

## Container Execution

### Q9: Execute command in running container

**Question:** Run the command `ls /app` inside a running container named "myapp".

**Answer:**
```bash
docker exec myapp ls /app

# For interactive shell
docker exec -it myapp /bin/bash
```

---

### Q10: Create files inside container

**Question:** Create a directory `/data` and a file `test.txt` with content "Hello Docker" in a running container.

**Answer:**
```bash
# Create directory
docker exec mycontainer mkdir /data

# Create file with content
docker exec mycontainer bash -c 'echo "Hello Docker" > /data/test.txt'

# Verify file
docker exec mycontainer cat /data/test.txt
```

---

## Volumes

### Q11: Create and use a named volume

**Question:** Create a named volume "mydata" and run a container that uses this volume at `/app/data`.

**Answer:**
```bash
# Create volume
docker volume create mydata

# Run container with volume
docker run -it --name mycontainer -v mydata:/app/data ubuntu bash

# Inside container
ls /app/data
echo "Persistent data" > /app/data/file.txt
```

---

### Q12: Verify data persistence

**Question:** Stop and remove a container that has a volume. Then run a new container with the same volume. Verify that the data still exists.

**Answer:**
```bash
# Create and use volume (from Q11)
docker run -it --name container1 -v mydata:/app/data ubuntu bash
# Inside: echo "test" > /app/data/data.txt

# Stop and remove
docker stop container1
docker rm container1

# Create new container with same volume
docker run -it --name container2 -v mydata:/app/data ubuntu bash

# Inside: cat /app/data/data.txt
# Output: test (Data persists!)
```

---

### Q13: Mount host directory

**Question:** Run a container and mount your current host directory to `/workspace` in the container.

**Answer:**
```bash
# Linux/Mac
docker run -it -v $(pwd):/workspace ubuntu bash

# Windows PowerShell
docker run -it -v ${PWD}:/workspace ubuntu bash

# Inside container, /workspace has files from host
```

---

## Image Management

### Q14: List and remove images

**Question:** List all images and then remove an image by ID.

**Answer:**
```bash
# List images
docker images

# Remove image by ID
docker rmi image_id

# Remove by name and tag
docker rmi ubuntu:20.04

# Remove all unused images
docker image prune
```

---

### Q15: Build custom image from Dockerfile

**Question:** Create a Dockerfile that installs nginx and exposes port 80.

**Answer:**
```dockerfile
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

Build and run:
```bash
# Build
docker build -t mynginx:v1 .

# Run
docker run -d -p 8080:80 mynginx:v1
```

---

## Docker Compose & Networking

### Q16: Create a bridge network

**Question:** Create a custom network and run two containers that can communicate with each other.

**Answer:**
```bash
# Create network
docker network create mynetwork

# Run first container
docker run -d --name container1 --network mynetwork ubuntu sleep 1000

# Run second container
docker run -d --name container2 --network mynetwork ubuntu sleep 1000

# From container2, ping container1
docker exec container2 ping container1
```

---

## Advanced Questions

### Q17: Environment variables from file

**Question:** Create an .env file with variables and load them into a container.

**Answer:**
```bash
# Create .env file
cat > .env << EOF
APP_NAME=myapp
LOG_LEVEL=debug
DB_HOST=localhost
EOF

# Run container with env file
docker run -it --env-file .env ubuntu bash

# Inside: echo $APP_NAME
```

---

### Q18: Resource limits

**Question:** Run a container with memory limit of 512MB and CPU limit of 1.

**Answer:**
```bash
docker run -d \
  --memory 512m \
  --cpus 1 \
  --name limited-app \
  nginx
```

---

### Q19: Copy files between host and container

**Question:** Copy a file from host to container and vice versa.

**Answer:**
```bash
# Copy from host to container
docker cp ./myfile.txt mycontainer:/app/

# Copy from container to host
docker cp mycontainer:/app/data.txt ./

# Verify
ls ./data.txt
```

---

### Q20: Container inspection

**Question:** Get detailed information about a running container.

**Answer:**
```bash
# All details
docker inspect mycontainer

# Specific information - IP Address
docker inspect -f '{{.NetworkSettings.IPAddress}}' mycontainer

# Memory usage
docker stats mycontainer

# Processes inside
docker top mycontainer
```

---

## Scenario-Based Questions

### Q21: Multi-stage debugging

**Question:** A container is not starting. How would you debug this?

**Answer:**
```bash
# 1. Check if image exists
docker images | grep myimage

# 2. Try running with different command
docker run -it myimage /bin/bash

# 3. Check logs
docker logs mycontainer

# 4. Inspect container
docker inspect mycontainer

# 5. Check system resources
docker stats
```

---

### Q22: Production deployment scenario

**Question:** Design running an Nginx web server with:
- Name: "web-prod"
- Port: 8080:80
- Restart policy: always
- Memory limit: 512MB
- Detached mode

**Answer:**
```bash
docker run -d \
  --name web-prod \
  -p 8080:80 \
  --restart=always \
  --memory 512m \
  nginx
```

---

### Q23: Data persistence scenario

**Question:** Run a MySQL database that:
- Persists data in a volume called "db_data"
- Sets root password to "secure123"
- Exposes port 3306

**Answer:**
```bash
# Create volume
docker volume create db_data

# Run MySQL
docker run -d \
  --name mysql_db \
  -e MYSQL_ROOT_PASSWORD=secure123 \
  -v db_data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:5.7
```

---

## Answer Key Summary

| Q | Topic | Command |
|---|-------|---------|
| Q1 | Version | `docker --version` |
| Q2 | Pull & Run | `docker pull ubuntu && docker run -it ubuntu` |
| Q3 | Port Map | `docker run -d -p 8080:80 nginx` |
| Q4 | Env Vars | `docker run -e VAR=value ubuntu` |
| Q5 | List | `docker ps -a` |
| Q6 | Stop/Start | `docker stop/start container` |
| Q7 | Remove | `docker rm container_id` |
| Q8 | Logs | `docker logs -f container` |
| Q9 | Exec | `docker exec container command` |
| Q10 | Create File | `docker exec container bash -c 'cmd'` |
| Q11 | Volume | `docker volume create && docker run -v` |
| Q12 | Persistence | Volume data survives container removal |
| Q13 | Bind Mount | `docker run -v $(pwd):/path` |
| Q14 | Images | `docker images && docker rmi` |
| Q15 | Dockerfile | `docker build -t image .` |

