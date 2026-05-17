# CI/CD Pipeline with Docker & GitHub Actions

A complete, production-ready CI/CD pipeline that automates building, testing, and deploying a full-stack application.

## 📁 Project Structure

```
GitP5/
├── frontend/                  # Node.js React/Express App
│   ├── package.json
│   ├── server.js
│   └── Dockerfile
├── backend/                   # Spring Boot Application
│   ├── pom.xml
│   ├── src/
│   │   └── main/java/
│   │       └── com/example/
│   │           └── Application.java
│   └── Dockerfile
├── docker-compose.yml         # Orchestration for local development
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # GitHub Actions Pipeline
└── README.md
```

## 🚀 Features

✅ **Automated CI/CD Pipeline** - Triggers on every git push  
✅ **Multi-stage Build** - Frontend & Backend built separately  
✅ **Docker Integration** - Containerizes both services  
✅ **Docker Compose** - Orchestrates all services locally  
✅ **Health Checks** - Validates services after deployment  
✅ **Production Ready** - SSH deployment hooks included  

## 🐳 Services

| Service | Port | Technology |
|---------|------|------------|
| Frontend | 3000 | Node.js + Express |
| Backend | 8080 | Spring Boot 3.0 |
| Database | 3306 | MySQL 8 |

## 🔧 Local Setup

### Prerequisites
- Docker & Docker Compose installed
- Node.js 18+ (for local testing)
- Java 17+ (for local Maven builds)
- Git

### Build & Run Locally

```bash
# Clone repository
git clone https://github.com/your-username/repo.git
cd GitP5

# Build and start all services
docker-compose up --build

# Services will be available at:
# Frontend: http://localhost:3000
# Backend: http://localhost:8080/api/health
# Database: localhost:3306
```

### Stop Services

```bash
docker-compose down
```

## 🔄 CI/CD Pipeline Flow

```
┌─────────────────┐
│   Git Push      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  GitHub Actions │
└────────┬────────┘
         │
    ┌────┴────┬──────────┐
    ▼         ▼          ▼
┌────────┐ ┌──────┐ ┌────────┐
│Frontend│ │Backend│ │ Docker │
│ Build  │ │ Build │ │ Build  │
└────┬───┘ └──┬───┘ └───┬────┘
     └────┬───┴────┬────┘
          ▼        ▼
    ┌────────────────────┐
    │ Docker Compose Up  │
    └────────┬───────────┘
             ▼
    ┌────────────────────┐
    │  Health Checks     │
    └────────┬───────────┘
             ▼
    ┌────────────────────┐
    │ ✅ Success/❌ Fail  │
    └────────────────────┘
```

## 📋 Pipeline Steps

### 1. Checkout Code
Pulls the latest code from the repository

### 2. Frontend Build
- Sets up Node.js 18
- Installs dependencies: `npm install`
- Builds the project: `npm run build`

### 3. Backend Build
- Sets up Java 17
- Compiles with Maven: `mvn clean package`
- Creates executable JAR file

### 4. Docker Build
- Builds Docker image for frontend
- Builds Docker image for backend

### 5. Docker Compose
- Starts all services (frontend, backend, database)
- Maintains network connectivity between services

### 6. Health Checks
- Validates frontend is responsive
- Validates backend API is healthy
- Database connectivity verified via backend

## 🌐 Pushing Code from VS Code

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial CI/CD setup"

# Rename branch to main
git branch -M main

# Add remote repository
git remote add origin https://github.com/your-username/repo.git

# Push to GitHub
git push -u origin main
```

## 🔐 Production Deployment (Advanced)

To deploy to your own server via SSH, uncomment the deployment step in `.github/workflows/ci-cd.yml`:

### 1. Add GitHub Secrets

In your GitHub repository settings, add:
- `HOST` - Your server IP/domain
- `USER` - SSH username
- `SSH_KEY` - Private SSH key

### 2. The Deployment Step

```yaml
- name: Deploy to Server
  uses: appleboy/ssh-action@v0.1.6
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USER }}
    key: ${{ secrets.SSH_KEY }}
    script: |
      cd /path/to/project
      git pull
      docker-compose down
      docker-compose up -d --build
```

## 📊 What Happens on Push

1. ✅ Code is pushed to `main` branch
2. ✅ GitHub Actions workflow triggers automatically
3. ✅ Frontend is built and containerized
4. ✅ Backend is compiled and containerized
5. ✅ Services start via Docker Compose
6. ✅ Health checks validate everything works
7. ✅ (Optional) Deploys to production server

## 🐛 Troubleshooting

**Pipeline Fails to Start?**
- Check `.github/workflows/ci-cd.yml` syntax
- Ensure branch is `main` (not `master`)

**Docker Build Fails?**
- Verify Dockerfiles are correct
- Check that source code compiles locally

**Health Checks Fail?**
- Increase wait time: `sleep 15` instead of `sleep 10`
- Check service logs: `docker-compose logs`

**Backend Not Starting?**
- Ensure `target/*.jar` exists (Maven build completed)
- Check database connection parameters

## 🤝 Contributing

1. Create feature branch: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -m "Add feature"`
3. Push to branch: `git push origin feature/your-feature`
4. Open Pull Request

Pipeline automatically runs on all PRs!

## 📄 License

MIT License - feel free to use this template for your projects

---

**Need Help?** Check the troubleshooting section or GitHub Actions logs
