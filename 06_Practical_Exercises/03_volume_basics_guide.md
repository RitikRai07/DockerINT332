# 📌 Task 6B – Docker Volume Management Basics

Practical guide to creating and managing Docker volumes with direct examples and verification steps.

---

## 🎯 Task Overview

Learn to create named volumes, list them, inspect details, and run containers with volume mounts. This is the foundation for understanding data persistence in Docker.

---

## 📊 Volume Management Workflow

```
┌─────────────────────────────────────────────┐
│      DOCKER VOLUME MANAGEMENT             │
├─────────────────────────────────────────────┤
│                                            │
│  1. CREATE VOLUME                         │
│     docker volume create ourvolume        │
│                  ↓                         │
│  2. LIST VOLUMES                          │
│     docker volume ls                      │
│                  ↓                         │
│  3. INSPECT VOLUME                        │
│     docker volume inspect ourvolume       │
│                  ↓                         │
│  4. RUN CONTAINER WITH VOLUME             │
│     docker run -v ourvolume:/usr/...      │
│                  ↓                         │
│  5. ACCESS DATA IN CONTAINER              │
│     Files automatically available         │
│                                            │
└─────────────────────────────────────────────┘
```

---

## 🚀 Step-by-Step Execution

### 1️⃣ Create Docker Volume

Create a named volume that Docker will manage:

```bash
docker volume create ourvolume
```

**What it does:**
- Creates a new named volume called `ourvolume`
- Docker automatically manages storage location
- Volume ready to be mounted to containers

**Expected Output:**
```
ourvolume
```

**Explanation:**
```
docker volume create <volume-name>

where:
  <volume-name> = "ourvolume" (custom name you choose)
```

---

### 2️⃣ List All Volumes

View all volumes on your system:

```bash
docker volume ls
```

**Expected Output (example):**
```
DRIVER    VOLUME NAME
local     ourvolume
local     mydata
local     backup-volume
local     [other volumes...]
```

**Output Interpretation:**

| Column | Meaning |
|--------|---------|
| **DRIVER** | Storage driver type (usually "local") |
| **VOLUME NAME** | Name of the volume |

**Filter Specific Volume:**
```bash
docker volume ls --filter name=ourvolume
```

**Expected Output:**
```
DRIVER    VOLUME NAME
local     ourvolume
```

---

### 3️⃣ Inspect Volume

Get detailed information about your volume:

```bash
docker volume inspect ourvolume
```

**Expected Output (detailed JSON):**
```json
[
  {
    "CreatedAt": "2024-03-12T10:30:45.123456Z",
    "Driver": "local",
    "Labels": {},
    "Mountpoint": "/var/lib/docker/volumes/ourvolume/_data",
    "Name": "ourvolume",
    "Options": {},
    "Scope": "local"
  }
]
```

**Understanding the Output:**

| Field | Explanation | Example Value |
|-------|-------------|---------------|
| **CreatedAt** | When volume was created | 2024-03-12T10:30:45Z |
| **Driver** | Storage driver | local |
| **Mountpoint** | Physical location on host | /var/lib/docker/volumes/ourvolume/_data |
| **Name** | Volume identifier | ourvolume |
| **Scope** | Accessibility level | local (single machine) |
| **Labels** | Custom metadata | {} (empty unless added) |

---

## 🐳 Run Container with Volume

### 4️⃣ Option A: Apache HTTP Server

Create and run Apache container with volume mount:

```bash
docker run -d \
  -v ourvolume:/usr/local/apache2/htdocs \
  --name naughty_borg \
  httpd
```

**Breaking down the command:**

```bash
docker run                          # Create and run container
  -d                                # Detached (background)
  -v ourvolume:/usr/local/apache2/htdocs  # Mount volume
     ↑                   ↑
     volume name         mount point in container
  --name naughty_borg    # Container name
  httpd                  # Image to use (Apache)
```

**Volume Mount Explanation:**
- `ourvolume` - Volume on host (already created)
- `/usr/local/apache2/htdocs` - Where it mounts in container (Apache's document root)
- Everything placed in this directory persists in the volume

**Verification:**
```bash
docker ps
```

**Expected Output:**
```
CONTAINER ID   IMAGE    COMMAND              STATUS
abc123def456   httpd    "httpd-foreground"   Up 2 seconds
```

---

### 4️⃣ Option B: Ubuntu Container (Alternative)

If you prefer Ubuntu instead of Apache:

```bash
docker run -dit \
  --name ubuntu_container \
  -v ourvolume:/app/data \
  ubuntu bash
```

**Command explanation:**
```
-d    Detached (background)
-i    Interactive (keep stdin open)
-t    Terminal (allocate pseudo-terminal)
-dit  Combined (interactive terminal in background)
```

---

## 📍 Common Volume Mount Points for Popular Containers

| Container | Mount Point | Purpose |
|-----------|------------|---------|
| **Apache (httpd)** | `/usr/local/apache2/htdocs` | Web documents |
| **Nginx** | `/usr/share/nginx/html` | Web server files |
| **PostgreSQL** | `/var/lib/postgresql/data` | Database data |
| **MySQL** | `/var/lib/mysql` | Database data |
| **Ubuntu/Debian** | `/app` or `/data` | General data storage |
| **Node.js** | `/app` | Application code |
| **MongoDB** | `/data/db` | Database data |

---

## ✅ Verification Steps

### Verify Container is Running

```bash
docker ps
```

**Look for your container in the output:**
```
CONTAINER ID   IMAGE   COMMAND   ...   NAMES
abc123...      httpd   "httpd"   ...   naughty_borg
```

---

### Verify Volume is Mounted

```bash
docker inspect naughty_borg | grep -A 10 Mounts
```

**Expected Output:**
```json
"Mounts": [
  {
    "Type": "volume",
    "Name": "ourvolume",
    "Source": "/var/lib/docker/volumes/ourvolume/_data",
    "Destination": "/usr/local/apache2/htdocs",
    "Driver": "local",
    "Mode": "z",
    "RW": true,
    "Propagation": ""
  }
]
```

**Mount Details:**
- **Type**: "volume" = Named volume
- **Name**: ourvolume = Our volume
- **Source**: Host-side storage location
- **Destination**: Container-side mount point
- **RW**: true = Read and Write enabled

---

### Check Volume Contents from Container

For Apache container:
```bash
docker exec naughty_borg ls /usr/local/apache2/htdocs
```

**Expected Output (if empty):**
```
(no output = directory is empty)
```

For Ubuntu container:
```bash
docker exec ubuntu_container ls /app/data
```

---

## 📝 Complete Example: Step-by-Step

### Scenario: Set up Apache with shared volume

**Step 1: Create Volume**
```bash
docker volume create ourvolume
```

**Step 2: Verify Creation**
```bash
docker volume ls | grep ourvolume
```

**Step 3: Run Apache**
```bash
docker run -d \
  -v ourvolume:/usr/local/apache2/htdocs \
  --name naughty_borg \
  httpd
```

**Step 4: Verify Container**
```bash
docker ps | grep naughty_borg
```

**Step 5: Check Volume Mount**
```bash
docker inspect naughty_borg | grep -A 5 Mounts
```

**Step 6: List Mount Directory in Container**
```bash
docker exec naughty_borg ls /usr/local/apache2/htdocs
```

**✓ Complete!** Volume is now mounted and ready to use.

---

## 📊 Visual: Volume Mounting Process

```
Create Volume
    ↓
┌─────────────────────────┐
│   ourvolume (Host)      │
│  Location: /var/lib/    │
│  Status: Ready to mount │
└────────┬────────────────┘
         │
         │ Mount via -v flag
         │
         ▼
┌─────────────────────────────────────────┐
│     Docker Container (naughty_borg)     │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ /usr/local/apache2/htdocs       │   │
│  │ (mounted from ourvolume)        │   │
│  │ Files here persist in volume    │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

## 🔗 Interactive Volume Operations

### Create HTML File on Host

Create an index.html file on your host machine:

```bash
# Windows (PowerShell)
"<h1>Hello from Volume!</h1>" | Out-File "index.html" -Encoding UTF8

# Linux/Mac
echo "<h1>Hello from Volume!</h1>" > index.html
```

### Copy to Container Volume

```bash
docker cp index.html naughty_borg:/usr/local/apache2/htdocs/
```

### Access Through Web Browser

```
http://localhost:80
```

**Expected:** See "Hello from Volume!" displayed

---

## 🧹 Cleanup Operations

### List Running Containers

```bash
docker ps
```

### Stop Container

```bash
docker stop naughty_borg
```

### Remove Container

```bash
docker rm naughty_borg
```

### Verify Container Removed

```bash
docker ps -a | grep naughty_borg
# (no output = removed)
```

### Keep Volume After Container Removal

The volume `ourvolume` is still there:

```bash
docker volume ls | grep ourvolume
```

**Output:**
```
local     ourvolume
```

---

## 📋 Complete Commands Summary

```bash
# Create volume
docker volume create ourvolume

# List volumes
docker volume ls

# Inspect volume
docker volume inspect ourvolume

# Run container with volume
docker run -d -v ourvolume:/mount/path --name container-name image-name

# Verify container
docker ps

# Access container files
docker exec container-name ls /mount/path

# Remove container (keep volume)
docker rm -f container-name

# Remove volume
docker volume rm ourvolume

# Remove all unused volumes
docker volume prune
```

---

## 💡 Key Takeaways

1. **Named Volumes** - Docker-managed storage for containers
2. **Persistence** - Data survives container deletion
3. **Mounting** - Connect volume to container via mount point
4. **Inspection** - Always verify mounts with `docker inspect`
5. **Location Independence** - Container doesn't care where volume is stored

---

## 🎓 Understanding Mount Points

### What is a Mount Point?

A mount point is the **directory inside the container** where the volume gets attached.

```
Volume Path (Host):     /var/lib/docker/volumes/ourvolume/_data
                                    │
                                    │ (Docker manages mapping)
                                    │
Mount Point (Container): /usr/local/apache2/htdocs
```

### Choosing Mount Points

```bash
# Apache - web documents
docker run -v ourvolume:/usr/local/apache2/htdocs httpd

# Database - data storage  
docker run -v ourvolume:/var/lib/postgresql/data postgres

# General - app directory
docker run -v ourvolume:/app ubuntu bash

# Custom - your choice
docker run -v ourvolume:/my/custom/path ubuntu bash
```

---

## 🔄 Multiple Volumes on Single Container

Mount multiple volumes in one container:

```bash
docker run -d \
  -v volume1:/mount1 \
  -v volume2:/mount2 \
  -v volume3:/mount3 \
  --name multi-volume-container \
  ubuntu bash
```

**Access in container:**
```bash
docker exec multi-volume-container ls /mount1 /mount2 /mount3
```

---

## ⚠️ Common Mistakes to Avoid

### ❌ Wrong: Volume doesn't exist
```bash
# This will FAIL
docker run -v nonexistent-volume:/app ubuntu
```

### ✅ Right: Create volume first
```bash
docker volume create myvolume
docker run -v myvolume:/app ubuntu
```

---

### ❌ Wrong: Forgetting volume name
```bash
# Missing volume name
docker run -v :/app ubuntu  # ERROR
```

### ✅ Right: Include both volume name and path
```bash
docker run -v myvolume:/app ubuntu
```

---

## ✅ Task 6B Checklist

- [ ] Created volume `ourvolume` successfully
- [ ] Listed volumes with `docker volume ls`
- [ ] Inspected volume with `docker volume inspect`
- [ ] Ran container with volume mounted
- [ ] Verified container is running with `docker ps`
- [ ] Checked mount details with `docker inspect`
- [ ] Accessed volume directory in container
- [ ] Verified volume persistence
- [ ] Successfully cleaned up resources

---

## 🎯 Next Steps

After mastering volume basics:

1. **Try Different Mount Points** - Use various paths
2. **Share Volumes** - Mount same volume to multiple containers
3. **Practice Persistence** - See Task 7 in [02_volume_persistence.md](02_volume_persistence.md)
4. **Real Applications** - Use volumes with databases
5. **Backup Strategies** - Learn to backup volume data

---

## 🔗 Related Documentation

- [Docker Volumes Official Guide](https://docs.docker.com/storage/volumes/)
- [Volume Command Reference](https://docs.docker.com/engine/reference/commandline/volume/)
- [Container Interaction Guide](../../02_Container_Interaction/container_host_interaction.md)
- [Volume Commands Quick Reference](../../03_Docker_Volumes/volume_commands.md)

---

**Difficulty Level:** ⭐ Beginner
**Estimated Time:** 15-20 minutes
**Prerequisites:** Docker installed, basic container knowledge

Happy Learning! 🎉

