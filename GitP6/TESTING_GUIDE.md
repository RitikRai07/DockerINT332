# Complete Testing Guide for GitHub Actions CI/CD Workflow

This guide helps you test and verify all 5 tasks of your GitHub Actions workflow.

---

## 📋 Testing Overview

### 5 Tasks to Test:
1. ✓ Code Checkout
2. ✓ JDK Setup
3. ✓ Dependency Installation
4. ✓ Compilation & Testing
5. ✓ Artifact Archival

### Testing Methods:
- **Local Testing** (Before GitHub push) - ✓ Fast feedback
- **GitHub Actions Testing** (After push) - ✓ Production-like environment
- **Artifact Verification** - ✓ Final validation

---

## PART 1: LOCAL TESTING (Recommended First)

### Prerequisites
Verify you have:
- Java 17 or higher
- Maven 3.6.0 or higher

### Step 1: Verify Java Installation

```bash
java -version
```

**Expected Output:**
```
openjdk version "17.0.x" 2023-09-19
OpenJDK Runtime Environment (build 17.0.x+...)
```

### Step 2: Verify Maven Installation

```bash
mvn --version
```

**Expected Output:**
```
Apache Maven 3.8.x
Maven home: C:\path\to\maven
```

### Step 3: Clean Build (Simulates GitHub Actions)

**Location**: `GitP6` folder

```bash
cd GitP6
mvn clean install
```

**What happens:**
- ✓ Validates project structure
- ✓ Downloads dependencies
- ✓ Compiles source code
- ✓ Compiles test code
- ✓ Runs tests
- ✓ Creates JAR files

**Expected Output:**
```
[INFO] --------< com.example:maven-ci-app >--------
[INFO] Building Maven CI Application 1.0.0
[INFO] --------
[INFO] 
[INFO] --- maven-clean-plugin:3.1.0:clean (default-clean) @ maven-ci-app ---
[INFO] 
[INFO] --- maven-resources-plugin:3.2.0:resources (default-resources) @ maven-ci-app ---
[INFO] 
[INFO] --- maven-compiler-plugin:3.11.0:compiler (default-compile) @ maven-ci-app ---
[INFO] 
[INFO] --- maven-surefire-plugin:3.0.0-M9:test (default-test) @ maven-ci-app ---
[INFO] 
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.example.GreetingServiceTest
[INFO] Tests run: 9, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] --------
[INFO] BUILD SUCCESS
[INFO] --------
[INFO] Total time: XX.XXs
```

### Step 4: Run Tests Only

```bash
mvn test
```

**Expected Output:**
```
[INFO] Tests run: 9, Failures: 0, Errors: 0, Skipped: 0
```

### Step 5: Compile Only

```bash
mvn compile
```

**Expected Output:**
```
[INFO] BUILD SUCCESS
```

### Step 6: Package (Create JAR)

```bash
mvn package
```

**Expected Output:**
```
[INFO] Building jar: C:\path\to\GitP6\target\maven-ci-app-1.0.0.jar
[INFO] BUILD SUCCESS
```

### Step 7: Verify JAR File Exists

**Windows PowerShell:**
```bash
ls target/*.jar
```

**Expected Output:**
```
    Directory: C:\Users\rrai2\OneDrive\Desktop\IMP Software\Devops\GitP6\target

Mode                 LastWriteTime         Length Name
----                 -----                 ------ ----
-a----         4/24/2026   2:30 PM      5234567 maven-ci-app-1.0.0.jar
-a----         4/24/2026   2:30 PM      7654321 maven-ci-app-1.0.0-jar-with-dependencies.jar
```

### Step 8: Run the JAR File

```bash
java -jar target/maven-ci-app-1.0.0.jar
```

**Expected Output:**
```
=========================================
Maven CI/CD Application Started
=========================================
Application Name: maven-ci-app
Version: 1.0.0
Build Date: 2026-04-24T14:30:00.000
Java Version: 17.0.x
=========================================
Hello, World! Welcome to Maven CI/CD Pipeline.
```

### Step 9: Check Test Reports

**Location**: `target/surefire-reports/`

```bash
ls target/surefire-reports/
```

**Expected Files:**
```
TEST-com.example.GreetingServiceTest.xml
testng-results.xml
```

**View Test Report (in text editor):**
- Open `target/surefire-reports/TEST-com.example.GreetingServiceTest.xml`
- Should show: 9 tests, 0 failures, 0 skipped

---

## LOCAL TESTING CHECKLIST

After running `mvn clean install`, verify:

- [ ] **Java 17 Installed**: `java -version` shows 17.x
- [ ] **Maven Installed**: `mvn --version` shows 3.6+
- [ ] **Dependencies Downloaded**: Build completes without errors
- [ ] **Code Compiles**: `BUILD SUCCESS` in output
- [ ] **9 Tests Run**: `Tests run: 9` in output
- [ ] **All Tests Pass**: `Failures: 0, Errors: 0` in output
- [ ] **JAR Created**: `target/maven-ci-app-1.0.0.jar` exists
- [ ] **JAR Executable**: `java -jar` runs without errors
- [ ] **Test Reports**: `target/surefire-reports/` contains XML

---

## PART 2: GITHUB ACTIONS TESTING

After local testing passes, push to GitHub and test the workflow.

### Step 1: Check GitHub Repository

1. Go to: **https://github.com/RitikRai07/Dockerclas**
2. Verify files are present:
   - ✓ `.github/workflows/ci.yml`
   - ✓ `pom.xml`
   - ✓ `src/` directory
   - ✓ Documentation files

### Step 2: Monitor Workflow Execution

1. Click **"Actions"** tab
2. Find **"Java CI/CD Pipeline"** workflow
3. Click on the workflow run
4. Watch the job execute

**Timeline:**
```
0:00  - Workflow starts
0:15  - Checkout Code ✓
0:30  - Setup JDK ✓
0:45  - Display Versions ✓
1:00  - Install Dependencies ✓
1:30  - Build and Run Tests ✓
2:00  - Publish Test Results ✓
2:15  - Archive Artifacts ✓
2:30  - Build Summary ✓
Total: ~2-3 minutes
```

### Step 3: Verify Each Step

**Click on each step to expand and verify:**

#### Step 1: Checkout Code
```
✓ Fetching source code
✓ Checking out commit 33b040b
✓ Repository ready
```

#### Step 2: Set up JDK 17
```
✓ Downloading JDK 17
✓ Setting JAVA_HOME
✓ Cache restored (faster second run)
```

#### Step 3: Display Java and Maven version
```
✓ openjdk version "17.0.x"
✓ Apache Maven 3.8.x
```

#### Step 4: Install Dependencies
```
✓ mvn clean install -DskipTests
✓ Dependencies downloaded
✓ BUILD SUCCESS
```

#### Step 5: Build and Run Tests
```
✓ mvn clean verify
✓ Tests run: 9
✓ Failures: 0
✓ BUILD SUCCESS
```

#### Step 6: Publish Test Results
```
✓ Test report parsed
✓ 9 passed, 0 failed
✓ Results published
```

#### Step 7: Archive Build Artifacts
```
✓ JAR files archived
✓ build-artifacts saved
✓ test-reports saved
```

#### Step 8: Build Summary
```
✓ Build Status: success
✓ Java Version: 17
✓ Repository: RitikRai07/Dockerclas
```

---

## GITHUB ACTIONS WORKFLOW CHECKLIST

### ✓ Task 1: Code Checkout
- [ ] Step 1 completes successfully
- [ ] Shows "Fetching source code"
- [ ] Displays commit hash (33b040b)

### ✓ Task 2: JDK Setup
- [ ] Step 2 completes successfully
- [ ] Shows "Downloading JDK 17"
- [ ] Step 3 shows Java 17.x
- [ ] Step 3 shows Maven 3.8+

### ✓ Task 3: Dependency Installation
- [ ] Step 4 completes successfully
- [ ] Shows "mvn clean install"
- [ ] Lists all dependencies
- [ ] Shows "BUILD SUCCESS"

### ✓ Task 4: Compilation & Testing
- [ ] Step 5 completes successfully
- [ ] Shows "mvn clean verify"
- [ ] Shows "Tests run: 9"
- [ ] Shows "Failures: 0"
- [ ] Shows "BUILD SUCCESS"

### ✓ Task 5: Artifact Archival
- [ ] Step 7 completes successfully
- [ ] Shows "Archive Build Artifacts"
- [ ] Shows "build-artifacts" saved
- [ ] Shows "test-reports" saved
- [ ] Artifacts retained for 30 days

---

## PART 3: ARTIFACT VERIFICATION

### Step 1: Download Artifacts from GitHub

1. Go to: **Actions** tab → **Latest workflow run**
2. Scroll to **"Artifacts"** section
3. Download:
   - `build-artifacts` (JAR files)
   - `test-reports` (Test results)

### Step 2: Extract and Verify JAR File

**Extract `build-artifacts.zip`:**
```bash
# PowerShell
Expand-Archive -Path build-artifacts.zip -DestinationPath artifacts
ls artifacts
```

**Expected Files:**
```
maven-ci-app-1.0.0.jar
maven-ci-app-1.0.0-jar-with-dependencies.jar
```

### Step 3: Test Downloaded JAR

```bash
java -jar artifacts/maven-ci-app-1.0.0.jar
```

**Expected Output:**
```
=========================================
Maven CI/CD Application Started
=========================================
Application Name: maven-ci-app
Version: 1.0.0
Build Date: ...
Java Version: 17.0.x
=========================================
Hello, World! Welcome to Maven CI/CD Pipeline.
```

### Step 4: Verify Test Reports

**Extract `test-reports.zip`:**
```bash
Expand-Archive -Path test-reports.zip -DestinationPath reports
ls reports
```

**Expected Files:**
```
TEST-com.example.GreetingServiceTest.xml
testng-results.xml
```

**View Report Content:**
- Open XML file in text editor
- Verify: `<testsuite ... tests="9" failures="0">`

---

## ARTIFACT VERIFICATION CHECKLIST

- [ ] `build-artifacts` downloads successfully
- [ ] Contains `maven-ci-app-1.0.0.jar`
- [ ] Contains `jar-with-dependencies.jar`
- [ ] JAR file is executable
- [ ] `test-reports` downloads successfully
- [ ] Contains test XML files
- [ ] Test file shows 9 tests run
- [ ] Test file shows 0 failures

---

## PART 4: TEST INDIVIDUAL COMPONENTS

### Test 1: GreetingService.greet() Method

**Local Test:**
```bash
mvn test -Dtest=GreetingServiceTest#testGreetWithValidName
```

**Expected:**
```
[INFO] Tests run: 1, Failures: 0, Errors: 0
```

### Test 2: All 9 Tests

**Local Test:**
```bash
mvn test
```

**Expected:**
```
[INFO] Tests run: 9, Failures: 0, Errors: 0, Skipped: 0
```

### Test 3: Maven Compilation

**Local Test:**
```bash
mvn compile
```

**Expected:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: X.XXXs
```

### Test 4: Dependency Resolution

**Local Test:**
```bash
mvn dependency:tree
```

**Expected Output (partial):**
```
com.example:maven-ci-app:jar:1.0.0
+- org.springframework.boot:spring-boot-starter-web:jar:3.0.0
+- junit:junit:jar:4.13.2
```

---

## TROUBLESHOOTING TEST FAILURES

### Issue: Java Version Error
**Symptom:** `[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.11.0:compile`

**Solution:**
```bash
java -version  # Verify Java 17
# If not 17, install Java 17
# Set JAVA_HOME environment variable
```

### Issue: Tests Fail Locally
**Symptom:** `Failures: 1 or more`

**Solution:**
```bash
mvn test -X  # Run with verbose output
# Check which test failed
# Review test output for errors
```

### Issue: Maven Not Found
**Symptom:** `'mvn' is not recognized`

**Solution:**
```bash
# Add Maven to PATH
# Or use: "C:\path\to\maven\bin\mvn"
```

### Issue: GitHub Actions Workflow Fails
**Symptom:** Red X on workflow run

**Solution:**
1. Click workflow run
2. Expand failed step
3. Read error message
4. Check logs for details
5. Fix locally and re-push

### Issue: Artifacts Not Archiving
**Symptom:** No "Artifacts" section in Actions

**Solution:**
- Ensure build succeeded (no red X)
- Verify tests passed
- Check if artifacts step has `if: success()`

---

## TEST EXECUTION SUMMARY

### Local Testing (Fast Feedback)
```bash
mvn clean install
mvn test
mvn package
java -jar target/maven-ci-app-1.0.0.jar
```

**Time:** ~2-3 minutes
**Feedback:** Immediate

### GitHub Actions Testing (Production-like)
```
Push to GitHub → Actions tab → Watch workflow
```

**Time:** ~2-3 minutes
**Feedback:** Visible in UI

### Artifact Verification
```
Download → Extract → Test JAR → Review Reports
```

**Time:** ~5 minutes
**Feedback:** Confirms deployability

---

## SUCCESS CRITERIA

### All Tests Pass When:

✅ **Local Testing:**
- `mvn clean install` shows BUILD SUCCESS
- `Tests run: 9, Failures: 0`
- JAR file executes without errors
- Test reports created

✅ **GitHub Actions:**
- All 8 steps show green checkmark
- "Build and Run Tests" shows 9 passed
- "Archive Build Artifacts" completes
- Artifacts available for download

✅ **Artifact Verification:**
- JAR files downloadable
- JAR files executable
- Test reports show 9 passed
- No errors in any logs

---

## QUICK REFERENCE COMMANDS

```bash
# Run full build (like GitHub Actions)
mvn clean verify

# Run only tests
mvn test

# Create JAR
mvn package

# Run application
java -jar target/maven-ci-app-1.0.0.jar

# View dependency tree
mvn dependency:tree

# Clean everything
mvn clean

# Compile only
mvn compile

# Run specific test
mvn test -Dtest=GreetingServiceTest

# Run with debug output
mvn test -X
```

---

## NEXT STEPS

1. ✅ Run local tests: `mvn clean install`
2. ✅ Verify all pass locally
3. ✅ Push to GitHub: `git push`
4. ✅ Watch workflow execute
5. ✅ Verify all 8 steps pass
6. ✅ Download and test artifacts
7. ✅ Verify JAR files work
8. ✅ Review test reports

**Once all tests pass → CI/CD pipeline is working! 🚀**

---

## ADDITIONAL VERIFICATION

### Check Commit Status on GitHub
1. Go to repository
2. Look for green checkmark on commit
3. Should show: "All checks passed"

### View Detailed Test Results
1. Actions tab → Workflow run
2. Step 6: "Publish Test Results"
3. Click "Details" to see test summary
4. Shows each test passed/failed

### Monitor Build Times
1. Track execution time (should be ~2-3 min)
2. Subsequent runs may be faster (caching)
3. Note any slowdowns for optimization

---

This completes the comprehensive testing guide!

**Ready to test? Start with local testing, then verify on GitHub!**
