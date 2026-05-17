# Maven CI/CD Application

A complete Java application setup with automated GitHub Actions CI/CD pipeline for building, testing, and deploying Java applications using Maven.

## Project Overview

This project demonstrates:
- ✅ Automated source code checkout
- ✅ JDK 17 setup and configuration
- ✅ Maven dependency management
- ✅ Application compilation
- ✅ Unit testing with JUnit
- ✅ Build artifact generation (JAR files)
- ✅ Test report publishing

## Project Structure

```
GitP6/
├── .github/
│   └── workflows/
│       └── ci.yml                 # GitHub Actions workflow configuration
├── src/
│   ├── main/
│   │   └── java/com/example/
│   │       ├── Application.java   # Main application entry point
│   │       └── GreetingService.java # Business logic service
│   └── test/
│       └── java/com/example/
│           └── GreetingServiceTest.java # Unit tests
├── pom.xml                         # Maven configuration
├── .gitignore                      # Git ignore rules
└── README.md                       # This file
```

## Technology Stack

- **Language**: Java 17
- **Build Tool**: Apache Maven 3.6+
- **Testing Framework**: JUnit 4.13.2
- **CI/CD Platform**: GitHub Actions
- **Framework**: Spring Boot 3.0.0

## CI/CD Pipeline Overview

The GitHub Actions workflow (`ci.yml`) performs the following steps:

### 1. **Code Checkout** 
   - Checks out the latest source code from the repository
   - Uses `actions/checkout@v4`

### 2. **JDK Setup**
   - Installs Java 17 (Temurin distribution)
   - Caches Maven dependencies for faster builds
   - Uses `actions/setup-java@v3`

### 3. **Dependency Installation**
   - Runs `mvn clean install -DskipTests`
   - Downloads and installs all project dependencies defined in `pom.xml`

### 4. **Compilation & Testing**
   - Runs `mvn clean verify`
   - Compiles the source code
   - Executes all unit tests
   - Generates test reports

### 5. **Artifact Archiving**
   - Archives generated JAR files
   - Saves test reports for analysis
   - Retains artifacts for 30 days

## Building and Testing Locally

### Prerequisites
- Java 17 or later
- Maven 3.6.0 or later

### Build Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd GitP6
   ```

2. **Install dependencies**
   ```bash
   mvn clean install
   ```

3. **Run tests**
   ```bash
   mvn test
   ```

4. **Build the application**
   ```bash
   mvn clean package
   ```

5. **Run the application**
   ```bash
   java -jar target/maven-ci-app-1.0.0.jar
   ```

## Maven Commands Reference

| Command | Purpose |
|---------|---------|
| `mvn clean` | Remove the target directory |
| `mvn compile` | Compile the source code |
| `mvn test` | Run unit tests |
| `mvn package` | Create JAR/WAR file |
| `mvn install` | Install the artifact in local repository |
| `mvn verify` | Run tests and package |
| `mvn clean install` | Clean, compile, test, and install |
| `mvn clean package` | Clean and create deployable package |

## GitHub Actions Workflow Details

### Triggers
The workflow is triggered on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

### Job Matrix
- Runs on Ubuntu Latest
- Java version: 17

### Artifacts Generated
- **Build Artifacts**: JAR files (30-day retention)
- **Test Reports**: JUnit XML reports (30-day retention)

## Test Coverage

The project includes unit tests for:
- ✅ Greeting service with valid names
- ✅ Greeting service with null/empty names
- ✅ Arithmetic operations (add, subtract)
- ✅ Goodbye message generation
- ✅ Error handling and validation

### Running Tests

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=GreetingServiceTest

# Run with detailed output
mvn test -X
```

## Build Artifacts

After a successful build, the following JAR files are generated in `target/`:

- `maven-ci-app-1.0.0.jar` - Executable JAR file
- `maven-ci-app-1.0.0-jar-with-dependencies.jar` - JAR with dependencies

## Troubleshooting

### Build Fails
1. Check Java version: `java -version` (should be 17+)
2. Check Maven version: `mvn --version` (should be 3.6+)
3. Clear Maven cache: `mvn clean`
4. Update dependencies: `mvn dependency:resolve`

### Tests Fail
1. Check test output: `mvn test -X`
2. Run specific test: `mvn test -Dtest=GreetingServiceTest`
3. Verify Java version matches pom.xml properties

### GitHub Actions Workflow Issues
1. Check workflow logs in GitHub Actions tab
2. Verify `.github/workflows/ci.yml` syntax
3. Ensure repository has appropriate secrets configured

## Contributing

1. Create a feature branch
2. Make changes and commit
3. Push to repository
4. Create a Pull Request
5. GitHub Actions will automatically test your changes

## License

This project is part of the DevOps training program.

## Support

For issues or questions:
- Check the GitHub Actions logs
- Review the workflow configuration in `.github/workflows/ci.yml`
- Consult the pom.xml for dependency versions
