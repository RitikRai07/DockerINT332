@echo off
REM Setup script for GitP5 CI/CD project (Windows)

cls
echo ==========================================
echo   GitP5 CI/CD Pipeline Setup
echo ==========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git is not installed. Please install Git from https://git-scm.com/
    pause
    exit /b 1
)

echo [OK] Git is installed
echo.

REM Initialize git repository
if not exist .git (
    echo [*] Initializing Git repository...
    git init
    echo [OK] Git repository initialized
) else (
    echo [OK] Git repository already exists
)

echo.
echo ==========================================
echo   Configure GitHub Remote
echo ==========================================
echo.
echo Please provide your GitHub repository URL.
echo Format: https://github.com/username/repo.git
echo.

set /p github_url="Enter GitHub URL: "

if "%github_url%"=="" (
    echo ERROR: GitHub URL is required
    pause
    exit /b 1
)

REM Add remote
git remote get-url origin >nul 2>&1
if %errorlevel% equ 0 (
    echo [*] Updating existing remote...
    git remote set-url origin "%github_url%"
) else (
    echo [*] Adding new remote...
    git remote add origin "%github_url%"
)

echo [OK] Remote configured: %github_url%
echo.

REM Configure git user
echo ==========================================
echo   Configure Git User
echo ==========================================
echo.

set /p git_user="Enter your Git username (or press Enter to skip): "
if not "%git_user%"=="" (
    git config user.name "%git_user%"
    echo [OK] Git user set to: %git_user%
)

set /p git_email="Enter your Git email (or press Enter to skip): "
if not "%git_email%"=="" (
    git config user.email "%git_email%"
    echo [OK] Git email set to: %git_email%
)

echo.
echo ==========================================
echo   Commit and Push
echo ==========================================
echo.

echo [*] Adding files...
git add .

echo [*] Creating initial commit...
git commit -m "Initial CI/CD setup with Docker and GitHub Actions"

echo [OK] Commit created
echo.

echo [*] Checking current branch...
for /f "tokens=*" %%i in ('git rev-parse --abbrev-ref HEAD') do set branch=%%i

if "%branch%"=="master" (
    echo [*] Renaming branch to 'main'...
    git branch -M main
    echo [OK] Branch renamed to main
)

echo.
echo Ready to push? Run:
echo   git push -u origin main
echo.
echo ==========================================
echo   Setup Complete!
echo ==========================================
echo.
pause
