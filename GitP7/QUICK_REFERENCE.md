# ⚡ Quick Reference Card

## 🎯 Your GitHub Credentials

```
GitHub Repository:  https://github.com/RitikRai07/Dockerclas
Docker Hub User:    ritikrai07
Image Name:         app-ci
Full Image URL:     docker.io/ritikrai07/app-ci:latest
```

---

## 📋 Critical Setup Checklist

```
☐ GitHub secrets created:
  ☐ DOCKER_USERNAME = ritikrai07
  ☐ DOCKER_PASSWORD = (Docker Hub token)

☐ Files copied to Dockerclas:
  ☐ .github/workflows/docker-ci.yml
  ☐ Dockerfile
  ☐ app.py
  ☐ requirements.txt
  ☐ .dockerignore

☐ Git operations:
  ☐ git add .
  ☐ git commit -m "Add Docker CI/CD pipeline"
  ☐ git push origin main
```

---

## 🔗 Important Links

| Task | URL |
|------|-----|
| GitHub Repository | https://github.com/RitikRai07/Dockerclas |
| Add Secrets | https://github.com/RitikRai07/Dockerclas/settings/secrets/actions |
| Watch Workflow | https://github.com/RitikRai07/Dockerclas/actions |
| Docker Hub Token | https://hub.docker.com/settings/security |
| Docker Hub Image | https://hub.docker.com/r/ritikrai07/app-ci |

---

## 💻 PowerShell Commands

```powershell
# Clone repository
git clone https://github.com/RitikRai07/Dockerclas.git
cd Dockerclas

# Copy files from GitP7
Copy-Item -Path "d:\6th sem\Devops\GitP7\.github" -Destination "." -Recurse -Force
Copy-Item -Path "d:\6th sem\Devops\GitP7\Dockerfile" -Destination "." -Force
Copy-Item -Path "d:\6th sem\Devops\GitP7\app.py" -Destination "." -Force
Copy-Item -Path "d:\6th sem\Devops\GitP7\requirements.txt" -Destination "." -Force
Copy-Item -Path "d:\6th sem\Devops\GitP7\.dockerignore" -Destination "." -Force

# Configure git
git config user.email "ritikrai07@gmail.com"
git config user.name "RitikRai07"

# Commit and push
git add .
git commit -m "Add Docker CI/CD pipeline"
git push origin main

# Test locally
docker build -t ritikrai07/app-ci:test .
docker run -d -p 5000:5000 --name test-app ritikrai07/app-ci:test
curl http://localhost:5000/
docker stop test-app
docker rm test-app
```

---

## 🐳 Docker Hub Token Setup

```
1. Go to: hub.docker.com/settings/security
2. Click: "New Access Token"
3. Name: github-actions
4. Permissions: ☑ Read  ☑ Write  ☑ Delete
5. Click: Generate
6. Copy the token
7. Paste in GitHub secret DOCKER_PASSWORD
```

---

## 📚 Documentation Files (In Order)

```
1. START_HERE.md              ← Begin here!
2. VISUAL_SUMMARY.md          ← Visual overview
3. LOCAL_TESTING_GUIDE.md     ← Test locally first
4. ACTION_PLAN.md             ← Follow 6 phases
5. SETUP_SUMMARY.md           ← Quick reference
6. ENV_AND_SECRETS_EXPLAINED.md ← Understand concepts
7. README.md                  ← Full documentation
```

---

## 🚀 Three Paths Forward

### Quick (15 min)
```
1. Copy files to Dockerclas
2. Add GitHub secrets
3. git push
4. Done!
```

### Balanced (45 min)
```
1. Read VISUAL_SUMMARY.md (5 min)
2. Follow LOCAL_TESTING_GUIDE.md (20 min)
3. Follow ACTION_PLAN.md (20 min)
4. Verify on GitHub & Docker Hub (5 min)
```

### Thorough (90 min)
```
1. Read ENV_AND_SECRETS_EXPLAINED.md (15 min)
2. Follow LOCAL_TESTING_GUIDE.md (20 min)
3. Read SETUP.md (20 min)
4. Follow ACTION_PLAN.md (20 min)
5. Review logs & verify (15 min)
```

---

## ✅ Success Signs

```
✅ Workflow shows green checkmark on GitHub Actions
✅ Image appears at docker.io/ritikrai07/app-ci
✅ Can run: docker pull ritikrai07/app-ci:latest
✅ Endpoints work: curl http://localhost:5000/
✅ Multiple tags exist: main, latest, commit-sha
```

---

## 🆘 Troubleshooting Quick Guide

| Problem | Solution |
|---------|----------|
| Workflow not running | Wait 1-2 min, check you pushed to main branch |
| Login failed | Verify secrets exist & have correct values |
| Dockerfile not found | Verify file was copied to repo root |
| Build failed | Check error in GitHub Actions logs |
| Image not on Docker Hub | Check workflow completed (green ✅) |
| Can't pull image | Image name is `ritikrai07/app-ci:latest` |
| Container won't start | Check port 5000 isn't already in use |
| App not responding | Check Docker logs: `docker logs <container>` |

---

## 🔑 Remember: GitHub Secrets

```yaml
# ✅ CORRECT (use secrets)
username: ${{ secrets.DOCKER_USERNAME }}
password: ${{ secrets.DOCKER_PASSWORD }}

# ❌ WRONG (hardcoding)
username: ritikrai07
password: mytoken123
```

---

## 📊 Workflow Steps

```
1. Checkout repository
2. Setup Docker BuildX
3. Login to Docker Hub (using secrets)
4. Extract metadata (generate tags)
5. Build Docker image (from Dockerfile)
6. Push to Docker Hub (with tags)
7. Output success message
```

---

## 🔗 Key URLs for Your Project

**Copy these into your browser:**

```
Repository:
  https://github.com/RitikRai07/Dockerclas

Add Secrets:
  https://github.com/RitikRai07/Dockerclas/settings/secrets/actions

View Workflows:
  https://github.com/RitikRai07/Dockerclas/actions

Docker Hub Image:
  https://hub.docker.com/r/ritikrai07/app-ci

Docker Hub Tokens:
  https://hub.docker.com/settings/security
```

---

## 📁 Files Location

```
Everything Ready In:
  d:\6th sem\Devops\GitP7\

Copy To:
  d:\6th sem\Devops\Dockerclas\
```

---

## ⏰ Timeline

```
Setup:        5-15 minutes
Testing:      5-10 minutes
Verification: 2-5 minutes
Total:        15-30 minutes
```

---

## 🎯 Final Checklist Before Pushing

```
☐ Files copied from GitP7
☐ .github/workflows/docker-ci.yml exists
☐ Dockerfile exists in root
☐ app.py exists in root
☐ requirements.txt exists in root
☐ DOCKER_USERNAME secret = ritikrai07
☐ DOCKER_PASSWORD secret = (your Docker Hub token)
☐ No credentials in code
☐ Ready to git push origin main
```

---

## 💡 Pro Tips

```
1. Test locally first (LOCAL_TESTING_GUIDE.md)
2. Watch GitHub Actions logs in real-time
3. Docker Hub updates ~1-2 minutes after push
4. Check both GitHub Actions tab AND Docker Hub
5. Rotate Docker tokens monthly
6. Never hardcode credentials
```

---

## 🎓 You're Learning

```
✅ GitHub Actions (CI/CD automation)
✅ Docker (containerization)
✅ Security (secrets management)
✅ DevOps (continuous deployment)
✅ Version control (Git + GitHub)
```

---

## 🚀 Ready to Start?

```
Next Step: Go to START_HERE.md
Choose your path (Quick/Balanced/Thorough)
Follow the instructions
Get your CI/CD pipeline working! 🎉
```

---

**Print this card and keep it handy!** 📌
