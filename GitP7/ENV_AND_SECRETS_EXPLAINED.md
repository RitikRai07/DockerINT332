# Environment Variables and Secrets in GitHub Actions

## Quick Reference Table

| Aspect | Environment Variables | Secrets |
|--------|----------------------|---------|
| **Visibility** | Visible in logs | Masked/Hidden |
| **Security** | ❌ Not secure | ✅ Encrypted |
| **Use Case** | Configuration | Credentials |
| **Examples** | URLs, versions, flags | Passwords, tokens |
| **Access** | `${{ env.VAR_NAME }}` | `${{ secrets.SECRET_NAME }}` |
| **Storage** | In code/workflow file | GitHub UI only |
| **Modification** | Easy to change | Delete & recreate |

---

## Environment Variables

### Definition
Environment variables are key-value pairs that store **non-sensitive configuration data**. They are visible in logs and workflow files.

### Syntax
```yaml
env:
  REGISTRY: docker.io
  IMAGE_NAME: app-ci
  LOG_LEVEL: info
```

### Access in Workflow
```yaml
# Using environment variable
echo ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}

# Output: docker.io/app-ci
```

### Common Uses
```yaml
env:
  # Docker configuration
  REGISTRY: docker.io
  IMAGE_NAME: my-app
  BUILD_CONTEXT: ./app
  
  # Application settings
  LOG_LEVEL: info
  ENV_TYPE: production
  PORT: 5000
  
  # Build configuration
  PYTHON_VERSION: 3.11
  NODE_VERSION: 18
  
  # File paths
  DOCKERFILE_PATH: ./Dockerfile
  ENTRYPOINT: ./start.sh
```

### Scope Levels

#### 1. **Global (entire workflow)**
```yaml
name: CI Pipeline
env:
  GLOBAL_VAR: value

jobs:
  job1:
    steps:
      - run: echo ${{ env.GLOBAL_VAR }}
```

#### 2. **Job level**
```yaml
jobs:
  build:
    env:
      JOB_VAR: value
    steps:
      - run: echo ${{ env.JOB_VAR }}
```

#### 3. **Step level**
```yaml
steps:
  - name: Print message
    env:
      STEP_VAR: value
    run: echo ${{ env.STEP_VAR }}
```

### Real-World Example
```yaml
env:
  REGISTRY: docker.io
  IMAGE_NAME: awesome-app

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Login to Docker
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build image
        run: |
          docker build \
            -t ${{ env.REGISTRY }}/${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest \
            .
          echo "Built: ${{ env.REGISTRY }}/${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest"
```

---

## Secrets

### Definition
Secrets are **encrypted key-value pairs** for storing sensitive data like API keys, passwords, and tokens. They are masked in logs and never displayed.

### How to Create Secrets

#### In GitHub Repository Settings:
1. **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Enter **Name**: `SECRET_NAME`
4. Enter **Secret value**: (sensitive data)
5. Click **Add secret**

#### Secret Naming Convention
- Use UPPERCASE with underscores
- Examples:
  - `DOCKER_USERNAME`
  - `DOCKER_PASSWORD`
  - `API_TOKEN`
  - `SSH_PRIVATE_KEY`
  - `DATABASE_PASSWORD`

### Access in Workflow
```yaml
- name: Login
  run: echo ${{ secrets.DOCKER_PASSWORD }}
```

**Output in logs**: `echo ***` (masked for security)

### Types of Secrets

#### 1. **Docker Hub Credentials**
```yaml
${{ secrets.DOCKER_USERNAME }}
${{ secrets.DOCKER_PASSWORD }}
```

#### 2. **API Tokens**
```yaml
${{ secrets.GITHUB_TOKEN }}          # Auto-provided by GitHub
${{ secrets.SLACK_WEBHOOK }}         # Custom token
${{ secrets.NPM_TOKEN }}             # NPM registry token
```

#### 3. **SSH Keys**
```yaml
${{ secrets.SSH_PRIVATE_KEY }}
```

#### 4. **Database Credentials**
```yaml
${{ secrets.DB_HOST }}
${{ secrets.DB_USER }}
${{ secrets.DB_PASSWORD }}
```

#### 5. **API Keys**
```yaml
${{ secrets.AWS_ACCESS_KEY_ID }}
${{ secrets.AWS_SECRET_ACCESS_KEY }}
${{ secrets.STRIPE_API_KEY }}
```

### Real-World Example
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}      # ✅ Secret
          password: ${{ secrets.DOCKER_PASSWORD }}      # ✅ Secret
      
      - name: Build and push
        run: |
          docker build -t app .
          docker push ${{ secrets.DOCKER_USERNAME }}/app:latest
      
      - name: Deploy to production
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_SSH_KEY }}      # ✅ Secret
          API_ENDPOINT: ${{ env.PRODUCTION_API }}        # ✅ Env var
        run: |
          echo "$DEPLOY_KEY" > id_rsa
          chmod 600 id_rsa
          ssh -i id_rsa deploy@server.com "docker pull app"
```

---

## Comparison: When to Use What

### Use Environment Variables When:
✅ Configuration is **non-sensitive**
✅ Value is **reused multiple times**
✅ Value needs to be **version controlled**
✅ Setting **application settings** (ports, URLs, log levels)
✅ Value is **visible in documentation**

**Examples**:
```yaml
env:
  # Safe to commit to repository
  REGISTRY: docker.io
  IMAGE_NAME: app-ci
  PYTHON_VERSION: 3.11
  DOCKERFILE_PATH: ./Dockerfile
  GITHUB_API: https://api.github.com
  PORT: 5000
```

### Use Secrets When:
✅ Data is **sensitive** (credentials, tokens)
✅ Value should **never appear in logs**
✅ Value is **unique per organization**
✅ Value needs **encryption at rest**
✅ Value **changes less frequently**

**Examples**:
```yaml
# Never commit these
${{ secrets.DOCKER_PASSWORD }}
${{ secrets.API_TOKEN }}
${{ secrets.DATABASE_PASSWORD }}
${{ secrets.SSH_PRIVATE_KEY }}
${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

---

## Complete Workflow Example

```yaml
name: Secure Build and Deploy

# Environment variables for the entire workflow
env:
  REGISTRY: docker.io
  IMAGE_NAME: secure-app
  LOG_LEVEL: info
  BUILD_TIMEOUT: 3600

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    
    # Job-level environment variables
    env:
      BUILD_ENV: production
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      # Step 1: Using environment variables (visible)
      - name: Log configuration
        run: |
          echo "Registry: ${{ env.REGISTRY }}"
          echo "Image: ${{ env.IMAGE_NAME }}"
          echo "Log Level: ${{ env.LOG_LEVEL }}"
      
      # Step 2: Using secrets (masked in logs)
      - name: Login to registry
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      # Step 3: Using both in same command
      - name: Build and tag image
        run: |
          FULL_IMAGE_NAME="${{ env.REGISTRY }}/${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}"
          echo "Building: $FULL_IMAGE_NAME"
          docker build -t $FULL_IMAGE_NAME:${{ github.sha }} .
          docker tag $FULL_IMAGE_NAME:${{ github.sha }} $FULL_IMAGE_NAME:latest
      
      # Step 4: Using secrets for authentication
      - name: Push image
        run: |
          docker push ${{ env.REGISTRY }}/${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
      
      # Step 5: Using secrets for deployment
      - name: Deploy application
        env:
          DEPLOY_USER: ${{ secrets.DEPLOY_SSH_USER }}
          DEPLOY_HOST: ${{ secrets.DEPLOY_HOST }}
          DEPLOY_KEY: ${{ secrets.DEPLOY_SSH_KEY }}
        run: |
          echo "$DEPLOY_KEY" > /tmp/deploy_key
          chmod 600 /tmp/deploy_key
          ssh -i /tmp/deploy_key $DEPLOY_USER@$DEPLOY_HOST "docker pull ${{ env.REGISTRY }}/${{ secrets.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest"
```

**Log Output** (Notice masked secrets):
```
Registry: docker.io
Image: secure-app
Log Level: info
Building: docker.io/****/secure-app
Logging in with username: ****
Login successful
Built: docker.io/****/secure-app:abc123def456
```

---

## Security Best Practices

### ✅ Do's:
1. **Store passwords/tokens in Secrets**
   ```yaml
   password: ${{ secrets.DATABASE_PASSWORD }}  # ✅ Correct
   ```

2. **Use environment variables for configuration**
   ```yaml
   env:
     API_URL: https://api.example.com  # ✅ Correct
   ```

3. **Mask secrets in logs automatically**
   ```bash
   echo ${{ secrets.PASSWORD }}  # Output: ****
   ```

4. **Rotate secrets regularly**
   - Delete old secret
   - Create new secret with same name
   - Secrets can't be edited (security)

5. **Limit secret scope to needed jobs**
   ```yaml
   jobs:
     deploy:
       env:
         SECRET: ${{ secrets.DEPLOY_KEY }}  # Only available in deploy job
   ```

### ❌ Don'ts:
1. **Hardcode credentials in code**
   ```yaml
   password: mypassword123  # ❌ NEVER DO THIS
   ```

2. **Store secrets in environment files**
   ```yaml
   - name: Load env
     run: source .env  # ❌ Avoid
   ```

3. **Print secrets to logs**
   ```yaml
   - run: echo ${{ secrets.PASSWORD }}  # ❌ Will be masked, but looks wrong
   ```

4. **Use secrets in public workflows**
   ```yaml
   - name: Public log
     run: echo "Secret: ${{ secrets.KEY }}"  # ❌ Don't
   ```

5. **Share secrets across multiple workflows unnecessarily**
   ```yaml
   # ❌ Keep secrets scope-limited
   ```

---

## Troubleshooting

### Problem: "Secret value is always masked in logs"
**Explanation**: This is intentional for security. Secrets are **always** masked, even if you try to print them.

**Solution**: Use secrets only where needed:
```yaml
- uses: docker/login-action@v3
  with:
    password: ${{ secrets.DOCKER_PASSWORD }}  # ✅ Used securely
```

### Problem: "Variable not found" error
**Check**:
- Spelling: `env.VARIABLE_NAME` vs `env.Variable_Name`
- Case sensitivity: `ENV_VAR` ≠ `env_var`
- Scope: Variable defined in correct job/step

**Fix**:
```yaml
env:
  MY_VAR: value

steps:
  - run: echo ${{ env.MY_VAR }}  # ✅ Correct casing
```

### Problem: "Secret not accessible in workflow"
**Check**:
1. Secret created in **Settings > Secrets and variables > Actions**
2. Workflow file syntax is correct: `${{ secrets.SECRET_NAME }}`
3. Repository has access to actions
4. Secret name matches exactly (case-sensitive)

---

## Summary

| Feature | Environment Variables | Secrets |
|---------|-----|---------|
| **Purpose** | Store configuration | Protect credentials |
| **Visibility** | Visible in logs | Masked/hidden |
| **Security** | Non-encrypted | Encrypted |
| **Syntax** | `${{ env.NAME }}` | `${{ secrets.NAME }}` |
| **When** | Settings, URLs, versions | Passwords, tokens, keys |
| **Example** | `REGISTRY: docker.io` | `DOCKER_PASSWORD` |

**Rule of Thumb**: If it's sensitive (password, token, key) → **Secret**. If it's safe to share (URL, version, setting) → **Environment Variable**.
