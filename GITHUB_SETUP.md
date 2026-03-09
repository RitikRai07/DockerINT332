# GitHub Setup Guide

## Quick Start: Push to GitHub

This repository is ready to push to GitHub! Follow these steps:

### Step 1: Create Repository on GitHub

1. Go to [github.com/new](https://github.com/new)
2. Create repository named: **docker-devops-lab**
3. Do NOT initialize with README, .gitignore, or license (we already have these)
4. Click **Create repository**

### Step 2: Add Remote and Push

Run these commands in the project directory:

```bash
# Add GitHub remote
git remote add origin https://github.com/YOUR_USERNAME/docker-devops-lab.git

# Rename branch to main (already done)
git branch -M main

# Push to GitHub
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

### Step 3: Verify on GitHub

- Visit: `https://github.com/YOUR_USERNAME/docker-devops-lab`
- You should see all files and folders

---

## Using SSH (Recommended)

If you have SSH set up:

```bash
# Add SSH remote
git remote add origin git@github.com:YOUR_USERNAME/docker-devops-lab.git

# Push to GitHub
git push -u origin main
```

---

## Current Repository Status

```
✓ Git initialized
✓ Files staged and committed
✓ Branch: main
✓ Remote: Ready (not yet connected)
```

---

## File Structure Ready for Upload

```
docker-devops-lab/
├── README.md (Main documentation)
├── .gitignore
│
├── 01_Docker_Basics/
│   ├── docker_commands.md
│   ├── docker_images.md
│   └── docker_run_examples.md
│
├── 02_Container_Interaction/
│   └── container_host_interaction.md
│
├── 03_Docker_Volumes/
│   └── volume_commands.md
│
├── 04_Docker_Projects/
│   ├── nginx-app/
│   │   ├── Dockerfile
│   │   ├── index.html
│   │   ├── default.conf
│   │   └── README.md
│   │
│   └── node-app/
│       ├── Dockerfile
│       ├── package.json
│       ├── app.js
│       ├── .dockerignore
│       └── README.md
│
├── 05_Practice_Questions/
│   └── docker_questions_answers.md
│
└── PPT_Reference/ (Ready for your PPT files)
```

---

## Next Steps After GitHub Upload

### 1. Test Docker Projects

```bash
# Nginx Project
cd 04_Docker_Projects/nginx-app
docker build -t custom-nginx:v1 .
docker run -d -p 8080:80 custom-nginx:v1

# Node Project
cd 04_Docker_Projects/node-app
docker build -t node-demo:v1 .
docker run -d -p 3000:3000 node-demo:v1
```

### 2. Add PPT Files

```bash
# Copy your PPT files to PPT_Reference/
cp *.ppt PPT_Reference/

# Commit
git add PPT_Reference/
git commit -m "Add PPT reference materials"
git push origin main
```

### 3. Create GitHub Pages (Optional)

Add a `gh-pages` branch to publish documentation:

```bash
# Create gh-pages branch
git checkout --orphan gh-pages
git rm -rf .
echo "# Docker DevOps Lab" > README.md
git add .
git commit -m "Initialize GitHub Pages"
git push origin gh-pages
git checkout main
```

---

## GitHub Profile Benefits

✅ **Showcase Docker Knowledge**: Full Docker learning repository  
✅ **Interview Ready**: Professional project structure  
✅ **Portfolio Addition**: DevOps practice projects  
✅ **Community**: Share with others  
✅ **Version Control**: Track learning progress  

---

## Add GitHub Badges (Optional)

Add to your main README.md:

```markdown
# Docker DevOps Lab 🚀

[![GitHub stars](https://img.shields.io/github/stars/YOUR_USERNAME/docker-devops-lab)](https://github.com/YOUR_USERNAME/docker-devops-lab)
[![GitHub forks](https://img.shields.io/github/forks/YOUR_USERNAME/docker-devops-lab)](https://github.com/YOUR_USERNAME/docker-devops-lab)
[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)
```

Then replace `YOUR_USERNAME` with your GitHub username.

---

## Troubleshooting

### Command not working?

Make sure you're in the correct directory:
```bash
cd c:\Users\your_username\OneDrive\Desktop\Devops\docker-devops-lab
```

### Authentication Error?

Configure Git credentials:
```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

### Push Rejected?

Make sure the GitHub repository is empty (no README, .gitignore, or license).

---

## Git Commands Reference

```bash
# Check status
git status

# View commits
git log --oneline --graph --all

# Add changes
git add .

# Commit
git commit -m "Your message"

# Push to GitHub
git push origin main

# Pull latest
git pull origin main

# Create new branch
git checkout -b feature-name

# Switch branch
git checkout main
```

---

## Completed! 🎉

Your Docker DevOps Lab repository is ready for:
✅ Local version control
✅ GitHub upload
✅ Team collaboration
✅ Portfolio showcase

**Next: Push to GitHub and share your learning!**

