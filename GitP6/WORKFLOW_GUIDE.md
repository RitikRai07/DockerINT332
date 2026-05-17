# GitHub Actions CI/CD Workflow - Complete Guide

## Task Overview & Implementation

This document provides a comprehensive explanation of the GitHub Actions CI/CD workflow created for the GitP6 Maven project, addressing all 5 required tasks.

---

## ✅ Task 1: Check out the Source Code from the Repository

### Implementation Details

**File**: `.github/workflows/ci.yml` (Lines 13-17)

```yaml
- name: Checkout Code
  uses: actions/checkout@v4
  with:
    fetch-depth: 0
```

### What It Does:
- Uses GitHub's official checkout action (`actions/checkout@v4`)
- Retrieves all source code from the repository at the current commit
- `fetch-depth: 0` clones the entire repository history (useful for versioning and analytics)

### Why It's Important:
- First step in any CI/CD pipeline
- Ensures the workflow has access to source code
- Prepares the runner environment for subsequent steps

### Key Features:
- ✅ Checks out to the default branch
- ✅ Includes full git history
- ✅ Works for both push and pull request events

---

## ✅ Task 2: Set Up the Appropriate JDK Version

### Implementation Details

**File**: `.github/workflows/ci.yml` (Lines 19-27)

```yaml
- name: Set up JDK ${{ matrix.java-version }}
  uses: actions/setup-java@v3
  with:
    java-version: ${{ matrix.java-version }}
    distribution: 'temurin'
    cache: maven
```

### What It Does:
- Sets up Java Development Kit (JDK) version 17
- Uses Temurin distribution (Eclipse Adoptium's high-quality JDK builds)
- Automatically caches Maven dependencies for faster builds
- Configures JAVA_HOME environment variable

### Why It's Important:
- Java applications require a specific JDK version
- Project specifies Java 17 in `pom.xml`
- Caching improves build performance

### Configuration Breakdown:

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `java-version` | 17 | JDK version specified in pom.xml |
| `distribution` | temurin | High-quality, free JDK distribution |
| `cache` | maven | Caches Maven dependencies |

### Verification Step (Added):
```yaml
- name: Display Java and Maven version
  run: |
    echo "Java Version:"
    java -version
    echo ""
    echo "Maven Version:"
    mvn --version
```

This step confirms:
- Java 17 is properly installed
- Maven is available and configured
- Build environment is ready

---

## ✅ Task 3: Install All Necessary Project Dependencies Using Maven

### Implementation Details

**File**: `.github/workflows/ci.yml` (Lines 37-39)

```yaml
- name: Install Dependencies
  run: mvn clean install -DskipTests
```

### What It Does:
- Executes `mvn clean install -DskipTests` command
- Removes previous build artifacts
- Downloads and installs all dependencies from `pom.xml`
- Skips tests during dependency installation for speed

### Maven Lifecycle Phases:

1. **clean** - Removes the `target/` directory
2. **install** - Compiles and installs artifacts to local repository

### Dependencies Installed (from pom.xml):

```
✓ Spring Boot Starter Web (v3.0.0)
✓ JUnit Testing Framework (v4.13.2)
✓ Spring Boot Test (v3.0.0)
```

### Why It's Important:
- Dependencies are required for compilation
- Maven handles version management
- Separate install step ensures all artifacts are available

### Performance Optimization:
- Uses `-DskipTests` to skip tests during installation
- Uses Maven cache from setup-java action
- Reduces overall build time

---

## ✅ Task 4: Compile the Application and Execute Unit Tests

### Implementation Details

**File**: `.github/workflows/ci.yml` (Lines 41-43)

```yaml
- name: Build and Run Tests
  run: mvn clean verify
```

### What It Does:
- Executes `mvn clean verify` command
- Performs complete build lifecycle:
  1. **clean** - Removes previous artifacts
  2. **compile** - Compiles source code
  3. **test** - Runs unit tests
  4. **package** - Creates JAR/WAR files
  5. **verify** - Verifies build integrity

### Compilation Process:

```
Source Code (Java)
        ↓
Maven Compiler Plugin (javac)
        ↓
Compiled Classes (.class files)
        ↓
target/classes/ directory
```

### Unit Tests Included:

**File**: `src/test/java/com/example/GreetingServiceTest.java`

Test Coverage:
```
✓ testGreetWithValidName() - Tests normal greeting
✓ testGreetWithDifferentName() - Tests with different input
✓ testGreetWithNullName() - Tests null handling
✓ testGreetWithEmptyName() - Tests empty string handling
✓ testGoodbye() - Tests goodbye message
✓ testAdd() - Tests arithmetic operation
✓ testAddWithNegativeNumbers() - Tests edge cases
✓ testSubtract() - Tests subtraction
✓ testSubtractWithNegativeResult() - Tests negative results
```

### Test Framework:
- **JUnit 4.13.2** - Industry standard Java testing framework
- **Maven Surefire Plugin** - Executes tests and generates reports
- Reports generated in: `target/surefire-reports/`

### Test Report Publishing:

```yaml
- name: Publish Test Results
  uses: EnricoMi/publish-unit-test-result-action@v2
  if: always()
  with:
    files: 'target/surefire-reports/**/*.xml'
    check_name: 'JUnit Test Results'
    comment_title: 'Test Results'
```

This step:
- Parses JUnit test reports
- Displays results in GitHub Actions UI
- Adds comments to pull requests
- Works even if build fails

---

## ✅ Task 5: Archive the Generated Build Artifacts

### Implementation Details

**File**: `.github/workflows/ci.yml` (Lines 51-62)

```yaml
- name: Archive Build Artifacts (JAR/WAR)
  if: success()
  uses: actions/upload-artifact@v3
  with:
    name: build-artifacts
    path: target/*.jar
    retention-days: 30
    
- name: Archive Test Reports
  if: always()
  uses: actions/upload-artifact@v3
  with:
    name: test-reports
    path: target/surefire-reports/
    retention-days: 30
```

### What It Does:

#### JAR Artifacts:
- Archives all compiled `.jar` files
- Includes executable JAR files for deployment
- Files stored:
  - `maven-ci-app-1.0.0.jar` (main artifact)
  - `maven-ci-app-1.0.0-jar-with-dependencies.jar` (fat JAR)

#### Test Reports:
- Preserves JUnit test results
- Allows historical test analysis
- XML format for programmatic access

### Artifact Details:

| Artifact | Location | Purpose | Retention |
|----------|----------|---------|-----------|
| JAR Files | `target/*.jar` | Deployment packages | 30 days |
| Test Reports | `target/surefire-reports/` | Test verification | 30 days |

### Accessing Artifacts:

1. Go to GitHub Actions tab
2. Click on the workflow run
3. Scroll to "Artifacts" section
4. Download desired files

### Why It's Important:
- Artifacts are deployable packages
- Test reports provide audit trail
- Retention policy manages storage
- Historical artifacts for rollback capability

---

## Complete Workflow Execution Flow

```
Repository Push/PR
    ↓
GitHub Actions Triggered
    ↓
Step 1: Checkout Code
    ↓
Step 2: Setup JDK 17
    ↓
Step 3: Verify Java/Maven
    ↓
Step 4: Install Dependencies
    ↓
Step 5: Compile & Test (mvn verify)
    ├─ Clean
    ├─ Compile Source
    ├─ Run Unit Tests
    ├─ Package JAR
    └─ Verify
    ↓
Step 6: Publish Test Results
    ↓
Step 7: Archive Artifacts
    ├─ JAR Files
    └─ Test Reports
    ↓
Step 8: Build Summary
    ↓
Workflow Completes
```

---

## Project File Structure

```
GitP6/
├── .github/workflows/ci.yml                        # ← GitHub Actions Workflow
├── src/
│   ├── main/java/com/example/
│   │   ├── Application.java                       # Entry point
│   │   └── GreetingService.java                   # Business logic
│   └── test/java/com/example/
│       └── GreetingServiceTest.java               # Unit tests
├── pom.xml                                        # Maven configuration
├── .gitignore                                     # Git rules
├── README.md                                      # Project documentation
└── WORKFLOW_GUIDE.md                              # This file
```

---

## Configuration Files Explanation

### pom.xml (Maven Configuration)

**Key Sections:**

```xml
<properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
</properties>
```
- Specifies Java 17 compilation

**Dependencies:**
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```
- Defines project dependencies
- Maven downloads automatically

**Build Plugins:**
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <!-- Runs unit tests -->
        </plugin>
    </plugins>
</build>
```
- Configures Maven plugins
- Surefire runs tests
- Compiler compiles code

---

## Running Locally vs GitHub Actions

### Local Machine
```bash
# Install dependencies
mvn clean install

# Run tests
mvn test

# Build artifact
mvn package
```

### GitHub Actions (Automatic)
```yaml
- Run: mvn clean install -DskipTests
- Run: mvn clean verify
- Archive artifacts
```

---

## Troubleshooting Guide

### Issue: Build Fails with "Java version mismatch"
**Solution**: Check `pom.xml` compiler.source and compiler.target properties
```xml
<maven.compiler.source>17</maven.compiler.source>
<maven.compiler.target>17</maven.compiler.target>
```

### Issue: Dependencies not downloading
**Solution**: Check network connectivity and Maven cache
```bash
mvn dependency:resolve
```

### Issue: Tests failing
**Solution**: Run tests locally first
```bash
mvn test -X  # Verbose output
```

### Issue: Artifacts not archiving
**Solution**: Ensure build succeeds (check test reports first)
- Review test output in GitHub Actions
- Fix failing tests
- Rebuild

---

## Next Steps & Enhancements

### Recommended Enhancements:

1. **Code Quality Analysis**
   - Add SonarQube scanning
   - Add code coverage reporting (JaCoCo)

2. **Security Scanning**
   - Add OWASP Dependency Check
   - Scan for CVEs

3. **Artifact Deployment**
   - Deploy to Docker registry
   - Deploy to Maven repository
   - Deploy to cloud platforms

4. **Notifications**
   - Slack notifications
   - Email alerts on failures

5. **Performance**
   - Cache dependencies more aggressively
   - Parallel test execution
   - Matrix builds for multiple Java versions

---

## Useful Commands Reference

```bash
# Build locally
mvn clean package

# Run tests with coverage
mvn clean test jacoco:report

# Generate project documentation
mvn javadoc:javadoc

# Check for vulnerabilities
mvn dependency-check:check

# Update dependencies
mvn dependency:tree

# Skip tests during build
mvn clean package -DskipTests
```

---

## Summary

✅ **All 5 Tasks Completed:**

1. ✓ **Checkout Code** - Retrieves source from GitHub
2. ✓ **Setup JDK** - Installs Java 17 environment
3. ✓ **Install Dependencies** - Downloads Maven dependencies
4. ✓ **Compile & Test** - Builds and tests application
5. ✓ **Archive Artifacts** - Saves JAR files and test reports

The workflow is production-ready and follows GitHub Actions best practices!
