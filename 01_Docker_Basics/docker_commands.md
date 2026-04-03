# Basic Docker Commands

## Docker Version & Info

### Check Docker version
```bash
docker --version
```

### View Docker system information
```bash
docker info
```

---

## Image Management

### List all images
```bash
docker images
```

### Pull an image from Docker Hub
```bash
docker pull ubuntu
docker pull nginx
docker pull alpine
docker pull mysql
docker pull node
```

### Remove an image
```bash
docker rmi image_id
docker rmi image_name:tag
```

### Search Docker Hub for images
```bash
docker search ubuntu
```

### Remove all unused images
```bash
docker image prune
```

---

## Container Management - Basic

### Run a simple container
```bash
docker run hello-world
```

### Run Ubuntu container interactively
```bash
docker run -it ubuntu bash
```

### Run container in background
```bash
docker run -d ubuntu sleep 1000
```

### Run container with a specific name
```bash
docker run --name mycontainer ubuntu
```

### List running containers
```bash
docker ps
```

### List all containers (including stopped)
```bash
docker ps -a
```

### Stop a running container
```bash
docker stop container_name
docker stop container_id
```

### Start a stopped container
```bash
docker start container_name
```

### Remove a container
```bash
docker rm container_id
```

### Remove all stopped containers
```bash
docker container prune
```

---

## Container Inspection

### View container details
```bash
docker inspect container_name
```

### View container logs
```bash
docker logs container_name
```

### Follow container logs (stream)
```bash
docker logs -f container_name
docker logs --follow container_name
```

### Get last 50 lines of logs
```bash
docker logs --tail 50 container_name
```

### View container processes
```bash
docker top container_name
```

---

## Container Execution

### Execute command in running container
```bash
docker exec -it container_id /bin/bash
```

### Run command without entering container
```bash
docker exec container_id ls /
docker exec container_id pwd
```

### Execute with specific user
```bash
docker exec -u root container_id ls /
```

---

## Port Management

### Run container with port mapping
```bash
docker run -d -p 8080:80 nginx
# Maps port 8080 on host to port 80 in container
```

### View port mappings
```bash
docker port container_name
```

---

## Quick Reference Table

| Command | Purpose |
|---------|---------|
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker images` | List all images |
| `docker run` | Create and run container |
| `docker stop` | Stop running container |
| `docker start` | Start stopped container |
| `docker rm` | Remove container |
| `docker rmi` | Remove image |
| `docker exec` | Execute command in container |
| `docker logs` | View container logs |
| `docker inspect` | View detailed info |

