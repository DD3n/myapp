#!/bin/bash
# This script updates all files in your IDX environment by pulling the latest code
# from the GitHub repository at https://github.com/DD3n/myapp.
# It uses a forced pull (reset and clean) to ensure your local copy matches the remote exactly.
#
# Ensure your IDX environment is configured with your Git credentials (SSH keys or PAT).

REPO_DIR="myapp"
BRANCH="main"  # Update this if your default branch is different

if [ -d "$REPO_DIR" ]; then
  echo "Repository found in '$REPO_DIR'. Updating repository..."
  cd "$REPO_DIR"
  git fetch origin
  # Reset local branch to match remote branch exactly
  git reset --hard origin/$BRANCH
  # Remove untracked files and directories
  git clean -fdx
else
  echo "Repository not found. Cloning from GitHub..."
  git clone https://github.com/DD3n/myapp.git "$REPO_DIR"
fi

echo "Repository has been updated successfully."
