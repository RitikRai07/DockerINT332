#!/bin/bash
# Setup script for GitP5 CI/CD project

echo "=========================================="
echo "  GitP5 CI/CD Pipeline Setup"
echo "=========================================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

echo "✅ Git is installed"
echo ""

# Initialize git repository
if [ ! -d .git ]; then
    echo "📁 Initializing Git repository..."
    git init
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

echo ""
echo "=========================================="
echo "  Configure GitHub Remote"
echo "=========================================="
echo ""
echo "Please provide your GitHub repository URL."
echo "Format: https://github.com/username/repo.git"
echo ""
read -p "Enter GitHub URL: " github_url

if [ -z "$github_url" ]; then
    echo "❌ GitHub URL is required"
    exit 1
fi

# Add remote
if git remote get-url origin &> /dev/null; then
    echo "Updating existing remote..."
    git remote set-url origin "$github_url"
else
    echo "Adding new remote..."
    git remote add origin "$github_url"
fi

echo "✅ Remote configured: $github_url"
echo ""

# Configure git user (if not already done)
echo "=========================================="
echo "  Configure Git User"
echo "=========================================="
echo ""

read -p "Enter your Git username (or press Enter to skip): " git_user
if [ ! -z "$git_user" ]; then
    git config user.name "$git_user"
    echo "✅ Git user set to: $git_user"
fi

read -p "Enter your Git email (or press Enter to skip): " git_email
if [ ! -z "$git_email" ]; then
    git config user.email "$git_email"
    echo "✅ Git email set to: $git_email"
fi

echo ""
echo "=========================================="
echo "  Commit and Push"
echo "=========================================="
echo ""

# Add all files
echo "Adding files..."
git add .

# Check if there are changes to commit
if git diff-index --quiet HEAD --; then
    echo "ℹ️  No changes to commit"
else
    echo "Creating initial commit..."
    git commit -m "🚀 Initial CI/CD setup with Docker & GitHub Actions"
    echo "✅ Commit created"
fi

# Rename branch to main (if on master)
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" = "master" ]; then
    echo "Renaming branch to 'main'..."
    git branch -M main
    echo "✅ Branch renamed to main"
fi

echo ""
echo "Ready to push? Run:"
echo "  git push -u origin main"
echo ""
echo "=========================================="
echo "  Setup Complete! ✅"
echo "=========================================="
