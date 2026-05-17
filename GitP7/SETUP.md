# Step-by-Step Setup Guide for Docker CI/CD Pipeline

## Prerequisites
- GitHub account with a repository
- Docker Hub account
- Git installed on your local machine

---

## Step 1: Create Docker Hub Access Token

### 1.1 Log in to Docker Hub
- Go to [Docker Hub](https://hub.docker.com/)
- Click your profile icon (top right)
- Select **Account Settings**

### 1.2 Generate Access Token
- Click **Security** in the left sidebar
- Click **New Access Token**
- Give it a name: `github-actions-token`
- Set permissions: **Read, Write, Delete**
- Click **Generate**
- **Copy and save the token** (shown only once!)

### 1.3 Note Your Docker Hub Username
- This is displayed at the top of the Account Settings page
- Example: `myusername`

---

## Step 2: Add Secrets to GitHub Repository

### 2.1 Go to Repository Settings
1. Open your GitHub repository
2. Click **Settings** (top right)
3. In the left sidebar, click **Secrets and variables** → **Actions**

### 2.2 Create `DOCKER_USERNAME` Secret
1. Click **New repository secret**
2. **Name**: `DOCKER_USERNAME`
3. **Secret**: Your Docker Hub username (e.g., `myusername`)
4. Click **Add secret**

### 2.3 Create `DOCKER_PASSWORD` Secret
1. Click **New repository secret**
2. **Name**: `DOCKER_PASSWORD`
3. **Secret**: Your Docker Hub access token (from Step 1.2)
4. Click **Add secret**

✅ **Verification**: Both secrets should now appear in the Actions secrets list

---

## Step 3: Copy Files to Your Repository

### 3.1 Directory Structure
Ensure your repository has this structure:

```
your-repo/
├── .github/
│   └── workflows/
│       └── docker-ci.yml
├── Dockerfile
├── app.py
├── requirements.txt
├── .dockerignore
├── README.md
└── .gitignore
```

### 3.2 File Locations
- **Workflow file**: `.github/workflows/docker-ci.yml`
- **Application**: `app.py` (in repository root)
- **Dependencies**: `requirements.txt` (in repository root)
- **Docker config**: `Dockerfile` (in repository root)

---

## Step 4: Push Code to Trigger Workflow

### 4.1 Commit Changes Locally
```bash
# Navigate to your repository
cd your-repo

# Add all files
git add .

# Commit
git commit -m "Add Docker CI/CD pipeline with GitHub Actions"

# Push to GitHub
git push origin main
```

### 4.2 Monitor Workflow Execution
1. Go to your GitHub repository
2. Click **Actions** tab
3. You should see **Docker CI/CD Pipeline** workflow running
4. Click on it to view real-time logs

---

## Step 5: Verify Image in Docker Hub

### 5.1 Check Docker Hub
1. Log in to [Docker Hub](https://hub.docker.com/)
2. Click **Repositories**
3. Look for **app-ci** repository
4. You should see tags like:
   - `main`
   - `latest`
   - `main-<commit-sha>`

### 5.2 Pull and Run the Image
```bash
# Pull the latest image
docker pull yourusername/app-ci:latest

# Run the container
docker run -d \
  --name my-app \
  -p 5000:5000 \
  -e APP_VERSION=1.0.0 \
  -e FLASK_ENV=production \
  yourusername/app-ci:latest

# Test the application
curl http://localhost:5000/

# Expected output:
# {
#   "message": "Welcome to Docker CI/CD Pipeline!",
#   "version": "1.0.0",
#   "environment": "production"
# }
```

---

## Step 6: Test Different Triggers

### 6.1 Test on Push to Main
```bash
# Make a change to app.py
echo '# Updated' >> app.py

# Commit and push
git add app.py
git commit -m "Test workflow trigger on push"
git push origin main

# Workflow should trigger automatically
```

### 6.2 Test Pull Request (No Push)
```bash
# Create a new branch
git checkout -b feature/test-pr

# Make changes
echo '# PR Test' >> app.py

# Commit and push
git add app.py
git commit -m "Test PR build"
git push origin feature/test-pr

# Create a pull request on GitHub
# Workflow will run but NOT push (security)
```

### 6.3 Test on Different Branch
```bash
# Create develop branch
git checkout -b develop

# Push to develop
git push origin develop

# Workflow triggers and pushes as develop:develop tag
```

---

## Step 7: Monitoring and Maintenance

### 7.1 Check Workflow Status
- Navigate to **Actions** tab
- Green checkmark ✅ = Success
- Red X ❌ = Failed
- Click any workflow run to view detailed logs

### 7.2 View Build Logs
1. Click on failed workflow run
2. Click **build-and-push** job
3. Scroll through steps to find the error
4. Common issues:
   - Docker login failed → Check secrets
   - Build failed → Check Dockerfile syntax
   - Push failed → Check Docker Hub token

### 7.3 Manage Secrets
- **Update secret**: Delete and recreate (secrets can't be edited)
- **Delete secret**: Click the secret and delete
- **Rotate credentials**: Generate new token in Docker Hub, update GitHub secret

---

## Understanding Environment Variables and Secrets

### Environment Variables in Workflow
```yaml
env:
  REGISTRY: docker.io        # Docker Hub registry
  IMAGE_NAME: app-ci         # Repository name
  LOG_LEVEL: info            # App log level
```

**Characteristics**:
- Visible in workflow files (version control safe)
- Visible in logs (no sensitive data!)
- Accessible to all steps: `${{ env.VARIABLE_NAME }}`
- Can be overridden per job or step
- Used for non-sensitive configuration

### Secrets in Workflow
```yaml
${{ secrets.DOCKER_USERNAME }}    # Docker Hub username
${{ secrets.DOCKER_PASSWORD }}    # Docker Hub token/password
```

**Characteristics**:
- NOT visible in logs (masked with ***)
- NOT stored in version control (set in GitHub UI)
- Only accessible when explicitly referenced
- Encrypted at rest in GitHub
- Used for sensitive credentials and tokens

### Example Comparison

| Information | Storage | Visibility | Example |
|-------------|---------|------------|---------|
| Registry URL | Environment Variable | Visible | `docker.io` |
| Image Name | Environment Variable | Visible | `app-ci` |
| Username | Secret | Masked | `${{ secrets.DOCKER_USERNAME }}` |
| Password/Token | Secret | Masked | `${{ secrets.DOCKER_PASSWORD }}` |
| Build Date | Environment Variable | Visible | `2024-01-15` |
| API Token | Secret | Masked | `${{ secrets.API_TOKEN }}` |

---

## Troubleshooting Common Issues

### Issue 1: Workflow Not Triggering
**Solution**:
```bash
# Verify workflow file syntax
# Check .github/workflows/docker-ci.yml for YAML errors

# Ensure workflow is in correct location
# Should be at: .github/workflows/docker-ci.yml

# Check trigger conditions match your branch
# Update 'branches:' in 'on:' section if needed
```

### Issue 2: Docker Login Failed
**Solution**:
```bash
# Verify secrets are set correctly
# Go to Settings > Secrets and variables > Actions

# Check Docker Hub token hasn't expired
# Generate new token if needed

# Verify username is exact (case-sensitive)
```

### Issue 3: Build Fails
**Solution**:
```bash
# Test locally first
docker build -t test .

# Check Dockerfile syntax
# Common issues: missing WORKDIR, RUN commands

# Verify app.py runs without errors
python app.py

# Check requirements.txt has all dependencies
pip install -r requirements.txt
```

### Issue 4: Push Fails
**Solution**:
```bash
# Verify Docker Hub token has write access
# Check repository visibility (public vs private)

# Check disk space on GitHub Actions runner
# Large images might fail due to space

# Check Docker Hub rate limits (100 pulls per 6 hours)
```

---

## Next Steps

1. **Add more branches** in workflow triggers
2. **Add notifications** (Slack, email) on build failure
3. **Add automatic versioning** based on Git tags
4. **Add security scanning** (Trivy, Snyk)
5. **Add deployment** to Kubernetes, Docker Swarm, etc.
6. **Monitor image size** and optimize Dockerfile
7. **Set up scheduled builds** for dependency updates

---

## Security Checklist

- ✅ Secrets stored in GitHub, not in code
- ✅ Docker token is personal access token (not password)
- ✅ Workflow only pushes on actual commits (not on PRs)
- ✅ Images are built on GitHub-hosted runners (secure)
- ✅ Build cache is stored securely (type=gha)
- ✅ No sensitive data in image layers
- ✅ Base image is from official repositories (python:3.11-slim)
- ✅ Regular security scanning of dependencies

---

## References

- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
- [Best Practices for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
