# 🐳 Docker Practical Exercises - Container Operations & File Transfer

## Overview

This guide covers practical hands-on exercises for Docker container management, file operations, and data persistence. Follow each task step-by-step to master Docker fundamentals.

---

## 📊 Workflow Diagram - Container File Operations

```
┌─────────────────────────────────────────────────────────────┐
│                   FILE TRANSFER WORKFLOW                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  HOST MACHINE                    CONTAINER                  │
│  ┌─────────────┐                ┌──────────────┐           │
│  │ test.txt    │  docker cp     │ /data/       │           │
│  │ sample.txt  │─────────────→  │ test.txt     │           │
│  │ report.txt  │                │ sample.txt   │           │
│  └─────────────┘                └──────────────┘           │
│                                                              │
│  ┌─────────────┐                ┌──────────────┐           │
│  │ /Desktop    │  docker exec   │ /bin/bash    │           │
│  │ receive     │←─────────────  │ ls /data     │           │
│  └─────────────┘                └──────────────┘           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📌 Task 5 – Working with Docker Containers and File Transfer

Complete file transfer operations between host and container.

### Prerequisites
- Docker running on your system
- A container ID (e.g., `dbcb6a49f493`)
- Files on your Desktop (or modify paths as needed)

### Step-by-Step Execution

#### 1️⃣ Start Docker Container

```bash
docker start dbcb6a49f493
```

**What it does:** Starts a previously stopped container using its container ID.

---

#### 2️⃣ List Root Directory inside Container

```bash
docker exec -it dbcb6a49f493 ls /
```

**Expected Output:**
```
bin     dev     etc     home    lib     media   mnt     opt
proc    root    run     sbin    srv     sys     tmp     usr     var
```

**What it does:** Shows the root filesystem structure of the running container.

---

#### 3️⃣ Open Bash Shell inside Container

```bash
docker exec -it dbcb6a49f493 /bin/bash
```

**What it does:** 
- `-i` (interactive) - Keep stdin open
- `-t` (tty) - Allocate a pseudo-terminal
- Provides full shell access inside the container

---

#### 4️⃣ Create Directory inside Container

```bash
# Inside container shell
mkdir /data
```

**Verification:**
```bash
ls -la / | grep data
```

---

#### 5️⃣ Create File inside Container

```bash
# Inside container shell
echo "Hello Docker" > /data/test.txt
```

**Verify file creation:**
```bash
cat /data/test.txt
```

---

#### 6️⃣ Exit Container Shell

```bash
exit
```

**What it does:** Exits the container shell and returns to host terminal.

---

#### 7️⃣ Copy File from Container to Host

```bash
# From HOST terminal (not in container)
docker cp dbcb6a49f493:/data/test.txt "C:\Users\rrai2\OneDrive\Desktop\"
```

**Syntax:** `docker cp <CONTAINER_ID>:<CONTAINER_PATH> <HOST_PATH>`

**What it does:** Copies the file `test.txt` from container's `/data/` directory to your Desktop.

---

#### 8️⃣ Copy File from Host to Container

First, create a test file on your Desktop (or use existing file):

```bash
# From HOST terminal
# Create test file (if it doesn't exist)
echo "Sample content from host" > "C:\Users\rrai2\OneDrive\Desktop\coco.txt"

# Copy to container
docker cp "C:\Users\rrai2\OneDrive\Desktop\coco.txt" dbcb6a49f493:/data/sample.txt
```

**Syntax:** `docker cp <HOST_PATH> <CONTAINER_ID>:<CONTAINER_PATH>`

**What it does:** Copies `coco.txt` from your Desktop and saves it as `sample.txt` inside container.

---

#### 9️⃣ Verify Files inside Container

```bash
docker exec -it dbcb6a49f493 ls /data
```

**Expected Output:**
```
sample.txt
test.txt
```

---

#### 🔟 Display File Content

```bash
docker exec -it dbcb6a49f493 cat /data/sample.txt
```

**Expected Output:**
```
Sample content from host
```

---

## 📊 Task 5 Summary Diagram

```
Task 5 Workflow:
┌──────────┐
│ START    │
└────┬─────┘
     │
     ▼
┌────────────────────────────┐
│ docker start (container)   │
└────┬───────────────────────┘
     │
     ▼
┌────────────────────────────┐
│ docker exec (verify ls /)  │
└────┬───────────────────────┘
     │
     ▼
┌────────────────────────────┐
│ bash shell in container    │
└────┬───────────────────────┘
     │
     ├─→ mkdir /data
     ├─→ echo "Hello Docker" > /data/test.txt
     └─→ exit
     │
     ▼
┌────────────────────────────┐
│ docker cp (copy to host)   │
└────┬───────────────────────┘
     │
     ▼
┌────────────────────────────┐
│ docker cp (copy to container)│
└────┬───────────────────────┘
     │
     ▼
┌────────────────────────────┐
│ Verify with ls & cat       │
└────┬───────────────────────┘
     │
     ▼
┌──────────┐
│ COMPLETE │
└──────────┘
```

---

## 📌 Task 6 – Creating and Managing Files in Docker Container

Extended file management operations in Docker containers.

### Prerequisites
- Container from Task 5 still running (or use any running container)
- Access to Desktop directory

### Step-by-Step Execution

#### 1️⃣ Create Project Directory

```bash
# Inside container shell (if not already in, use: docker exec -it dbcb6a49f493 /bin/bash)
mkdir /project
```

---

#### 2️⃣ Create File inside Project Folder

```bash
# Inside container
echo "Hello Docker" > /project/report.txt
```

**Verify:**
```bash
cat /project/report.txt
```

**Output:**
```
Hello Docker
```

---

#### 3️⃣ Exit Container Shell

```bash
exit
```

---

#### 4️⃣ Copy File from Container to Host

```bash
# From HOST terminal
docker cp dbcb6a49f493:/project/report.txt "C:\Users\rrai2\OneDrive\Desktop\"
```

**Verification - Check your Desktop:**
```bash
# On Windows
dir "C:\Users\rrai2\OneDrive\Desktop\report.txt"

# Or open the file in text editor
```

---

#### 5️⃣ Copy File from Host to Container

```bash
# From HOST terminal
docker cp "C:\Users\rrai2\OneDrive\Desktop\coco.txt" dbcb6a49f493:/project/sample.txt
```

---

#### 6️⃣ Verify Project Directory

```bash
docker exec -it dbcb6a49f493 ls /project
```

**Expected Output:**
```
report.txt
sample.txt
```

---

#### 7️⃣ Display File Content

```bash
docker exec -it dbcb6a49f493 cat /project/sample.txt
```

**Output:**
```
Sample content from host
```

---

## 📊 File Structure After Tasks 5 & 6

```
Container Filesystem:
/
├── data/
│   ├── test.txt (created in container)
│   └── sample.txt (copied from host)
│
├── project/
│   ├── report.txt (created in container)
│   └── sample.txt (copied from host)
│
└── [other directories...]

Host Desktop:
C:\Users\rrai2\OneDrive\Desktop\
├── test.txt (copied from container data/)
├── report.txt (copied from container project/)
├── coco.txt (original file on host)
└── [other files...]
```

---

## ✅ Task 5 & 6 Checklist

- [ ] Container started successfully
- [ ] Verified root filesystem with `ls /`
- [ ] Created `/data` directory
- [ ] Created `/data/test.txt` file
- [ ] Copied file from container to host
- [ ] Copied file from host to container
- [ ] Verified files in container
- [ ] Displayed file contents
- [ ] Created `/project` directory
- [ ] Copied files between host and `/project` directory
- [ ] Completed all verifications

---

## 💡 Key Concepts

### docker exec Syntax
```
docker exec [OPTIONS] CONTAINER COMMAND

-i, --interactive   Keep STDIN open
-t, --tty          Allocate a pseudo-terminal
-it                Both flags combined (most common)
-d, --detach       Run in background
-u, --user         Run as specific user
```

### docker cp Syntax
```
docker cp [OPTIONS] SRC_PATH DEST_PATH

# Container to Host
docker cp CONTAINER:SRC_PATH HOST_PATH

# Host to Container
docker cp HOST_PATH CONTAINER:DEST_PATH

# Copy directories
docker cp -r CONTAINER:SRC_DIR HOST_DIR
```

### Common Use Cases

| Use Case | Command |
|----------|---------|
| Extract logs from container | `docker cp container:/var/log/app.log ./` |
| Deploy config file | `docker cp config.json container:/etc/app/` |
| Backup database file | `docker cp container:/data/db.sqlite ./backup/` |
| Copy entire directory | `docker cp -r container:/app ./app_backup` |

---

## 🔗 Next Steps

After completing Tasks 5 & 6, proceed to:
- **Task 7:** Docker Volume Persistence (see next section)
- **Task 8:** Multi-Container File Sharing
- **Practice:** Create custom files and transfer them between host and container

