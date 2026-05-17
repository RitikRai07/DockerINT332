# GitP5 CI/CD Architecture

## 🏗️ System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        Your Local Machine                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────┐        ┌──────────────────┐               │
│  │   VS Code IDE    │───────▶│  Git Repository  │               │
│  │  • Edit Code     │        │  • Track Changes │               │
│  │  • Test Changes  │        │  • Local commits │               │
│  └──────────────────┘        └────────┬─────────┘               │
│                                       │                          │
│  ┌──────────────────┐        ┌────────▼─────────┐               │
│  │  Docker Engine   │        │  Terminal/Shell  │               │
│  │  • Build images  │        │  git push origin │               │
│  │  • Run containers│        │       main       │               │
│  │  • docker-compose│        └──────────────────┘               │
│  └──────────────────┘                                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ git push
                              │
┌─────────────────────────────────────────────────────────────────┐
│                         GitHub.com                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────────────────────────────────────────┐       │
│  │          GitHub Repository (your-repo)               │       │
│  │  • main branch                                        │       │
│  │  • .github/workflows/ci-cd.yml                        │       │
│  │  • Source code (frontend + backend)                   │       │
│  └────────────────────┬─────────────────────────────────┘       │
│                       │                                          │
│  ┌────────────────────▼──────────────────┐                      │
│  │    GitHub Actions Workflow Triggers   │                      │
│  │  • Listens for push to main branch     │                      │
│  │  • Creates job in GitHub runner        │                      │
│  └────────────────────┬─────────────────────┘                    │
│                       │                                          │
└───────────────────────┼──────────────────────────────────────────┘
                        │
                        │ Creates ephemeral runner
                        │
┌───────────────────────┬──────────────────────────────────────────┐
│           GitHub Actions Runner (ubuntu-latest)                  │
├───────────────────────┬──────────────────────────────────────────┤
│                       │                                           │
│  ┌──────────────────┐ │                                           │
│  │  Checkout Code   │──┘                                          │
│  └──────────────────┘                                             │
│           │                                                       │
│  ┌────────▼──────────────────┐                                    │
│  │   FRONTEND BUILD           │                                   │
│  │  • Setup Node.js 18        │                                   │
│  │  • npm install             │                                   │
│  │  • npm run build           │                                   │
│  └────────┬───────────────────┘                                   │
│           │                                                       │
│  ┌────────▼──────────────────┐                                    │
│  │   BACKEND BUILD            │                                   │
│  │  • Setup Java 17           │                                   │
│  │  • mvn clean package       │                                   │
│  │  • Creates app.jar         │                                   │
│  └────────┬───────────────────┘                                   │
│           │                                                       │
│  ┌────────▼──────────────────┐                                    │
│  │   DOCKER BUILD             │                                   │
│  │  • Build frontend image    │                                   │
│  │  • Build backend image     │                                   │
│  └────────┬───────────────────┘                                   │
│           │                                                       │
│  ┌────────▼──────────────────┐                                    │
│  │  DOCKER COMPOSE UP         │                                   │
│  │  • Start frontend (3000)   │                                   │
│  │  • Start backend (8080)    │                                   │
│  │  • Start database (3306)   │                                   │
│  └────────┬───────────────────┘                                   │
│           │                                                       │
│  ┌────────▼──────────────────┐                                    │
│  │   HEALTH CHECKS            │                                   │
│  │  • Test frontend endpoint  │                                   │
│  │  • Test backend /health    │                                   │
│  │  • Verify database up      │                                   │
│  └────────┬───────────────────┘                                   │
│           │                                                       │
│  ┌────────▼──────────────────┐                                    │
│  │   CLEANUP                  │                                   │
│  │  • docker-compose down     │                                   │
│  │  • Stop all containers     │                                   │
│  └────────────────────────────┘                                   │
│                                                                   │
│           ✅ PIPELINE COMPLETE ✅                                │
└───────────────────────────────────────────────────────────────────┘
```

---

## 📊 Data Flow

```
Developer Code
    │
    ├─ frontend/
    │   └─ server.js (Node.js Express)
    │
    ├─ backend/
    │   └─ Application.java (Spring Boot)
    │
    └─ docker-compose.yml
           │
           ▼
    Git Repository (Local)
           │
           ├─ git add .
           ├─ git commit
           └─ git push origin main
                  │
                  ▼
        GitHub Repository (Remote)
                  │
                  ▼
        GitHub Actions Triggered
                  │
        ┌─────────┼─────────┐
        │         │         │
        ▼         ▼         ▼
    Frontend  Backend   Docker Build
    Build     Build
        │         │         │
        └─────────┼─────────┘
                  │
                  ▼
        Docker Compose Up
           (All Services)
                  │
        ┌─────────┼─────────┐
        │         │         │
        ▼         ▼         ▼
    Frontend  Backend   MySQL
    :3000     :8080    :3306
                  │
                  ▼
        Health Checks (Pass/Fail)
                  │
                  ▼
        Pipeline Complete
            (Success ✅)
```

---

## 🔄 Service Dependencies

```
User Browser
    │
    ▼
┌─────────────────┐
│    Frontend     │ (Node.js + Express) :3000
│  • Serves HTML  │
│  • Calls API    │
└────────┬────────┘
         │
         ▼ HTTP Request
┌─────────────────────────┐
│      Backend API        │ (Spring Boot) :8080
│  • Processes requests   │
│  • Queries database     │
└─────────┬───────────────┘
          │
          ▼ SQL Query
┌─────────────────────────┐
│    MySQL Database       │ :3306
│  • Stores data          │
│  • CRUD operations      │
└─────────────────────────┘
```

---

## 🚀 CI/CD Pipeline States

```
State 1: Developer Pushes Code
─────────────────────────────
  Status: git push origin main
  Action: Code sent to GitHub
  Next: GitHub Actions Trigger


State 2: GitHub Actions Triggered
──────────────────────────────────
  Status: Workflow file detected
  Action: Runner spins up
  Next: Checkout code


State 3: Build Phase
──────────────────────
  Status: Compiling code
  Action: Frontend + Backend built
  Next: Docker images created


State 4: Docker Build Phase
─────────────────────────────
  Status: Creating containers
  Action: Images pushed to runner
  Next: Docker Compose starts


State 5: Runtime Phase
──────────────────────
  Status: Services running
  Action: Health checks validate
  Next: Cleanup or Deploy


State 6: Completion
──────────────────
  Status: ✅ Success or ❌ Failed
  Action: Logs available in GitHub
  Next: Repeat on next push
```

---

## 🌐 Network Architecture

```
┌─────────────────────────────────────┐
│     Docker Network: app-network     │
│                                     │
│  ┌──────────┐  ┌──────────┐        │
│  │ Frontend │  │ Backend  │        │
│  │ :3000    │  │ :8080    │        │
│  └──────────┘  └──────────┘        │
│        │            │              │
│        │ Calls API  │              │
│        └────────────┘              │
│            │                       │
│            ▼                       │
│        ┌──────────┐                │
│        │ MySQL DB │                │
│        │ :3306    │                │
│        └──────────┘                │
│                                     │
└─────────────────────────────────────┘
       │
       │ Exposed Ports
       │
  ┌────┴──────┬──────────┐
  ▼           ▼          ▼
localhost:  localhost: localhost:
  3000        8080       3306
```

---

## 📦 Container Images

```
Frontend Container
├─ Base: node:18
├─ Work Dir: /app
├─ Install: npm dependencies
├─ Build: npm run build
└─ Port: 3000

Backend Container
├─ Base: openjdk:17
├─ Work Dir: /app
├─ Dependency: target/*.jar
└─ Port: 8080

Database Container
├─ Base: mysql:8
├─ Env: MYSQL_ROOT_PASSWORD=root
├─ Database: appdb
└─ Port: 3306
```

---

## 🔐 Environment Variables

### Frontend (Node.js)
```
NODE_ENV=production
```

### Backend (Spring Boot)
```
SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/appdb
SPRING_DATASOURCE_USERNAME=root
SPRING_DATASOURCE_PASSWORD=root
```

### Database (MySQL)
```
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=appdb
```

---

## 📈 Scaling Architecture (Advanced)

For production, you could add:

```
┌──────────────────────────────────────┐
│      Load Balancer (Nginx/AWS)       │
└────────────────────┬─────────────────┘
                     │
         ┌───────────┼───────────┐
         │           │           │
         ▼           ▼           ▼
    Frontend #1  Frontend #2  Frontend #3
         │           │           │
         └───────────┼───────────┘
                     │
         ┌───────────┼───────────┐
         │           │           │
         ▼           ▼           ▼
    Backend #1   Backend #2   Backend #3
         │           │           │
         └───────────┼───────────┘
                     │
      ┌──────────────┴──────────────┐
      ▼                             ▼
   MySQL Master            MySQL Replica
   (Write)                 (Read)
```

But for now, single containers per service is perfect for learning!

---

## ✅ Everything is Set Up!

Your GitP5 project now has:
- ✅ Complete frontend + backend applications
- ✅ Dockerfiles for containerization
- ✅ Docker Compose for local development
- ✅ GitHub Actions CI/CD pipeline
- ✅ Automatic builds on push
- ✅ Health checks & validation

**Next: Push to GitHub and watch the magic happen! 🚀**
