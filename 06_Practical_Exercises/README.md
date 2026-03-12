# 🐳 Docker Practical Exercises - Complete Course

Comprehensive hands-on Docker training covering container operations, file transfer, and volume management.

---

## 📚 Course Overview

This practical exercises section provides real-world Docker tasks with step-by-step instructions, diagrams, and verification methods. Build your Docker skills through hands-on practice.

---

## 🎯 Course Structure

```
06_Practical_Exercises/
├── 00_quick_reference.md           ← START HERE for overview
├── 01_container_operations_file_transfer.md
├── 02_volume_persistence.md        
├── 03_volume_basics_guide.md       
└── README.md                        ← You are here
```

---

## 📖 What You'll Learn

### ✅ Container Operations (Task 5)
- Start and manage Docker containers
- Execute commands inside containers with `docker exec`
- Navigate container filesystem
- Create directories and files inside containers
- Work with container shells

### ✅ File Transfer (Tasks 5 & 6A)
- Copy files from container to host
- Copy files from host to container  
- Transfer entire directories
- Verify file transfers
- Troubleshoot transfer issues

### ✅ Volume Basics (Task 6B)
- Create named volumes
- List and inspect volumes
- Mount volumes to containers
- Understand volume storage locations
- Use volumes in production scenarios

### ✅ Volume Persistence (Task 7)
- Create persistent storage
- Understand data persistence
- Share volumes between containers
- Survive container deletion
- Clean up volumes properly

---

## 🚀 Quick Start Guide

### For Complete Beginners
1. Open [00_quick_reference.md](00_quick_reference.md) - Get oriented
2. Read [01_container_operations_file_transfer.md](01_container_operations_file_transfer.md) - Task 5 & 6A
3. Follow [03_volume_basics_guide.md](03_volume_basics_guide.md) - Task 6B
4. Complete [02_volume_persistence.md](02_volume_persistence.md) - Task 7

### For Intermediate Users
- Jump to specific tasks based on your needs
- All files are self-contained with examples
- Use [00_quick_reference.md](00_quick_reference.md) as command cheatsheet

### For Learning Specific Topics
- **File Transfer?** → [01_container_operations_file_transfer.md](01_container_operations_file_transfer.md)
- **Volume Basics?** → [03_volume_basics_guide.md](03_volume_basics_guide.md)
- **Data Persistence?** → [02_volume_persistence.md](02_volume_persistence.md)
- **Need commands?** → [00_quick_reference.md](00_quick_reference.md)

---

## 📋 Task Breakdown

### Task 5: Container Operations & File Transfer ⭐ START HERE

**File:** [01_container_operations_file_transfer.md](01_container_operations_file_transfer.md)

**Topics Covered:**
- Container startup and management
- Executing commands in containers
- File and directory creation
- File transfer between container and host
- Verification and testing

**Duration:** 20-30 minutes
**Level:** Beginner
**Prerequisites:** Docker installed, basic terminal knowledge

**Key Commands:**
```bash
docker start <container-id>
docker exec -it <container-id> /bin/bash
docker cp <source> <destination>
```

---

### Task 6A: File Management in Containers

**File:** [01_container_operations_file_transfer.md](01_container_operations_file_transfer.md) (Part 2)

**Topics Covered:**
- Advanced directory structure
- Project directory management
- Bulk file operations
- File organization best practices

**Duration:** 15-20 minutes
**Level:** Beginner
**Prerequisites:** Completed Task 5

---

### Task 6B: Volume Basics (Creation & Management)

**File:** [03_volume_basics_guide.md](03_volume_basics_guide.md)

**Topics Covered:**
- Named volume creation
- Volume listing and inspection
- Container mounting
- Mount point understanding
- Multiple volume management

**Duration:** 15-20 minutes
**Level:** Beginner
**Prerequisites:** Basic Docker knowledge

**Key Commands:**
```bash
docker volume create <name>
docker volume ls
docker volume inspect <name>
docker run -v <volume>:<mount-point>
```

---

### Task 7: Volume Persistence & Data Survival ⭐ ADVANCED

**File:** [02_volume_persistence.md](02_volume_persistence.md)

**Topics Covered:**
- Volume persistence demonstration
- Container removal while keeping data
- Reattaching volumes to new containers
- Data integrity verification
- Production-ready cleanup

**Duration:** 25-30 minutes
**Level:** Intermediate
**Prerequisites:** Tasks 5 & 6B completed

**Key Concept:**
Data survives container deletion with volumes - this is critical for production!

---

## 🎓 Learning Objectives

By completing all tasks, you will be able to:

- [ ] Start and manage Docker containers effectively
- [ ] Execute commands inside running containers
- [ ] Transfer files bidirectionally between host and container
- [ ] Create and manage Docker named volumes
- [ ] Mount volumes to containers with correct syntax
- [ ] Understand data persistence concepts
- [ ] Verify data persistence across container lifecycles
- [ ] Configure production-ready storage solutions
- [ ] Troubleshoot common volume and file transfer issues
- [ ] Apply best practices for Docker file management

---

## 💻 System Requirements

### Minimum Requirements
- Docker Engine 20.10+
- 2GB RAM
- Terminal/Command Prompt access
- 1GB free disk space

### Recommended
- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- 4GB+ RAM
- 5GB free disk space
- Linux or Windows Subsystem for Linux

### Supported Platforms
- ✅ Linux (any distribution)
- ✅ macOS (Intel and Apple Silicon)
- ✅ Windows 10/11 with Docker Desktop
- ✅ Oracle VirtualBox with Docker

---

## 🔧 Setup Instructions

### Verify Docker Installation

```bash
docker --version
```

**Expected Output:**
```
Docker version 20.10.x, build ...
```

### Pull Required Images

```bash
# Ubuntu image (for Tasks 5-7)
docker pull ubuntu

# Apache/httpd image (for Task 6B)
docker pull httpd

# Optional: Other images
docker pull nginx
docker pull postgres
```

### Verify Images Downloaded

```bash
docker images
```

---

## 📊 Workflow Diagrams

### Complete Learning Path

```
START
  │
  ├─→ SETUP: Install Docker
  │   └─→ Verify installation
  │       └─→ Pull images
  │
  ├─→ TASK 5: Container Operations
  │   ├─→ Start container
  │   ├─→ Execute commands
  │   ├─→ Create files/dirs
  │   └─→ Verify - ✓ PASS?
  │       ├─→ YES: Continue →
  │       └─→ NO: Review guide
  │
  ├─→ TASK 6A: File Management  
  │   ├─→ Create project dir
  │   ├─→ Transfer files
  │   └─→ Verify - ✓ PASS?
  │       └─→ YES: Continue →
  │
  ├─→ TASK 6B: Volume Basics
  │   ├─→ Create volume
  │   ├─→ Mount to container
  │   └─→ Verify - ✓ PASS?
  │       └─→ YES: Continue →
  │
  ├─→ TASK 7: Volume Persistence
  │   ├─→ Create data
  │   ├─→ Remove container
  │   ├─→ Verify persistence
  │   └─→ Verify - ✓ PASS?
  │       └─→ YES: Continue →
  │
  ├─→ PRACTICE: Reinforce learning
  │   ├─→ Repeat tasks
  │   ├─→ Try variations
  │   └─→ Explore edge cases
  │
  └─→ COMPLETE! 🎉
```

---

## 🎯 Success Criteria

You've successfully learned when you can:

### Task 5 Success
- ✅ Start any container by ID
- ✅ List files inside container without error
- ✅ Create files/directories in container
- ✅ Copy files container→host successfully
- ✅ Copy files host→container successfully

### Task 6 Success
- ✅ Organize files in multiple directories
- ✅ Handle bulk file transfers
- ✅ Maintain directory structure
- ✅ Verify file operations

### Task 6B Success
- ✅ Create named volumes
- ✅ Inspect volume details
- ✅ Mount multiple volumes
- ✅ Understand mount points

### Task 7 Success
- ✅ Explain data persistence
- ✅ Remove container without losing data
- ✅ Reattach volume to new container
- ✅ Verify data integrity
- ✅ Clean up properly

---

## 📚 File Navigation Guide

### 🎯 Quick Reference & Cheatsheets
**[00_quick_reference.md](00_quick_reference.md)**
- Command cheatsheet
- Workflow diagrams  
- Common issues & solutions
- Pro tips and tricks
- Success metrics

### 🐳 Hands-On Tasks
**[01_container_operations_file_transfer.md](01_container_operations_file_transfer.md)**
- Task 5 complete walkthrough
- Task 6A extended examples
- Detailed explanations
- Verification steps
- Real-world use cases

**[03_volume_basics_guide.md](03_volume_basics_guide.md)**
- Task 6B step-by-step
- Volume creation & management
- Mount point understanding
- Multiple volumes
- Common mistakes

**[02_volume_persistence.md](02_volume_persistence.md)**
- Task 7 complete guide
- Persistence demonstration
- Lifecycle management
- Cleanup procedures
- Production scenarios

---

## ⚠️ Common Challenges & Solutions

### "Command Not Found"
**Issue:** Docker commands not recognized
```bash
# Solution: Check Docker is installed and running
docker ps
```

### "No Such Container"
**Issue:** Container ID doesn't exist
```bash
# Solution: Check container list
docker ps -a | grep <container-name>
```

### "Permission Denied"
**Issue:** Cannot access Docker (Linux/Mac)
```bash
# Solution: Add current user to docker group
sudo usermod -aG docker $USER
```

### "Volume Already Exists"
**Issue:** Cannot create volume - name taken
```bash
# Solution: Use different name or remove existing
docker volume rm <old-name>
docker volume create <new-name>
```

See [00_quick_reference.md](00_quick_reference.md) for more solutions.

---

## 🔗 Integration with Other Modules

These practical exercises connect with:

- **[01_Docker_Basics](../../01_Docker_Basics/)** - Foundational concepts
- **[02_Container_Interaction](../../02_Container_Interaction/)** - Container communication
- **[03_Docker_Volumes](../../03_Docker_Volumes/)** - Volume theory
- **[04_Docker_Projects](../../04_Docker_Projects/)** - Real project examples
- **[05_Practice_Questions](../../05_Practice_Questions/)** - Self-assessment

---

## 🎓 Progression Path

```
Beginner                Intermediate              Advanced
   │                        │                        │
   ├─→ Task 5 ✓            │                        │
   │                        │                        │
   ├─→ Task 6A ✓          │                        │
   │                        │                        │
   ├─→ Task 6B ✓          ├─→ Real Projects       ├─→ Orchestration
   │                        │                        │
   └─→ Task 7 ✓           ├─→ Multi-Container     ├─→ Cloud Deploy
                           │                        │
                           └─→ Persistence        └─→ Scale & Monitor
```

---

## 📞 Getting Help

### If You Get Stuck

1. **Check Quick Reference** - [00_quick_reference.md](00_quick_reference.md)
2. **Review Task Section** - Specific task file
3. **Verify System Setup** - Confirm Docker is running
4. **Check Common Issues** - Most problems listed in guides
5. **Consult Official Docs** - Docker documentation links provided

### Recommended Resources

- [Official Docker Documentation](https://docs.docker.com/)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/)
- [Volume Storage Guide](https://docs.docker.com/storage/)
- [Container Networking](https://docs.docker.com/network/)

---

## ✅ Pre-Task Checklist

Before starting any task, confirm:

- [ ] Docker is installed: `docker --version`
- [ ] Docker is running: `docker ps`
- [ ] Bash/Terminal access available
- [ ] At least 1GB free disk space
- [ ] Required images pulled (Ubuntu, httpd)
- [ ] Sufficient time available (20-30 min per task)
- [ ] Read the current task completely before starting

---

## 🎯 Recommended Study Schedule

### Option 1: Complete in One Session (2-3 hours)
- Task 5: 30 min
- Task 6A: 20 min
- Task 6B: 20 min
- Task 7: 30 min
- Review & Practice: 30 min

### Option 2: Daily Practice (One Week)
- Day 1: Task 5 + Review
- Day 2: Task 5 Practice + Task 6A
- Day 3: Task 6A Practice  
- Day 4: Task 6B + Review
- Day 5: Task 6B Practice
- Day 6: Task 7 + Review
- Day 7: Task 7 Practice + Complete Reviews

### Option 3: Self-Paced (Flexible)
- Complete one task when ready
- Practice between tasks
- Review materials as needed
- No time pressure

---

## 🏆 Completion Certificate

After completing all tasks and practice:

**Congratulations! You have mastered:**
- Docker container management
- File transfer operations
- Volume persistence
- Docker storage best practices

**Next Learning Path:**
- [ ] Complete Practice Questions (05_Practice_Questions)
- [ ] Build Docker Projects (04_Docker_Projects)
- [ ] Learn Container Networking
- [ ] Docker Compose & Orchestration

---

## 📝 Session Notes Template

For each task session, record:

```
Task: ___________________
Date: ___________________
Duration: _______________

What I Learned:
- 
- 
- 

Challenges Faced:
- 
- 

Solutions Found:
- 
- 

Next Steps:
- 
- 
```

---

## 💡 Pro Tips for Success

1. **Type Commands** - Don't copy-paste; type to build muscle memory
2. **Modify Examples** - Change command parameters to understand behavior
3. **Take Notes** - Document discoveries and gotchas
4. **Experiment** - Try variations after basic examples work
5. **Review Diagrams** - Visual understanding aids retention
6. **Verify Each Step** - Don't skip verification commands
7. **Clean Up Properly** - Manage containers and volumes responsibly
8. **Read Error Messages** - They often explain the fix

---

## 🎉 Welcome to Docker Mastery!

You're about to embark on a comprehensive Docker learning journey. These practical exercises will transform your understanding from theory to hands-on expertise.

### Start with: [00_quick_reference.md](00_quick_reference.md)

Then progress through tasks in order. Good luck! 🚀

---

## 📞 File Organization

```
├── 00_quick_reference.md
│   └─ Command cheatsheet & quick guide
│
├── 01_container_operations_file_transfer.md
│   ├─ Task 5: Container Operations
│   ├─ Task 6A: File Management
│   └─ Examples & Diagrams
│
├── 02_volume_persistence.md
│   ├─ Task 7: Volume Persistence
│   ├─ Data Survival Demo
│   └─ Production Practices
│
├── 03_volume_basics_guide.md
│   ├─ Task 6B: Volume Basics
│   ├─ Volume Management
│   └─ Mount Points Guide
│
└── README.md
    └─ This file - Navigation & Overview
```

---

**Last Updated:** March 12, 2024
**Version:** 1.0
**Status:** Ready for Learning

Happy Docker Learning! 🐳✨

