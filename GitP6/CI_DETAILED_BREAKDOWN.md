# ci.yml - Detailed Annotation Guide

This document provides a complete breakdown of every line in the GitHub Actions workflow file.

---

## File: `.github/workflows/ci.yml`

### PART 1: Workflow Metadata

```yaml
name: Java CI/CD Pipeline
```
- **Purpose**: Defines the display name shown in GitHub Actions tab
- **Where**: Top of workflow file
- **Visibility**: Appears in GitHub Actions UI

---

### PART 2: Workflow Triggers

```yaml
# Trigger the workflow on push to main and on pull requests
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
```

| Element | Meaning |
|---------|---------|
| `on:` | When to run this workflow |
| `push:` | Run when code is pushed |
| `branches: [ main, develop ]` | Only trigger on main or develop |
| `pull_request:` | Run on pull request creation |

**Execution Trigger Examples:**
- ✅ `git push origin main` → Workflow starts
- ✅ `git push origin develop` → Workflow starts
- ✅ Pull request to main → Workflow starts
- ❌ `git push origin feature-branch` → Workflow skipped

---

### PART 3: Jobs Definition

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
```

| Element | Purpose |
|---------|---------|
| `jobs:` | Container for all jobs |
| `build:` | Name of this job (user-defined) |
| `runs-on: ubuntu-latest` | OS to run job on |

**Available Operating Systems:**
- `ubuntu-latest` - Latest Ubuntu Linux
- `macos-latest` - macOS
- `windows-latest` - Windows
- Specific versions: `ubuntu-22.04`, `ubuntu-20.04`

---

### PART 4: Strategy Matrix (Java Version Testing)

```yaml
    strategy:
      matrix:
        java-version: ['17']
```

**What it does:**
- Defines variables for matrix builds
- Creates parallel job runs for different configurations

**Current Configuration:**
```
┌─ Java 17 (one build)
└─ Could be: ['17', '21'] for multiple Java versions
```

**Example: Multi-version Testing**
```yaml
java-version: ['17', '21']
# Would create 2 parallel jobs:
# - One with Java 17
# - One with Java 21
```

---

### PART 5: Steps - Checkout Code

```yaml
    steps:
    # Step 1: Check out the source code from the repository
    - name: Checkout Code
      uses: actions/checkout@v4
      with:
        fetch-depth: 0
```

**Breaking it down:**

| Property | Value | Explanation |
|----------|-------|-------------|
| `name:` | Checkout Code | Human-readable step name |
| `uses:` | actions/checkout@v4 | GitHub's checkout action |
| `fetch-depth:` | 0 | Clone entire history (0 = all commits) |

**What happens:**
```
1. Step receives trigger (push/PR)
2. Downloads entire repository
3. Checks out the commit/branch
4. Prepares files for next steps
```

**Alternative fetch-depth:**
```yaml
fetch-depth: 1        # Only latest commit (faster)
fetch-depth: 0        # All commits (full history)
fetch-depth: 10       # Last 10 commits
```

---

### PART 6: Setup Java Development Kit

```yaml
    # Step 2: Set up the appropriate JDK version
    - name: Set up JDK ${{ matrix.java-version }}
      uses: actions/setup-java@v3
      with:
        java-version: ${{ matrix.java-version }}
        distribution: 'temurin'
        cache: maven
```

**Variable Substitution:**
```yaml
${{ matrix.java-version }}   # Replaced with '17' from matrix
# Result: "Set up JDK 17"
```

**Configuration Details:**

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `java-version:` | 17 | Which JDK to install |
| `distribution:` | temurin | JDK source (Eclipse Adoptium) |
| `cache:` | maven | Caches Maven dependencies |

**JDK Distributions (alternatives):**
```yaml
distribution: 'temurin'       # Recommended (best quality)
distribution: 'zulu'          # Azul Systems
distribution: 'corretto'      # Amazon Corretto
distribution: 'adopt'         # AdoptOpenJDK
distribution: 'liberica'      # BellSoft
```

**What gets installed:**
```
✓ Java 17 JDK
✓ JAVA_HOME environment variable
✓ Maven (if not present)
✓ Gradle (if not present)
✓ Maven dependency cache
```

**Environment after this step:**
```bash
$ java -version
openjdk version "17.0.x"
$ mvn --version
Apache Maven 3.8.x
$ echo $JAVA_HOME
/opt/java/openjdk
```

---

### PART 7: Display Java & Maven Versions

```yaml
    # Step 3: Display Java and Maven versions (verification)
    - name: Display Java and Maven version
      run: |
        echo "Java Version:"
        java -version
        echo ""
        echo "Maven Version:"
        mvn --version
```

**Breaking it down:**

| Element | Purpose |
|---------|---------|
| `run:` | Execute shell command |
| `echo "..."` | Print to console |
| `java -version` | Show installed Java version |
| `mvn --version` | Show Maven version |
| `\|` (pipe) | Multiple commands |

**Output example:**
```
Java Version:
openjdk version "17.0.9" 2023-09-19
OpenJDK Runtime Environment (build 17.0.9+9)

Maven Version:
Apache Maven 3.8.7
Maven home: /usr/share/maven
```

**Why this step:**
- Verify correct JDK is installed
- Ensure Maven is available
- Debug environment issues

---

### PART 8: Install Dependencies

```yaml
    # Step 4: Install project dependencies using Maven
    - name: Install Dependencies
      run: mvn clean install -DskipTests
```

**Maven Command Breakdown:**

```
mvn clean install -DskipTests
│   │     │       └── Skip test execution
│   │     └── Install artifacts to local repo
│   └── Remove target/ directory
└── Maven command
```

**Lifecycle Phases Executed:**

```
1. validate   - Validates project is correct
2. clean      - Removes target/ directory
3. compile    - Compiles source code
4. process-test-sources
5. test-compile
6. install    - Installs JAR to ~/.m2/repository
```

**Key Flag: -DskipTests**
```
✓ Compiles tests but doesn't run them
✓ Saves time during dependency installation
✓ Tests run later in separate step
```

**What gets downloaded:**
```
From pom.xml <dependencies>:
  ✓ org.springframework.boot:spring-boot-starter-web
  ✓ junit:junit
  ✓ org.springframework.boot:spring-boot-starter-test
  + transitive dependencies (100+ JARs)
```

**Cache Benefits:**
```
First run:  3-4 minutes (downloads all)
Next run:   30 seconds  (uses cache)
Savings:    10x faster builds
```

---

### PART 9: Compile & Run Tests

```yaml
    # Step 5: Compile the application and execute unit tests
    - name: Build and Run Tests
      run: mvn clean verify
```

**Maven Command Breakdown:**

```
mvn clean verify
│   │     └── Verify build is correct
│   └── Clean previous artifacts
└── Maven
```

**Lifecycle Phases Executed:**

```
1. clean              - Remove target/
2. validate           - Check config
3. compile            - Compile source (.java → .class)
4. process-test-sources
5. test-compile       - Compile test classes
6. test               - Run unit tests using Surefire
7. package            - Create JAR file
8. verify             - Check integrity
```

**Test Execution Details:**

```
Maven Surefire Plugin (configured in pom.xml)
  ↓
Finds test files matching:
  - **/*Test.java
  - **/*Tests.java
  ↓
Executes tests using JUnit 4
  ↓
Generates reports in:
  - target/surefire-reports/
```

**Test Classes Found & Run:**
```
✓ src/test/java/com/example/GreetingServiceTest.java
  - testGreetWithValidName()
  - testGreetWithDifferentName()
  - testGreetWithNullName()
  - testGreetWithEmptyName()
  - testGoodbye()
  - testAdd()
  - testAddWithNegativeNumbers()
  - testSubtract()
  - testSubtractWithNegativeResult()

Result: 9 tests, 9 passed ✓
```

**Generated Artifacts:**
```
target/
├── maven-ci-app-1.0.0.jar                   # Main artifact
├── maven-ci-app-1.0.0-jar-with-dependencies.jar
├── classes/                                 # Compiled .class files
├── test-classes/                            # Compiled test .class files
└── surefire-reports/                        # Test reports XML
    ├── TEST-com.example.GreetingServiceTest.xml
    └── testng-results.xml
```

---

### PART 10: Publish Test Results

```yaml
    # Step 6: Generate test reports
    - name: Publish Test Results
      uses: EnricoMi/publish-unit-test-result-action@v2
      if: always()
      with:
        files: 'target/surefire-reports/**/*.xml'
        check_name: 'JUnit Test Results'
        comment_title: 'Test Results'
```

**Configuration Details:**

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `uses:` | EnricoMi/publish-unit-test-result-action | Test report action |
| `if: always()` | Run even if previous steps fail | Show test results |
| `files:` | target/surefire-reports/**/*.xml | Find test reports |
| `check_name:` | JUnit Test Results | Display name in UI |
| `comment_title:` | Test Results | PR comment heading |

**The `if: always()` Condition:**

```yaml
if: success()      # Run only if all previous passed
if: failure()      # Run only if any previous failed
if: always()       # Always run (default behavior)
if: cancelled()    # Run if workflow was cancelled
```

**What it does:**
```
1. Parses XML test reports
2. Counts passed/failed tests
3. Displays summary in GitHub Actions UI
4. Adds comment to pull request
5. Creates check on commit

Examples of display:
  ✓ 9 tests passed
  ✗ 1 test failed (if applicable)
  ⏭️  2 tests skipped (if applicable)
```

**Pull Request Display:**
```
[GitHub UI Shows:]
┌─────────────────────────────┐
│ Test Results                │
├─────────────────────────────┤
│ ✓ 9 passed                  │
│ ✗ 0 failed                  │
│ ⏭️  0 skipped                │
└─────────────────────────────┘
```

---

### PART 11: Archive Build Artifacts

```yaml
    # Step 7: Archive the generated build artifacts
    - name: Archive Build Artifacts (JAR/WAR)
      if: success()
      uses: actions/upload-artifact@v3
      with:
        name: build-artifacts
        path: target/*.jar
        retention-days: 30
```

**Configuration Details:**

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `if: success()` | Run if build passed | Only archive successful builds |
| `uses:` | actions/upload-artifact@v3 | Upload artifact action |
| `name:` | build-artifacts | Artifact group name |
| `path:` | target/*.jar | Which files to archive |
| `retention-days:` | 30 | How long to keep artifacts |

**The `if: success()` Condition:**
```
Only archives if:
✓ Checkout successful
✓ JDK setup successful
✓ Dependencies installed
✓ Build passed
✓ Tests passed

Otherwise: Archive is skipped
```

**JAR Files Archived:**
```
target/
├── maven-ci-app-1.0.0.jar                    ✓ Archived
├── maven-ci-app-1.0.0-sources.jar            ✓ Archived
└── maven-ci-app-1.0.0-jar-with-dependencies  ✓ Archived
```

**Storage & Access:**
```
GitHub Artifacts Storage:
  Duration: 30 days
  Access: Download from Actions tab
  Size: ~10 MB per artifact
```

---

### PART 12: Archive Test Reports

```yaml
    - name: Archive Test Reports
      if: always()
      uses: actions/upload-artifact@v3
      with:
        name: test-reports
        path: target/surefire-reports/
        retention-days: 30
```

**Why `if: always()`:**
```
Test reports are valuable even if build fails
So they're saved regardless of success/failure
```

**Test Reports Archived:**
```
target/surefire-reports/
├── TEST-com.example.GreetingServiceTest.xml  ✓ Archived
├── testng-results.xml
└── ... (other report files)
```

**Contents of Test Reports:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="com.example.GreetingServiceTest" 
           tests="9" failures="0" skipped="0">
  <testcase name="testGreetWithValidName" 
            classname="com.example.GreetingServiceTest" time="0.001"/>
  <testcase name="testGreetWithDifferentName" 
            classname="com.example.GreetingServiceTest" time="0.001"/>
  <!-- ... 7 more tests ... -->
</testsuite>
```

---

### PART 13: Build Summary

```yaml
    # Step 8: Display build summary
    - name: Build Summary
      if: always()
      run: |
        echo "========================================="
        echo "BUILD SUMMARY"
        echo "========================================="
        echo "Build Status: ${{ job.status }}"
        echo "Java Version: ${{ matrix.java-version }}"
        echo "Repository: ${{ github.repository }}"
        echo "Branch: ${{ github.ref }}"
        echo "Commit: ${{ github.sha }}"
        echo "========================================="
```

**GitHub Context Variables:**

| Variable | Example Value |
|----------|---------------|
| `${{ job.status }}` | success, failure, cancelled |
| `${{ matrix.java-version }}` | 17 |
| `${{ github.repository }}` | username/repo-name |
| `${{ github.ref }}` | refs/heads/main |
| `${{ github.sha }}` | abc123def456... |

**Output Example:**
```
=========================================
BUILD SUMMARY
=========================================
Build Status: success
Java Version: 17
Repository: myuser/maven-ci-app
Branch: refs/heads/main
Commit: a1b2c3d4e5f6g7h8i9j0
=========================================
```

**Why this step:**
- Creates visible summary in logs
- Helpful for debugging
- Documents build context
- Easy to skim workflow results

---

## Complete Workflow Summary

```
WORKFLOW: Java CI/CD Pipeline

┌─────────────────────────────────────┐
│ 1. Checkout Code                   │ ✓ Task 1
├─────────────────────────────────────┤
│ 2. Setup JDK 17                    │ ✓ Task 2
├─────────────────────────────────────┤
│ 3. Display Versions (verify)       │
├─────────────────────────────────────┤
│ 4. Install Dependencies (Maven)    │ ✓ Task 3
├─────────────────────────────────────┤
│ 5. Compile & Test (mvn verify)     │ ✓ Task 4
├─────────────────────────────────────┤
│ 6. Publish Test Results            │
├─────────────────────────────────────┤
│ 7. Archive JAR Artifacts           │ ✓ Task 5
├─────────────────────────────────────┤
│ 8. Archive Test Reports            │ ✓ Task 5
├─────────────────────────────────────┤
│ 9. Build Summary                   │
└─────────────────────────────────────┘

All 5 required tasks completed! ✓
```

---

## Key Learnings

### Step Execution
- Steps execute sequentially (top to bottom)
- Each step builds on previous output
- Early step failure stops workflow

### Conditions (`if:` statement)
```yaml
if: success()      # Only if all previous passed
if: always()       # Regardless of previous status
if: failure()      # Only if previous failed
```

### Variable Substitution
```yaml
${{ variable }}    # Replaced with actual value
# Examples:
${{ github.sha }}           # Commit hash
${{ matrix.java-version }}  # Matrix value
${{ job.status }}           # Job status
```

### Caching
```yaml
cache: maven       # Speeds up builds 10x
# Caches: ~/.m2/repository/
```

---

This completes the detailed breakdown of the GitHub Actions workflow file!
