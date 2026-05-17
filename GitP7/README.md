# GitHub Actions CI/CD Pipeline - Complete Guide

## Overview

This repository contains a complete **Docker CI/CD pipeline** using **GitHub Actions** that automatically builds and pushes Docker images to Docker Hub whenever code is pushed to the repository.

## Architecture

```
┌─────────────────┐
│  Code Push      │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  GitHub Actions Workflow        │
├─────────────────────────────────┤
│ 1. Checkout Code                │
│ 2. Setup Docker BuildX          │
│ 3. Login to Docker Hub          │
│ 4. Extract Metadata & Tags      │
│ 5. Build Docker Image           │
│ 6. Push to Docker Hub           │
└────────┬────────────────────────┘
         │
         ▼
┌──────────────────────────┐
│  Docker Hub Repository   │
│  username/app-ci:latest  │
└──────────────────────────┘
```

## Workflow File Explanation

The main workflow is in `.github/workflows/docker-ci.yml`

### Key Components:

#### 1. **Triggers (on)**
```yaml
on:
  push:
    branches:
      - main
      - master
      - develop
  pull_request:
    branches:
      - main
      - master
```
- Runs on push to main/master/develop branches
- Also runs on pull requests for verification

#### 2. **Environment Variables**
```yaml
env:
  REGISTRY: docker.io
  IMAGE_NAME: app-ci
```
**Purpose**: Store reusable values across all steps. These are:
- Non-sensitive configuration values
- Accessible in all jobs and steps using `${{ env.VARIABLE_NAME }}`
- Static values that don't change per run

#### 3. **Secrets**
Used for sensitive data like credentials:
```yaml
${{ secrets.DOCKER_USERNAME }}
${{ secrets.DOCKER_PASSWORD }}
```
**Purpose**: Securely store and access sensitive information:
- Never logged or exposed in output
- Encrypted at rest in GitHub
- Only accessible to authorized workflows
- Set in repository Settings > Secrets and variables > Actions

#### 4. **Jobs and Steps**

##### **Step 1: Checkout Repository**
```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```
- Clones the repository code into the runner environment
- Makes all files available for the build process

##### **Step 2: Setup Docker BuildX**
```yaml
- name: Set up Docker BuildX
  uses: docker/setup-buildx-action@v3
```
- Installs Docker BuildX for advanced image building
- Enables features like multi-platform builds, caching, and better performance

##### **Step 3: Login to Docker Hub**
```yaml
- name: Log in to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}
```
- Authenticates with Docker Hub using stored credentials
- Allows pushing images to your private/public repository
- Uses GitHub Secrets to keep credentials safe

##### **Step 4: Extract Metadata**
```yaml
- name: Extract metadata
  id: meta
  uses: docker/metadata-action@v5
```
- Generates tags and labels for the image
- Tags include:
  - Branch names
  - Git SHA (commit hash)
  - Latest tag
  - Semantic versioning (if available)

##### **Step 5: Build and Push**
```yaml
- name: Build and push Docker image
  uses: docker/build-push-action@v5
  with:
    context: .
    push: ${{ github.event_name != 'pull_request' }}
    tags: ${{ steps.meta.outputs.tags }}
    labels: ${{ steps.meta.outputs.labels }}
```
**Key Features**:
- `context: .` - Uses current directory as build context (where Dockerfile is)
- `push: ${{ github.event_name != 'pull_request' }}` - Only pushes on actual commits, not on PRs
- `tags` - Uses dynamically generated tags from metadata
- `cache-from: type=gha` - Uses GitHub Actions cache for faster builds

---

## Environment Variables vs. Secrets

### **Environment Variables**
```
✅ Non-sensitive configuration
✅ Reusable values (URLs, port numbers, feature flags)
✅ Visible in logs
✅ Set in workflow file or repository settings
✅ Accessible to all workflows

Example:
env:
  REGISTRY: docker.io
  IMAGE_NAME: app-ci
  LOG_LEVEL: info
```

### **Secrets**
```
✅ Sensitive data (passwords, tokens, API keys)
✅ Encrypted and not visible in logs
✅ Must be set in GitHub repository settings
✅ Accessed only when explicitly referenced
✅ Cannot be viewed after creation (security)

Example:
${{ secrets.DOCKER_USERNAME }}
${{ secrets.DOCKER_PASSWORD }}
${{ secrets.API_TOKEN }}
```

---

## Setup Instructions

### 1. Create Docker Hub Account
- Go to [Docker Hub](https://hub.docker.com)
- Create an account and remember your username
- Generate an access token (Settings > Security > Access Tokens)

### 2. Add GitHub Secrets
1. Go to your GitHub repository
2. Navigate to **Settings > Secrets and variables > Actions**
3. Click **New repository secret** and add:
   - `DOCKER_USERNAME` - Your Docker Hub username
   - `DOCKER_PASSWORD` - Your Docker Hub access token

### 3. Enable GitHub Actions
- Ensure Actions are enabled in repository settings
- Verify the workflow file is in `.github/workflows/`

### 4. Push Code to Trigger Workflow
```bash
git add .
git commit -m "Add Docker CI/CD pipeline"
git push origin main
```

### 5. Monitor the Workflow
- Go to **Actions** tab on GitHub
- Watch the workflow run in real-time
- Check logs for detailed build information

---

## Project Structure

```
GitP7/
├── .github/
│   └── workflows/
│       └── docker-ci.yml          # GitHub Actions workflow
├── Dockerfile                      # Docker image definition
├── app.py                          # Python Flask application
├── requirements.txt                # Python dependencies
├── README.md                       # This file
├── .dockerignore                   # Files to exclude from Docker build
└── .gitignore                      # Files to exclude from Git
```

---

## Image Tags and Versioning

When you push code, the workflow automatically creates multiple tags:

| Condition | Tag Example |
|-----------|-------------|
| Push to main | `username/app-ci:main`, `username/app-ci:latest` |
| Push to develop | `username/app-ci:develop` |
| Git commit SHA | `username/app-ci:main-abc1234def` |
| Pull Request | No push (only build) |

---

## Usage

### Pull the Latest Image
```bash
docker pull username/app-ci:latest
```

### Run the Container
```bash
docker run -p 5000:5000 \
  -e APP_VERSION=1.0.0 \
  -e FLASK_ENV=production \
  username/app-ci:latest
```

### Access the Application
```bash
# Home endpoint
curl http://localhost:5000/

# Health check
curl http://localhost:5000/health

# API info
curl http://localhost:5000/api/info
```

---

## Workflow Execution Flow

```
1. Developer pushes code to GitHub
   ↓
2. GitHub detects push event
   ↓
3. GitHub Actions triggers workflow
   ↓
4. Runner executes workflow steps:
   a. Checkout code from repository
   b. Setup Docker BuildX environment
   c. Authenticate with Docker Hub (using secrets)
   d. Extract Git metadata (commit SHA, branch name)
   e. Build Docker image from Dockerfile
   f. Tag image with generated tags
   g. Push image to Docker Hub registry
   ↓
5. Image available on Docker Hub
   ↓
6. Users can pull image with: docker pull username/app-ci:latest
```

---

## Security Best Practices

### ✅ Do's:
- Store credentials in GitHub Secrets, never in code
- Use personal access tokens instead of passwords
- Rotate tokens regularly
- Use branch protection rules
- Review workflow logs for sensitive data leaks
- Use specific action versions (e.g., `@v4`, not `@latest`)

### ❌ Don'ts:
- Hardcode passwords or tokens in workflow files
- Log secrets or environment variables to console
- Use `push: true` for all workflows (security risk)
- Leave unused secrets in GitHub
- Grant unnecessary permissions to workflows

---

## Troubleshooting

### Build Fails
- Check `Dockerfile` syntax: `docker build -t test .`
- Verify `app.py` imports: `python -m py_compile app.py`
- Check requirements.txt: `pip install -r requirements.txt`

### Push Fails
- Verify `DOCKER_USERNAME` and `DOCKER_PASSWORD` are set correctly
- Check Docker Hub token hasn't expired
- Ensure repository is public or token has write access

### Workflow Not Triggering
- Verify workflow file is in `.github/workflows/`
- Check `on:` trigger conditions match your branch names
- Ensure GitHub Actions are enabled in repository settings

---

## Advanced Features

### Multi-Platform Builds
Add platform support in workflow:
```yaml
with:
  platforms: linux/amd64,linux/arm64,linux/arm/v7
```

### Environment-Specific Builds
Use build args:
```yaml
build-args: |
  BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
  VCS_REF=${{ github.sha }}
```

### Conditional Pushes
```yaml
push: ${{ github.ref == 'refs/heads/main' }}
```

---

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
- [Docker Login Action](https://github.com/docker/login-action)
- [Docker Metadata Action](https://github.com/docker/metadata-action)
- [Docker Hub](https://hub.docker.com)

---

## Support

For issues or questions:
1. Check GitHub Actions logs
2. Review this documentation
3. Consult [GitHub Actions troubleshooting](https://docs.github.com/en/actions/troubleshooting)
4. Check Docker Hub documentation
