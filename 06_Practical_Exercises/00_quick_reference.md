# 🐳 Docker Practical Exercises - Quick Reference

## 📑 Complete Task Index

Navigate through all practical exercises with this comprehensive index.

---

## 🎯 All Tasks Overview

| Task | Focus Area | Duration | Level |
|------|-----------|----------|-------|
| **Task 5** | Container Operations & File Transfer | 20-30 min | Beginner |
| **Task 6A** | File Management in Containers | 15-20 min | Beginner |
| **Task 6B** | Volume Basics (Creation & Management) | 15-20 min | Beginner |
| **Task 7** | Volume Persistence & Data Survival | 25-30 min | Intermediate |

---

## 🚀 Quick Command Reference

### Container Operations

```bash
# Start container
docker start <container-id>

# List root directory
docker exec -it <container-id> ls /

# Open bash shell
docker exec -it <container-id> /bin/bash

# Create directory
mkdir /directory-name

# Create file with content
echo "content" > /path/file.txt

# Exit shell
exit
```

### File Transfer (docker cp)

```bash
# Container → Host
docker cp <container-id>:/container/path "C:\host\path\"

# Host → Container  
docker cp "C:\host\path\file.txt" <container-id>:/container/path/

# Copy directories (-r flag)
docker cp -r <container-id>:/container/dir C:\host\backup\
```

### Volume Commands

```bash
# Create volume
docker volume create mydata

# List volumes
docker volume ls

# Inspect volume
docker volume inspect mydata

# Run container with volume
docker run -dit -v mydata:/app/data --name container-name ubuntu bash

# Remove container
docker rm -f container-name

# Remove volume
docker volume rm mydata

# Remove unused volumes
docker volume prune
```

### Verification Commands

```bash
# List directory contents
docker exec -it <container-id> ls /directory

# Display file content
docker exec -it <container-id> cat /path/file.txt

# Check container details
docker inspect <container-id>

# Inspect volume details
docker volume inspect <volume-name>
```

---

## 📊 File Transfer Workflow Diagram

```
HOST MACHINE ←→ CONTAINER
     ↓
    (1) Start Container
        └─→ docker start <id>
     
    (2) Execute Commands
        └─→ docker exec -it <id> <command>
     
    (3) Create Directories/Files
        └─→ Inside container shell
            ├─→ mkdir /directory
            └─→ echo "text" > /file.txt
     
    (4) Transfer Files
        ├─→ docker cp container:/source "host:\dest"
        └─→ docker cp "host:\source" container:/dest
     
    (5) Verify
        └─→ docker exec -it <id> ls /directory
```

---

## 🔄 Volume Persistence Workflow Diagram

```
TIMELINE: Docker Volume Lifecycle

▌ Step 1: Create Volume
  docker volume create mydata
  ↓
  Volume Created [Empty]

▌ Step 2: Run Container
  docker run -v mydata:/app/data ...
  ↓
  Container ← Connected → Volume

▌ Step 3: Create Data
  echo "data" > /app/data/file.txt
  ↓
  Volume [Contains File]

▌ Step 4: Remove Container
  docker rm -f mycontainer
  ↓
  Container Deleted
  Volume [Still Has File] ← PERSISTENCE!

▌ Step 5: New Container with Same Volume
  docker run -v mydata:/app/data ...
  ↓
  New Container ← Connected → Volume [File Still There!]
```

---

## 🎬 Task Execution Flowchart

```
START
  │
  ├─→ Task 5: Container Operations & File Transfer
  │   ├─ Start container
  │   ├─ List directories
  │   ├─ Create directories & files in container
  │   ├─ Copy files container → host
  │   ├─ Copy files host → container
  │   └─ Verify operations
  │
  ├─→ Task 6A: File Management (Directories)
  │   ├─ Create /project directory
  │   ├─ Create /project/report.txt
  │   ├─ Copy to host
  │   ├─ Copy from host
  │   └─ Verify in /project directory
  │
  ├─→ Task 6B: Volume Basics
  │   ├─ Create volume
  │   ├─ List volumes
  │   ├─ Inspect volume
  │   └─ Run container with volume
  │
  └─→ Task 7: Volume Persistence
      ├─ Create volume
      ├─ Run container with volume
      ├─ Create files in volume
      ├─ Remove container (keep volume!)
      ├─ Run new container with same volume
      ├─ Verify data still exists ✓
      └─ Clean up
  │
  ▼
COMPLETE
```

---

## 📋 Common Issues & Solutions

### Issue: "No such container"

**Error:**
```
Error: No such container [container-id]
```

**Solution:**
```bash
# Find your container ID
docker ps -a

# Use the correct ID from the output
docker start <correct-id>
```

---

### Issue: "Permission denied" (Linux/Mac)

**Error:**
```
permission denied while trying to connect to Docker daemon
```

**Solution:**
```bash
# Add sudo (if needed)
sudo docker start <container-id>

# OR join docker group
sudo usermod -aG docker $USER
```

---

### Issue: "Volume already exists"

**Error:**
```
Error response from daemon: volume name already exists
```

**Solution:**
```bash
# List existing volumes
docker volume ls

# Use different name or remove existing volume
docker volume rm <existing-volume>
docker volume create <new-name>
```

---

### Issue: "Cannot remove container - volume in use"

**Error:**
```
Error response from daemon: cannot remove container - volume still in use
```

**Solution:**
```bash
# Remove containers using the volume first
docker rm -f <container-name>

# Then remove volume
docker volume rm <volume-name>
```

---

## 🎓 Key Learning Points

### File Transfer Understanding

✓ **docker cp syntax**: `docker cp <source> <destination>`
✓ **Container path format**: `container-id:/path/to/file`
✓ **Windows paths**: Use backslashes or forward slashes
✓ **Recursive copy**: Use `-r` flag for directories

### Volume Concepts

✓ **Named volumes**: Persistent, managed by Docker
✓ **Volume independence**: Exists separate from container
✓ **Data persistence**: Survives container deletion
✓ **Mount point**: Where volume connects in container
✓ **Multiple containers**: Can share same volume

### Container Interaction

✓ **docker exec**: Run commands in running container
✓ **Interactive mode (-it)**: Human interaction with container
✓ **Detached mode (-d)**: Background execution
✓ **Shell access**: Direct terminal inside container

---

## 🔧 Advanced Tips

### Copy Files Without Stopping Container

```bash
# Works on running containers
docker cp file.txt container-id:/destination/
```

### Check File Before Copying

```bash
# Verify file exists in container first
docker exec -it container-id cat /path/file.txt

# Then copy it
docker cp container-id:/path/file.txt ./
```

### Batch Copy Multiple Files

```bash
# Copy entire directory
docker cp -r container-id:/app/data ./data-backup

# Then browse locally
ls -R ./data-backup
```

### Monitor Volume Usage

```bash
# See how much data in volume
docker volume inspect mydata | grep Mountpoint

# On Linux, check size
du -sh /var/lib/docker/volumes/mydata/_data
```

---

## 📚 File Structure After All Tasks

```
Docker Practice Repository:
docker-devops-lab/
├── 01_Docker_Basics/
│   ├── docker_commands.md
│   ├── docker_images.md
│   └── docker_run_examples.md
│
├── 02_Container_Interaction/
│   └── container_host_interaction.md
│
├── 03_Docker_Volumes/
│   └── volume_commands.md
│
├── 04_Docker_Projects/
│   ├── nginx-app/
│   └── node-app/
│
├── 05_Practice_Questions/
│   └── docker_questions_answers.md
│
├── 06_Practical_Exercises/  ← NEW!
│   ├── 00_quick_reference.md (YOU ARE HERE)
│   ├── 01_container_operations_file_transfer.md
│   ├── 02_volume_persistence.md
│   └── 03_volume_basics_guide.md
│
├── README.md
└── PPT_Reference/
```

---

## 🎯 Next Steps

1. **Complete Task 5** - Start with container operations
   - File: [01_container_operations_file_transfer.md](01_container_operations_file_transfer.md)

2. **Complete Task 6A & 6B** - File management & volumes
   - File: Same as Task 5 continuation + Volume basics

3. **Complete Task 7** - Volume persistence
   - File: [02_volume_persistence.md](02_volume_persistence.md)

4. **Practice & Experiment**
   - Try with different containers
   - Create your own workflows
   - Explore volume edge cases

---

## 🔗 Related Resources

- [Official Docker Documentation](https://docs.docker.com/)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [Volume Command Reference](https://docs.docker.com/storage/volumes/)
- [Container Interaction Guide](./../02_Container_Interaction/container_host_interaction.md)

---

## ⚡ Pro Tips

1. **Use Container Names** - Easier to remember than IDs
   ```bash
   docker run --name myapp ...
   docker start myapp
   ```

2. **Label Important Volumes**
   ```bash
   docker volume create mydata --label version=1.0
   ```

3. **Backup Volumes Regularly**
   ```bash
   docker cp container:/app/data ./backup-$(date +%Y%m%d)/
   ```

4. **Use Descriptive Paths**
   ```bash
   # Good
   docker cp app.jar container://app/src/
   
   # Avoid
   docker cp app.jar container://
   ```

5. **Verify Before Removing**
   ```bash
   # Always check content first
   docker exec container ls /
   
   # Then remove safely
   docker rm container
   ```

---

## ✅ Success Metrics

You've completed this module when you can:

- [ ] Start and manage Docker containers
- [ ] Transfer files between host and container
- [ ] Create and manage Docker volumes
- [ ] Verify data persistence
- [ ] Troubleshoot common issues
- [ ] Backup and clean up volumes
- [ ] Explain volume importance in production

---

**Last Updated:** March 12, 2024
**Status:** Ready for Practice

Happy Learning! 🎉

