# 🚀 Quick Start Guide - GitP5 CI/CD Pipeline

## ⚡ 5-Minute Setup

### Step 1: Open Terminal in GitP5 Folder
```bash
cd C:\Users\rrai2\OneDrive\Desktop\IMP Software\Devops\GitP5
```

### Step 2: Run Setup Script
**Windows:**
```bash
setup.bat
```

**Mac/Linux:**
```bash
bash setup.sh
```

This will:
- ✅ Initialize Git repository
- ✅ Add your GitHub URL as remote
- ✅ Configure your Git user
- ✅ Create initial commit

### Step 3: Push to GitHub
```bash
git push -u origin main
```

---

## 📋 Manual Setup (If Script Doesn't Work)

### Step 1: Initialize Git
```bash
git init
```

### Step 2: Configure User
```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### Step 3: Add Remote
```bash
git remote add origin https://github.com/YOUR-USERNAME/repo.git
```

### Step 4: Add & Commit
```bash
git add .
git commit -m "Initial CI/CD setup with Docker & GitHub Actions"
```

### Step 5: Rename to Main (if needed)
```bash
git branch -M main
```

### Step 6: Push to GitHub
```bash
git push -u origin main
```

---

## ✅ What's Included in GitP5

```
GitP5/
├── 📁 frontend/
│   ├── Dockerfile           (Node.js containerization)
│   ├── package.json         (Dependencies)
│   └── server.js            (Express app)
│
├── 📁 backend/
│   ├── Dockerfile           (Java containerization)
│   ├── pom.xml              (Maven config)
│   └── src/                 (Spring Boot app)
│
├── 📄 docker-compose.yml    (Full stack orchestration)
│
├── 📁 .github/workflows/
│   └── ci-cd.yml            (GitHub Actions pipeline)
│
├── 📄 README.md             (Full documentation)
├── 📄 setup.bat             (Windows setup)
├── 📄 setup.sh              (Linux/Mac setup)
└── 📄 .gitignore            (Git exclusions)
```

---

## 🔄 What Happens After You Push

1. **GitHub detects push** to main branch
2. **GitHub Actions triggers automatically**
3. **Pipeline runs:**
   - Frontend: Install deps → Build
   - Backend: Maven compile → JAR creation
   - Docker: Build images for both services
   - Docker Compose: Start all containers
   - Health Checks: Validate services are running

---

## 🌐 Test Locally (Before Pushing)

### Build & Run with Docker Compose
```bash
docker-compose up --build
```

### Access Services
- **Frontend:** http://localhost:3000
- **Backend:** http://localhost:8080/api/health
- **Database:** localhost:3306

### Stop Services
```bash
docker-compose down
```

---

## 🔐 Production Deployment (Optional)

### To Deploy to Your Own Server:

1. **Create GitHub Secrets** (in your repo settings):
   - `HOST` = Your server IP
   - `USER` = SSH username
   - `SSH_KEY` = Private SSH key

2. **Uncomment deployment step** in `.github/workflows/ci-cd.yml`

3. **On each push:** Your server automatically pulls & deploys

---

## 🐛 Troubleshooting

**Error: "fatal: not a git repository"**
```bash
git init
```

**Error: "Permission denied" on setup.sh**
```bash
chmod +x setup.sh
bash setup.sh
```

**Error: "fatal: destination path already exists"**
```bash
rm -rf .git
git init
```

**Pipeline not triggering?**
- Ensure you pushed to `main` branch (not `master`)
- Check `.github/workflows/ci-cd.yml` exists in repo
- Go to GitHub repo → Actions tab to see logs

---

## 📚 Next Steps

1. ✅ Run setup script
2. ✅ Push to GitHub
3. ✅ Go to `Actions` tab in GitHub repo
4. ✅ Watch pipeline execute in real-time
5. ✅ See `Summary` tab for results

---

## 🎯 Key Concepts

| Concept | What It Does |
|---------|---|
| **GitHub Actions** | Automatically runs pipeline when you push |
| **Dockerfile** | Defines how to containerize each service |
| **docker-compose** | Starts all containers together locally |
| **CI/CD** | Continuous Integration/Deployment automation |
| **Health Checks** | Validates services are working after deploy |

---

## 💡 Tips

- Push small, focused commits
- Write meaningful commit messages
- Check GitHub Actions logs if pipeline fails
- Use branches for features: `git checkout -b feature/my-feature`
- Create Pull Requests for team collaboration

---

**You're all set! 🎉 Push your code and watch GitHub Actions do the work!**
