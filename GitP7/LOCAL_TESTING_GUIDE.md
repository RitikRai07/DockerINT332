# 🧪 Local Testing Guide - Before Pushing to GitHub

## Why Test Locally First?

✅ Catch Dockerfile errors early
✅ Verify app works before CI/CD
✅ Test Docker configuration
✅ Ensure all dependencies are correct
✅ Saves time debugging on GitHub

---

## Step 1: Verify Docker Installation

```powershell
# Check Docker version
docker --version
# Expected: Docker version 20.10+ or newer

# Check if Docker daemon is running
docker ps
# If this fails, start Docker Desktop

# Check Docker Hub access
docker pull hello-world
docker rmi hello-world
# If this works, you're connected to Docker Hub
```

---

## Step 2: Build the Image Locally

Navigate to your Dockerclas directory and build:

```powershell
cd d:\6th sem\Devops\Dockerclas

# Verify Dockerfile exists
Test-Path ".\Dockerfile"
# Should show: True

# Verify app.py exists
Test-Path ".\app.py"
# Should show: True

# Build the image
docker build -t ritikrai07/app-ci:test .

# Expected output:
# Sending build context to Docker daemon
# Step 1/X : FROM python:3.11-slim
# ...
# Successfully built <image-id>
# Successfully tagged ritikrai07/app-ci:test
```

---

## Step 3: Verify Image Was Built

```powershell
# List images
docker images | Select-String "app-ci"

# Should show:
# REPOSITORY              TAG       IMAGE ID      CREATED        SIZE
# ritikrai07/app-ci       test      abc123def     1 minute ago    250MB
```

---

## Step 4: Run the Container

```powershell
# Run the image
docker run -d \
  --name test-app \
  -p 5000:5000 \
  -e APP_VERSION=1.0.0 \
  -e FLASK_ENV=production \
  ritikrai07/app-ci:test

# Expected output:
# <container-id>

# Verify container is running
docker ps | Select-String "test-app"
# Should show the container with status "Up X seconds"
```

---

## Step 5: Test Application Endpoints

Wait a moment for the app to start, then test:

```powershell
# Test home endpoint
curl http://localhost:5000/

# Expected output:
# {
#   "message": "Welcome to Docker CI/CD Pipeline!",
#   "version": "1.0.0",
#   "environment": "production"
# }

# Test health endpoint
curl http://localhost:5000/health

# Expected output:
# {
#   "status": "healthy",
#   "version": "1.0.0"
# }

# Test info endpoint
curl http://localhost:5000/api/info

# Expected output:
# {
#   "app": "Docker CI/CD Demo",
#   "version": "1.0.0",
#   "environment": "production",
#   "docker": "enabled"
# }
```

---

## Step 6: Check Container Logs

```powershell
# View application logs
docker logs test-app

# Expected output:
# Starting application v1.0.0 in production mode
# WARNING in app.run() This is a development server...
# Running on http://0.0.0.0:5000
```

---

## Step 7: Clean Up

```powershell
# Stop the container
docker stop test-app

# Remove the container
docker rm test-app

# (Optional) Remove the image
docker rmi ritikrai07/app-ci:test

# Verify cleanup
docker ps -a | Select-String "test-app"
# Should show no results
```

---

## ✅ Local Testing Checklist

After completing all steps, verify:

- [ ] Docker is installed and running
- [ ] `docker build` completed successfully
- [ ] Image appears in `docker images` list
- [ ] Container starts with `docker run`
- [ ] Container appears in `docker ps` as "Up"
- [ ] Home endpoint returns JSON
- [ ] Health endpoint returns healthy status
- [ ] Info endpoint returns app details
- [ ] Container logs show Flask running
- [ ] Cleanup succeeds (`docker stop`, `docker rm`)

---

## 🔧 Troubleshooting

### Issue 1: Docker daemon not running
```powershell
# Start Docker Desktop (usually auto-starts)
# Or if using Docker CLI directly:
# Restart Docker service
```

### Issue 2: Build fails - "Dockerfile not found"
```powershell
# Check file exists
dir Dockerfile

# Verify you're in correct directory
pwd
# Should show: .../Dockerclas

# Make sure you copied the file correctly
Test-Path ".\Dockerfile"
```

### Issue 3: Build fails - "Python dependencies error"
```powershell
# Check requirements.txt syntax
cat requirements.txt

# It should contain:
# Flask==3.0.0
# Werkzeug==3.0.1
# requests==2.31.0
# python-dotenv==1.0.0
```

### Issue 4: Container exits immediately
```powershell
# Check logs for errors
docker logs test-app

# Common issues:
# - Port 5000 already in use
# - Missing environment variables
# - Flask app crash
```

### Issue 5: Port 5000 already in use
```powershell
# Find what's using port 5000
netstat -ano | findstr :5000

# Kill the process (if needed)
taskkill /PID <process-id> /F

# Or use a different port
docker run -d -p 5001:5000 ritikrai07/app-ci:test
curl http://localhost:5001/
```

### Issue 6: curl command not found
```powershell
# Use PowerShell's equivalent
Invoke-WebRequest http://localhost:5000/

# Or use docker exec
docker exec test-app curl http://localhost:5000/
```

---

## 🎯 Expected Results Summary

```powershell
# Build successfully:
Successfully tagged ritikrai07/app-ci:test

# Container runs:
docker ps shows "Up X seconds"

# Endpoint responses:
curl returns JSON (not HTML error)

# App logs:
Flask running message appears

# Container healthy:
docker health check passes
```

---

## 📋 Complete Local Test Sequence

Run all these commands in order:

```powershell
# Navigate to project
cd d:\6th sem\Devops\Dockerclas

# Build image
docker build -t ritikrai07/app-ci:test .

# Run container
docker run -d --name test-app -p 5000:5000 ritikrai07/app-ci:test

# Wait for startup
Start-Sleep -Seconds 3

# Test endpoints
curl http://localhost:5000/
curl http://localhost:5000/health
curl http://localhost:5000/api/info

# View logs
docker logs test-app

# Stop and cleanup
docker stop test-app
docker rm test-app

# Verify cleanup
docker ps -a | Select-String "test-app"
```

**If all tests pass** ✅ → Ready to push to GitHub!

---

## What This Proves

If local testing succeeds, you've verified:

✅ **Dockerfile** is valid and builds correctly
✅ **Dependencies** (Flask, etc.) install successfully
✅ **Application code** runs without errors
✅ **Port 5000** is accessible
✅ **All endpoints** respond correctly
✅ **Environment variables** are handled properly
✅ **Docker** is configured correctly on your machine

**This means GitHub Actions will very likely succeed too!**

---

## Next Steps

1. **Pass local testing** ✅
2. **Copy files to your GitHub repository**
3. **Add GitHub secrets** (DOCKER_USERNAME, DOCKER_PASSWORD)
4. **Commit and push code**
5. **Monitor GitHub Actions**
6. **Verify image in Docker Hub**
7. **Pull and test from Docker Hub**

---

## 🚀 Ready?

Complete local testing first, then follow the **ACTION_PLAN.md** to push to GitHub! 🎉
