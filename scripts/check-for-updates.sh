#!/bin/bash
# Auto-update check for MissionForce Arch Skills
# This script is called by the SessionStart hook in .claude/settings.local.json

# Get the project root (where this script lives)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_ROOT" || exit 1

# Check if we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Not a git repository. Skipping update check."
    exit 0
fi

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Uncommitted changes detected. Skipping auto-update."
    exit 0
fi

# Fetch latest from origin
echo "Fetching latest from origin..."
if ! git fetch origin 2>&1; then
    echo "Unable to fetch from origin. Check network connection."
    exit 0
fi

# Check if we're behind
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u} 2>/dev/null)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "Already up to date."
    exit 0
fi

# Pull latest (fast-forward only to be safe)
echo "Pulling latest changes for branch '$CURRENT_BRANCH'..."
if git pull --ff-only origin "$CURRENT_BRANCH" 2>&1; then
    echo "✅ Skills updated successfully!"
else
    echo "⚠️  Unable to auto-update. Manual pull may be required."
fi
