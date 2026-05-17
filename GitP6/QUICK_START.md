# GitHub Actions Workflow - Quick Start Guide

## Setup Instructions

### 1. Initialize Git Repository
```bash
cd GitP6
git init
git add .
git commit -m "Initial commit: Maven CI/CD project with GitHub Actions"
```

### 2. Push to GitHub
```bash
# Add your GitHub repository
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push to repository
git branch -M main
git push -u origin main
```

### 3. Verify Workflow

1. Go to your GitHub repository
2. Click on **Actions** tab
3. You should see **"Java CI/CD Pipeline"** workflow
4. Click on the workflow run to see details
5. Workflow will automatically trigger on:
   - Push to `main` or `develop` branches
   - Pull requests to `main` or `develop` branches

---

## Understanding the Workflow Execution

### Workflow Triggers
```yaml
on:
  push:
    branches: [ main, develop ]      # Runs on push
  pull_request:
    branches: [ main, develop ]      # Runs on PR
```

### Job Configuration
```yaml
jobs:
  build:
    runs-on: ubuntu-latest           # Runs on Ubuntu
    strategy:
      matrix:
        java-version: ['17']         # Java 17
```

---

## What Gets Executed

### Step-by-Step Execution

| Step | Command/Action | Purpose |
|------|--------|---------|
| 1 | `actions/checkout@v4` | Clone repository |
| 2 | `actions/setup-java@v3` | Install JDK 17 |
| 3 | Verify versions | Check Java & Maven |
| 4 | `mvn clean install -DskipTests` | Install dependencies |
| 5 | `mvn clean verify` | **Compile + Test** |
| 6 | Test result publishing | Display test results |
| 7 | Upload artifacts | Save JAR & reports |
| 8 | Build summary | Show execution details |

---

## Monitoring Your Builds

### In GitHub Web Interface

1. **Actions Tab**
   - View all workflow runs
   - See build status (✓ pass or ✗ fail)
   - Check execution time

2. **Individual Run Details**
   - Click on workflow run
   - Expand each step to see logs
   - Download artifacts

3. **Pull Request Checks**
   - See CI/CD status
   - Workflow must pass to merge

### Workflow Status Indicators

- 🟢 **Success** - All steps passed, artifacts archived
- 🔴 **Failure** - Build or tests failed
- 🟡 **In Progress** - Workflow is running

---

## Accessing Build Artifacts

### Download JAR Files

1. Go to GitHub Actions workflow run
2. Scroll to **"Artifacts"** section
3. Download **"build-artifacts"**
4. Extract ZIP file
5. Run application:
   ```bash
   java -jar maven-ci-app-1.0.0.jar
   ```

### View Test Reports

1. Download **"test-reports"** artifact
2. Open `TEST-com.example.GreetingServiceTest.xml` in text editor
3. Or view in GitHub Actions as HTML summary

---

## Local Development Workflow

### Development → Git → GitHub Actions

```
1. Edit Code Locally
   ↓
2. Run Tests Locally
   mvn test
   ↓
3. Commit Changes
   git add .
   git commit -m "message"
   ↓
4. Push to GitHub
   git push
   ↓
5. GitHub Actions Automatically:
   - Compiles code
   - Runs all tests
   - Archives artifacts
   ↓
6. Review Results in Actions Tab
```

### Example Development Cycle

```bash
# 1. Make changes to source code
echo "// New feature" >> src/main/java/com/example/GreetingService.java

# 2. Test locally
mvn test

# 3. If tests pass, commit
git add .
git commit -m "feat: Add new feature"

# 4. Push to GitHub
git push origin main

# 5. GitHub Actions runs automatically
# (Check Actions tab in GitHub)
```

---

## Common Scenarios

### Scenario 1: Test Failure in CI

**What happens:**
1. Tests fail in GitHub Actions
2. Workflow marked as ❌ Failed
3. Pull request blocked from merging

**How to fix:**
1. Check "Build and Run Tests" step logs
2. See which test failed
3. Fix code locally
4. Run `mvn test` locally to verify
5. Commit and push fix
6. GitHub Actions runs again automatically

### Scenario 2: New Dependency Added

**Workflow:**
1. Add dependency to `pom.xml`
2. Run `mvn test` locally
3. Push to GitHub
4. GitHub Actions:
   - Downloads new dependency
   - Compiles with new dependency
   - Runs tests
   - Archives updated JAR

### Scenario 3: Release Build

```bash
# When ready to release:
git tag v1.0.0
git push origin v1.0.0

# GitHub Actions creates release
# Artifacts available for download
```

---

## Troubleshooting

### Workflow Won't Trigger

**Check:**
1. Repository is on GitHub
2. `.github/workflows/ci.yml` exists
3. Push is to `main` or `develop` branch
4. Repository has Actions enabled

**Fix:**
```bash
# Re-push to trigger
git add .
git commit -m "Trigger workflow"
git push
```

### Tests Failing in CI but Pass Locally

**Possible causes:**
1. Different Java version
2. Environment variables missing
3. Timezone differences
4. File path issues

**Solution:**
1. Check workflow uses Java 17
2. Verify code compiles: `mvn compile`
3. Run full build: `mvn clean verify`

### Artifacts Not Saving

**Check:**
1. Tests must pass (use `if: success()`)
2. JAR files exist in `target/`
3. Build completed successfully

**Verify:**
```bash
# Locally, check artifact location
mvn clean package
ls -la target/*.jar
```

---

## Configuration Customization

### Change Java Version

Edit `.github/workflows/ci.yml`:
```yaml
matrix:
  java-version: ['17', '21']    # Add Java 21
```

### Add New Branch Trigger

```yaml
on:
  push:
    branches: [ main, develop, staging ]
```

### Change Artifact Retention

```yaml
- name: Archive Build Artifacts
  with:
    retention-days: 60          # Change from 30 to 60
```

### Add Notifications

```yaml
- name: Notify on Success
  if: success()
  run: echo "Build successful!"
```

---

## Best Practices

### ✅ DO:
- Run tests locally before pushing
- Use meaningful commit messages
- Review workflow logs for failures
- Keep pom.xml up to date
- Write unit tests for new features

### ❌ DON'T:
- Force push to main branch
- Commit without testing
- Ignore workflow failures
- Keep dependencies outdated
- Skip unit tests

---

## Next Commands to Try

### View Workflow Status
```bash
# Check if workflow file is valid
git push  # Trigger workflow
# Then check GitHub Actions tab
```

### Run Locally for Testing
```bash
# Same steps as CI pipeline
mvn clean install -DskipTests
mvn clean verify
```

### Download and Test Artifact
```bash
# Get JAR from GitHub Actions
# Then run it
java -jar maven-ci-app-1.0.0.jar
```

---

## Success Criteria

✅ **Workflow is working correctly if:**

1. Workflow runs automatically on push
2. All 8 steps complete successfully
3. Tests pass with green checkmark
4. Artifacts are archived and downloadable
5. JAR files are executable
6. Test reports show all tests passed

---

## Summary

Your GitHub Actions CI/CD pipeline is now:
- ✅ **Automatic** - Runs on every push/PR
- ✅ **Complete** - Handles all 5 tasks
- ✅ **Reliable** - Archives artifacts and reports
- ✅ **Fast** - Caches dependencies
- ✅ **Professional** - Follows best practices

**Happy building! 🚀**
