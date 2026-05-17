# 📚 Complete Docker CI/CD Setup - Action Plan

## 🎯 Current Status

✅ **What's Done**:
- Workflow file created with correct secret references
- All application files ready in GitP7
- Security issues fixed

❌ **What YOU Need to Do** (Steps Below):
- Clone your GitHub repository
- Copy files to your repository
- Add GitHub secrets
- Push code to trigger workflow

---

## 📝 Step-by-Step Action Plan

### **PHASE 1: Prepare Your Repository (5 minutes)**

#### Step 1a: Clone Your GitHub Repository
```powershell
cd d:\6th sem\Devops

# Clone your repository
git clone https://github.com/RitikRai07/Dockerclas.git
cd Dockerclas

# Verify you're in the right directory
pwd
# Output should show: ...\Dockerclas
```

#### Step 1b: Check Current Files
```powershell
# List current files in your repository
ls -la

# You might see existing Docker files - that's OK
```

---

### **PHASE 2: Copy Docker CI/CD Pipeline Files (3 minutes)**

#### Step 2: Copy All Necessary Files

Run these PowerShell commands from your `Dockerclas` directory:

```powershell
# Navigate to Dockerclas folder
cd d:\6th sem\Devops\Dockerclas

# Copy the GitHub Actions workflow (IMPORTANT!)
Copy-Item -Path "d:\6th sem\Devops\GitP7\.github" -Destination "." -Recurse -Force

# Copy all application files
Copy-Item -Path "d:\6th sem\Devops\GitP7\Dockerfile" -Destination "." -Force
Copy-Item -Path "d:\6th sem\Devops\GitP7\app.py" -Destination "." -Force
Copy-Item -Path "d:\6th sem\Devops\GitP7\requirements.txt" -Destination "." -Force
Copy-Item -Path "d:\6th sem\Devops\GitP7\.dockerignore" -Destination "." -Force

# Verify files were copied
dir -Recurse -Depth 2
```

**Expected Output**:
```
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         28-Apr-26    10:00 AM                .github
d-----         28-Apr-26    10:00 AM                .git
-a----         28-Apr-26    10:00 AM             XX Dockerfile
-a----         28-Apr-26    10:00 AM             XX app.py
-a----         28-Apr-26    10:00 AM             XX requirements.txt
-a----         28-Apr-26    10:00 AM             XX .dockerignore
-a----         28-Apr-26    10:00 AM             XX README.md
```

#### Step 2b: Verify Workflow File

```powershell
# Verify the workflow file exists and is correct
cat ".\.github\workflows\docker-ci.yml" | Select-String "DOCKER_USERNAME"
# Should show: password: ${{ secrets.DOCKER_USERNAME }}

cat ".\.github\workflows\docker-ci.yml" | Select-String "DOCKER_PASSWORD"
# Should show: password: ${{ secrets.DOCKER_PASSWORD }}
```

---

### **PHASE 3: Configure GitHub Secrets (5 minutes)**

#### Step 3a: Add DOCKER_USERNAME Secret

1. Open your browser and go to: https://github.com/RitikRai07/Dockerclas/settings/secrets/actions
2. Click **New repository secret** button
3. Fill in:
   - **Name**: `DOCKER_USERNAME`
   - **Secret**: `ritikrai07`
4. Click **Add secret**

**Visual Steps**:
```
GitHub Repository → Settings (top menu) 
  → Secrets and variables (left sidebar) 
  → Actions tab 
  → New repository secret button
```

#### Step 3b: Add DOCKER_PASSWORD Secret

1. Click **New repository secret** again
2. Fill in:
   - **Name**: `DOCKER_PASSWORD`
   - **Secret**: (Your Docker Hub Personal Access Token)
3. Click **Add secret**

**Where to get Docker Hub Token**:
- Go to https://hub.docker.com/settings/security
- Click **New Access Token**
- Give it a name: `github-actions`
- Select: **Read, Write, Delete** permissions
- Click **Generate**
- **Copy the token** (shown only once!)
- Paste it as the secret value

**Expected Result**:
Both secrets appear in your Actions secrets list:
```
DOCKER_USERNAME (secret value hidden)
DOCKER_PASSWORD (secret value hidden)
```

---

### **PHASE 4: Commit and Push Code (3 minutes)**

#### Step 4a: Configure Git

```powershell
# Set your git user (one-time setup)
git config user.email "ritikrai07@gmail.com"
git config user.name "RitikRai07"

# Verify configuration
git config user.email
git config user.name
```

#### Step 4b: Commit Changes

```powershell
# Check what files changed
git status

# Add all files
git add .

# Commit with descriptive message
git commit -m "Add Docker CI/CD pipeline with GitHub Actions workflow

- Added .github/workflows/docker-ci.yml for automated builds
- Added Dockerfile for containerization
- Added Flask application (app.py)
- Added Python dependencies (requirements.txt)
- Configured Docker Hub integration with GitHub Actions"

# Verify commit was created
git log --oneline -5
```

#### Step 4c: Push to GitHub

```powershell
# Push to your repository
git push origin main

# If you're on 'master' branch instead:
# git push origin master
```

**You might be prompted**:
```
Username: RitikRai07
Password: (enter your GitHub Personal Access Token)
```

**Success Output**:
```
Enumerating objects: XX, done.
Counting objects: 100% (XX/XX), done.
Writing objects: 100% (XX/XX), XX bytes, done.
remote: Resolving deltas: 100% (X/X), done.
To https://github.com/RitikRai07/Dockerclas.git
   abc1234..def5678  main -> main
```

---

### **PHASE 5: Monitor Workflow Execution (2 minutes)**

#### Step 5a: Watch Workflow on GitHub

1. Go to: https://github.com/RitikRai07/Dockerclas/actions
2. You should see **Docker CI/CD Pipeline** workflow running
3. Click on it to see real-time progress
4. Watch the steps:
   - ✅ Checkout repository
   - ✅ Set up Docker BuildX
   - ✅ Log in to Docker Hub
   - ✅ Extract metadata
   - ✅ Build and push Docker image
   - ✅ Image pushed successfully

**Workflow Status**:
- 🟡 Yellow = Running
- 🟢 Green = Success
- 🔴 Red = Failed (check logs for errors)

#### Step 5b: Check Build Logs

If any step fails:
1. Click on the failed job
2. Click on the failed step
3. Read the error message
4. Common issues:
   - `Invalid login credentials` → Check secrets
   - `Dockerfile not found` → File wasn't copied
   - `Python dependencies failed` → Check requirements.txt

---

### **PHASE 6: Verify Image on Docker Hub (2 minutes)**

#### Step 6a: Check Docker Hub

1. Go to: https://hub.docker.com/r/ritikrai07/app-ci
2. You should see:
   - Repository: `app-ci`
   - Owner: `ritikrai07`
   - Tags: `main`, `latest`, and commit SHA tags
   - Last pushed: Just now

#### Step 6b: Test Pulling the Image

```powershell
# Pull the latest image
docker pull ritikrai07/app-ci:latest

# Run the container
docker run -d -p 5000:5000 --name test-app ritikrai07/app-ci:latest

# Wait for 3 seconds for the app to start
Start-Sleep -Seconds 3

# Test the endpoints
curl http://localhost:5000/
curl http://localhost:5000/health
curl http://localhost:5000/api/info

# Check logs
docker logs test-app

# Stop the container
docker stop test-app
docker rm test-app
```

**Expected Output**:
```
{
  "message": "Welcome to Docker CI/CD Pipeline!",
  "version": "1.0.0",
  "environment": "production"
}
```

---

## ⏱️ Timeline

| Phase | Task | Duration | Total |
|-------|------|----------|-------|
| 1 | Clone repository | 1 min | 1 min |
| 2 | Copy files | 3 min | 4 min |
| 3 | Add secrets | 5 min | 9 min |
| 4 | Commit & push | 3 min | 12 min |
| 5 | Monitor workflow | 3 min | 15 min |
| 6 | Verify image | 2 min | 17 min |

**Total Time**: ~20 minutes ⏱️

---

## 🔍 Troubleshooting Quick Guide

| Issue | Solution |
|-------|----------|
| Workflow not running | Verify you pushed to `main` branch, wait 30 seconds |
| Login failed | Check `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets exist |
| Dockerfile not found | Copy files using PowerShell commands above |
| Image not in Docker Hub | Check workflow completed (green ✅), not failed (red ❌) |
| Can't pull image | Image name is `ritikrai07/app-ci`, tag is `latest` |
| App won't start locally | Check port 5000 is not in use: `netstat -ano \| findstr 5000` |

---

## ✅ Success Criteria

You'll know it worked when:

- [ ] Workflow shows green checkmark ✅ in Actions tab
- [ ] Image appears on Docker Hub: `ritikrai07/app-ci`
- [ ] Image has tags: `main`, `latest`, commit-sha
- [ ] `docker pull ritikrai07/app-ci:latest` succeeds
- [ ] `docker run` command starts the app
- [ ] `curl http://localhost:5000/` returns JSON response

---

## 🚀 What's Next?

After successful setup:

1. **Make code changes** to `app.py`
2. **Commit and push** to GitHub
3. **Watch workflow trigger automatically**
4. **New image automatically pushed** to Docker Hub
5. **Pull and test** new image locally

Your CI/CD pipeline is now fully automated! 🎉

---

## 📞 Support

If you get stuck:

1. Check the **Actions** tab on GitHub for detailed logs
2. Review the **SECURITY_FIX_AND_SETUP.md** file
3. Check **ENV_AND_SECRETS_EXPLAINED.md** for secrets help
4. Verify secrets are named exactly: `DOCKER_USERNAME`, `DOCKER_PASSWORD`
5. Ensure no extra spaces or special characters in secret values

---

**Start from PHASE 1 above and follow each step carefully!** ✨
