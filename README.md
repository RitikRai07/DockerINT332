# Docker DevOps Lab 🚀

This repository contains Docker practice commands, projects, and theory based on DevOps lab exercises. Perfect for learning Docker fundamentals, building containerized applications, and preparing for DevOps interviews.

## 📋 Topics Covered

- Docker Introduction & Concepts
- Docker Images and Containers
- Docker Commands and Options
- Environment Variables
- Container Interaction with Host
- Docker Volumes and Storage
- Docker Networking
- Custom Docker Images
- Docker Projects (Nginx + Node.js)
- Docker Lifecycle

---

## 🐳 Quick Docker Commands Reference

### Pull Images

```bash
docker pull ubuntu
docker pull nginx
docker pull alpine
docker pull mysql
docker pull mongo
docker pull node
```

### Run Containers

```bash
# Simple container
docker run hello-world

# Interactive container
docker run -it ubuntu bash

# Detached container with port mapping
docker run -d -p 8080:80 nginx

# Container with environment variables
docker run -it -e COLLEGE=CSE ubuntu bash

# Container with name
docker run -d --name mycontainer ubuntu
```

### Container Management

```bash
# List running containers
docker ps

# List all containers
docker ps -a

# Stop container
docker stop container_name

# Start stopped container
docker start container_name

# Remove container
docker rm container_id

# View container logs
docker logs container_name
docker logs -f container_name

# Execute command in container
docker exec -it containerID /bin/bash
```

### Image Management

```bash
# List images
docker images

# Remove image
docker rmi image_id

# Build image from Dockerfile
docker build -t image_name:tag .

# Remove unused images
docker image prune
```

### Docker Info

```bash
# Check Docker version
docker --version

# Docker system information
docker info

# Inspect container
docker inspect container_name
```

---

## 📁 Repository Structure

```
docker-devops-lab/
│
├── README.md                          # Main documentation
│
├── 01_Docker_Basics/
│   ├── docker_commands.md            # Basic commands
│   ├── docker_images.md              # Image creation
│   └── docker_run_examples.md        # Run options examples
│
├── 02_Container_Interaction/
│   └── container_host_interaction.md # Host-container interaction
│
├── 03_Docker_Volumes/
│   └── volume_commands.md            # Volume management
│
├── 04_Docker_Projects/
│   │
│   ├── nginx-app/
│   │   ├── Dockerfile
│   │   ├── index.html
│   │   └── default.conf
│   │
│   └── node-app/
│       ├── Dockerfile
│       ├── app.js
│       ├── package.json
│       └── .dockerignore
│
├── 05_Practice_Questions/
│   └── docker_questions_answers.md   # Q&A from PPT
│
└── PPT_Reference/
    └── docker_commands.ppt           # Reference materials
```

---

## 🚀 Quick Start Projects

### Nginx Project

```bash
cd 04_Docker_Projects/nginx-app

# Build image
docker build -t custom-nginx:v1 .

# Run container
docker run -d -p 8080:80 --name nginx-container custom-nginx:v1

# Access at http://localhost:8080
```

### Node.js Project

```bash
cd 04_Docker_Projects/node-app

# Build image
docker build -t node-demo:v1 .

# Run container
docker run -d -p 3000:3000 --name node-container node-demo:v1

# Access at http://localhost:3000
```

---

## 📚 Docker Lifecycle

1. **Build** - Create Docker image from Dockerfile
2. **Ship** - Push image to Docker Hub or registry
3. **Run** - Deploy container from image

---

## 🔧 Docker Volumes Example

```bash
# Create volume
docker volume create mydata

# Run container with volume
docker run -dit --name mycontainer -v mydata:/app/data ubuntu

# Enter container
docker exec -it mycontainer /bin/bash

# Create data
mkdir /app/data
echo "Hello Docker" > /app/data/test.txt

# Data persists after container removal
docker rm mycontainer -v
```

---

## 📖 File Descriptions

| File | Purpose |
|------|---------|
| [01_Docker_Basics/docker_commands.md](01_Docker_Basics/docker_commands.md) | Essential Docker commands |
| [01_Docker_Basics/docker_images.md](01_Docker_Basics/docker_images.md) | Image creation and management |
| [02_Container_Interaction/container_host_interaction.md](02_Container_Interaction/container_host_interaction.md) | Container and host interaction |
| [03_Docker_Volumes/volume_commands.md](03_Docker_Volumes/volume_commands.md) | Volume management commands |
| [05_Practice_Questions/docker_questions_answers.md](05_Practice_Questions/docker_questions_answers.md) | Q&A from lectures |

---

## ✅ Use Cases

✅ DevOps Portfolio Building  
✅ Internship Interview Preparation  
✅ GitHub Profile Enhancement  
✅ Lab Submissions  
✅ Docker Learning Reference  

---

## 🎓 Learning Resources

- **Unit 1:** Docker Introduction & DevOps Concepts
- **Unit 2:** Basic Docker Commands & Practice
- **Unit 3:** Docker Projects (Nginx + Node.js)
- **Unit 4:** Advanced Docker Features

---

## 📝 How to Use This Repo

1. Clone the repository
2. Navigate to relevant section (Basics, Projects, Practice Questions)
3. Follow the instructions in each markdown file
4. Build and run projects locally
5. Practice commands with provided examples
6. Answer practice questions to test understanding

---

## 🤝 Contributing

Feel free to add more examples, improve documentation, or create additional projects.

---

## 📄 License

This repository is for educational purposes.

---

**Author:** DevOps Practice Repository  
**Date:** 2024  
**Version:** 1.0
