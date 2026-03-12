# 📌 Task 7 – Docker Volume Persistence

Complete guide to creating, managing, and verifying Docker volumes with data persistence.

---

## 🎯 Objectives

- Create Docker named volumes
- Mount volumes to containers
- Verify data persistence
- Clean up volumes properly

---

## 📊 Volume Persistence Workflow

```
┌──────────────────────────────────────────────────────────┐
│             DOCKER VOLUME PERSISTENCE                    │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  Step 1: Create Volume                                  │
│  ┌──────────────────┐                                   │
│  │ docker volume    │                                   │
│  │ create mydata    │                                   │
│  └────────┬─────────┘                                   │
│           │                                              │
│  Step 2: Run Container with Volume                      │
│  ┌─────────────────────────────────┐                    │
│  │ docker run -v mydata:/app/data  │                    │
│  └────────┬────────────────────────┘                    │
│           │                                              │
│  Step 3: Create Data in Volume                          │
│  ┌────────────────────────────────┐                     │
│  │ echo "data" > /app/data/file.txt│                    │
│  └────────┬───────────────────────┘                     │
│           │                                              │
│  Step 4: Remove Container (Data Persists!)             │
│  ┌──────────────────┐                                   │
│  │ docker rm        │                                   │
│  └────────┬─────────┘                                   │
│           │                                              │
│  Step 5: Attach Volume to New Container                │
│  ┌─────────────────────────────────┐                    │
│  │ docker run -v mydata:/app/data  │                    │
│  └────────┬────────────────────────┘                    │
│           │                                              │
│  ✓ Data Still There! (Persistence)                      │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## 🚀 Step-by-Step Execution

### 1️⃣ Create Docker Volume

```bash
docker volume create mydata
```

**What it does:**
- Creates a named volume called `mydata`
- Volume is stored in Docker's internal directory
- On Linux: `/var/lib/docker/volumes/`
- On Docker Desktop (Windows/Mac): Managed by Docker

**Output:**
```
mydata
```

---

### 2️⃣ Verify Volume Created

List all volumes on your system:

```bash
docker volume ls
```

**Expected Output:**
```
DRIVER    VOLUME NAME
local     mydata
local     [other-volumes...]
```

---

### 3️⃣ Inspect Volume

Get detailed information about the volume:

```bash
docker volume inspect mydata
```

**Expected Output:**
```json
[
  {
    "CreatedAt": "2024-03-12T10:00:00Z",
    "Driver": "local",
    "Labels": {},
    "Mountpoint": "/var/lib/docker/volumes/mydata/_data",
    "Name": "mydata",
    "Options": {},
    "Scope": "local"
  }
]
```

**Key Attributes:**
- **Mountpoint:** Physical location where volume data is stored
- **Driver:** Storage driver (usually "local")
- **Scope:** Volume accessibility level

---

### 4️⃣ Run Container with Volume

Create and run a container with the volume mounted:

```bash
docker run -dit \
  --name mycontainer \
  -v mydata:/app/data \
  ubuntu bash
```

**Explanation of flags:**
```
-d              Detached mode (background)
-i              Interactive mode
-t              Terminal allocation
--name          Container name
-v              Volume mount
  mydata        Volume name
  /app/data     Mount point inside container
```

**What happens:**
- Container created with name `mycontainer`
- Volume `mydata` mounted to `/app/data` inside container
- Ubuntu image used with bash shell
- Container runs in background

---

### 5️⃣ Check Volume Directory

Verify the volume mount point inside the container:

```bash
docker exec -it mycontainer ls /app/data
```

**Expected Output (initially empty):**
```
# (no output = empty directory)
```

---

### 6️⃣ Open Container Shell

```bash
docker exec -it mycontainer bash
```

**What it does:** 
- Opens interactive bash shell inside the running container
- You're now inside the container at `/` root directory

---

### 7️⃣ Create File inside Volume

Inside the container shell, navigate to the volume and create a file:

```bash
# Inside container shell
cd /app/data
echo "Volume Data Saved" > file.txt
```

**Verify file creation:**
```bash
# Still inside container
ls -la /app/data
cat /app/data/file.txt
```

**Expected Output:**
```
total 12
drwxr-xr-x 2 root root 4096 Mar 12 10:05 .
drwxr-xr-x 3 root root 4096 Mar 12 10:04 ..
-rw-r--r-- 1 root root   18 Mar 12 10:05 file.txt
```

---

### 8️⃣ Exit Container Shell

```bash
exit
```

**What it does:** Returns to host terminal from container shell.

---

### 9️⃣ Verify File in Volume

From host terminal, verify the file still exists:

```bash
docker exec -it mycontainer cat /app/data/file.txt
```

**Expected Output:**
```
Volume Data Saved
```

---

### 🔟 Inspect Container

Get detailed information about the container:

```bash
docker inspect mycontainer
```

**Key Volume Information in Output:**

```json
"Mounts": [
  {
    "Type": "volume",
    "Name": "mydata",
    "Source": "/var/lib/docker/volumes/mydata/_data",
    "Destination": "/app/data",
    "Driver": "local",
    "Mode": "z",
    "RW": true,
    "Propagation": ""
  }
]
```

**What this tells us:**
- **Type:** Volume mount (vs bind mount)
- **Source:** Actual location on host
- **Destination:** Mount point in container
- **RW:** Read/Write permissions

---

## 🔄 Demonstrating Data Persistence (Critical Step!)

### 11️⃣ Remove Container (But Keep Volume)

```bash
docker rm -f mycontainer
```

**Important:** This removes the container but NOT the volume!

**Verify container is removed:**
```bash
docker ps -a | grep mycontainer
# (no output = container removed)
```

---

### 🎯 Create NEW Container with SAME Volume

```bash
docker run -dit \
  --name newcontainer \
  -v mydata:/app/data \
  ubuntu bash
```

---

### ✨ Verify Data Persistence

```bash
docker exec -it newcontainer cat /app/data/file.txt
```

**Expected Output:**
```
Volume Data Saved
```

**🎉 Success!** The data persisted even though we removed the original container!

---

## 📊 Data Persistence Demonstration

```
Timeline:

T1: Create Volume
    docker volume create mydata
    ↓
    [mydata] → Empty

T2: Run Container 1
    docker run -v mydata:/app/data --name mycontainer ...
    ↓
    Container 1 connected to [mydata]

T3: Create File
    echo "Volume Data Saved" > file.txt
    ↓
    [mydata] → Contains file.txt

T4: Remove Container 1
    docker rm -f mycontainer
    ↓
    Container 1 removed
    [mydata] → Still has file.txt! ← PERSISTENCE!

T5: Run Container 2
    docker run -v mydata:/app/data --name newcontainer ...
    ↓
    Container 2 connected to [mydata]

T6: Verify Data
    docker exec ... cat /app/data/file.txt
    ↓
    Output: "Volume Data Saved" ← DATA RECOVERED!
```

---

## 🧹 Cleanup Operations

### 12️⃣ Remove Container

```bash
docker rm -f newcontainer
```

**Flags:**
- `-f` Force removal (even if running)

---

### 13️⃣ Remove Specific Volume

```bash
docker volume rm mydata
```

**Warning:** This permanently deletes the volume and all its data!

**Verify removal:**
```bash
docker volume ls | grep mydata
# (no output = volume removed)
```

---

### 14️⃣ Remove All Unused Volumes

```bash
docker volume prune
```

**What it does:**
- Removes all volumes not currently in use
- Prompts for confirmation

**Interactive prompt:**
```
WARNING! This will remove anonymous local volumes not used by at least one container.
Are you sure you want to continue? [y/N] y
```

---

## 📋 Volume Management Commands Reference

| Command | Purpose |
|---------|---------|
| `docker volume create <name>` | Create named volume |
| `docker volume ls` | List all volumes |
| `docker volume inspect <name>` | Show volume details |
| `docker volume rm <name>` | Remove specific volume |
| `docker volume prune` | Remove unused volumes |
| `docker run -v <vol>:<path>` | Mount volume to container |

---

## 🔗 Volume Mount Path Examples

```bash
# Mount volume to /app/data
docker run -v mydata:/app/data ubuntu

# Mount volume to /data
docker run -v mydata:/data ubuntu

# Mount volume to root directory
docker run -v mydata:/ ubuntu

# Multiple volumes on same container
docker run -v vol1:/data1 -v vol2:/data2 ubuntu

# Read-only volume
docker run -v mydata:/data:ro ubuntu

# Read-write volume (default)
docker run -v mydata:/data:rw ubuntu
```

---

## 💡 Key Concepts

### What is Data Persistence?

Data persistence means data survives beyond the lifetime of a container. With volumes:
- ✅ Data survives container removal
- ✅ Data can be shared between containers
- ✅ Data is backed up on host machine
- ✅ Data persists through container updates

### Volumes vs Bind Mounts

| Feature | Volumes | Bind Mounts |
|---------|---------|------------|
| Managed | Docker managed | Manual path |
| Backup | Easy | Harder |
| Performance | Better | Good |
| Use Case | Production data | Development |

### Volume Storage Location

**Linux:**
```
/var/lib/docker/volumes/
```

**Docker Desktop (Windows/Mac):**
```
Managed by Docker VM
Typically in Docker Desktop data folder
```

---

## ✅ Task 7 Checklist

- [ ] Created volume `mydata` successfully
- [ ] Listed volumes with `docker volume ls`
- [ ] Inspected volume with `docker volume inspect`
- [ ] Ran container with volume mounted
- [ ] Created file inside volume directory
- [ ] Exited container shell
- [ ] Verified file exists with `cat`
- [ ] Inspected container to see mount details
- [ ] Removed container (volume still intact)
- [ ] Created new container with same volume
- [ ] Verified data persistence (file still exists!)
- [ ] Cleaned up container and volume

---

## 🎓 Learning Outcomes

After completing Task 7, you should understand:

1. ✓ How to create and manage Docker volumes
2. ✓ How to mount volumes to containers
3. ✓ How data persists independently of containers
4. ✓ How to verify volume contents
5. ✓ How to clean up volumes properly
6. ✓ The importance of volumes for production workloads

---

## 🔗 Real-World Applications

### Database Persistence
```bash
# PostgreSQL with persistent storage
docker run -d \
  -v postgres-data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=secret \
  postgres:latest
```

### Application Data
```bash
# Apache web server with persistent documents
docker run -d \
  -v webapp-data:/usr/local/apache2/htdocs \
  -p 80:80 \
  httpd
```

### Log Persistence
```bash
# Application with persistent logs
docker run -d \
  -v app-logs:/var/log/myapp \
  myapp:latest
```

---

## 📚 Related Tasks

After completing all tasks:
- [ ] Task 5 - Container Operations & File Transfer
- [ ] Task 6 - File Management in Containers
- [ ] **Task 7 - Volume Persistence** ✓
- [ ] Task 8 - Multi-Container Networks (Coming Soon)

