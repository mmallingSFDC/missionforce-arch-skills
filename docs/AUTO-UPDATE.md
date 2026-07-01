# Auto-Update System

## Overview

This repository uses a **centralized auto-update check** that runs automatically before any skill execution. This ensures all skills always have the latest updates without requiring per-skill update logic.

---

## How It Works

### 1. SessionStart Hook

When you open a Claude Code session in this project, a `SessionStart` hook automatically runs:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$PWD/scripts/check-for-updates.sh\"",
            "statusMessage": "Checking for MissionForce Arch Skills updates..."
          }
        ]
      }
    ]
  }
}
```

**Location**: `.claude/settings.local.json`

**When it runs**: 
- At the start of every Claude Code session in this project
- Before any skill execution begins
- Applies to ALL skills in the `skills/` directory

---

### 2. Update Check Script

The `scripts/check-for-updates.sh` script performs a safe, fast-forward-only update:

**What it does**:
1. ✅ Verifies you're in a git repository
2. ✅ Checks for uncommitted changes (skips update if found)
3. ✅ Fetches latest from `origin`
4. ✅ Checks if local branch is behind remote
5. ✅ Pulls latest changes (fast-forward only, won't overwrite local work)
6. ✅ Reports status (up-to-date, updated, or unable to update)

**Safety features**:
- **Non-destructive**: Only fast-forward pulls (won't overwrite uncommitted changes)
- **Fail-safe**: If update fails, session continues normally (doesn't block work)
- **Branch-aware**: Updates the current branch you're on
- **Conflict-aware**: Won't update if there are local changes or merge conflicts

---

## Benefits

### ✅ Centralized Maintenance
- One script handles updates for **all skills**
- No need to add update logic to each individual skill
- Update process changes in one place

### ✅ Always Current
- Skills are automatically updated at session start
- No manual "check for updates" command needed
- Users always work with latest features and fixes

### ✅ Safe & Transparent
- Fast-forward-only (won't lose local work)
- Status message shown at startup
- Clear feedback if update succeeds or fails

### ✅ Developer-Friendly
- Works seamlessly during development
- Won't interfere with uncommitted changes
- Branch-aware (updates your current branch)

---

## Configuration

### Project-Level Hook (`.claude/settings.local.json`)

This hook is **project-specific** — it only runs when working in the `missionforce-arch-skills` repository:

```json
{
  "permissions": {
    "allow": [
      "Bash(git fetch *)",
      "Bash(git pull --ff-only)",
      "Bash(bash \"$PWD/scripts/check-for-updates.sh\")"
    ]
  },
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$PWD/scripts/check-for-updates.sh\"",
            "statusMessage": "Checking for MissionForce Arch Skills updates..."
          }
        ]
      }
    ]
  }
}
```

**Why project-level?**
- Doesn't affect other projects
- Hook configuration travels with the repo
- Easy to share with other contributors

---

## Expected Behavior

### First Session Start

```
SessionStart: Checking for MissionForce Arch Skills updates...
Fetching latest from origin...
Pulling latest changes for branch 'main'...
✅ Skills updated successfully!
```

### Already Up-to-Date

```
SessionStart: Checking for MissionForce Arch Skills updates...
Already up to date.
```

### Uncommitted Changes (Safe)

```
SessionStart: Checking for MissionForce Arch Skills updates...
Uncommitted changes detected. Skipping auto-update.
```

### Network Issues (Fails Gracefully)

```
SessionStart: Checking for MissionForce Arch Skills updates...
Unable to fetch from origin. Check network connection.
```

---

## Manual Update

If the auto-update fails or you want to update manually:

```bash
# Option 1: Run the update script directly
bash scripts/check-for-updates.sh

# Option 2: Manual git pull
git fetch origin
git pull --ff-only
```

---

## Troubleshooting

### "Unable to auto-update"

**Possible causes**:
1. You have uncommitted changes (expected behavior, commit or stash first)
2. Your branch has diverged from remote (requires manual merge)
3. Network connectivity issues (VPN required for Salesforce internal repos)

**Resolution**:
```bash
# Check status
git status

# If uncommitted changes, commit or stash
git add .
git commit -m "WIP: local changes"

# Then pull manually
git pull --ff-only
```

### Hook Doesn't Run

**Check hook configuration**:
```bash
cat .claude/settings.local.json | grep -A 10 "hooks"
```

**Verify script is executable**:
```bash
ls -la scripts/check-for-updates.sh
# Should show: -rwxr-xr-x (executable)
```

**Re-add executable permission**:
```bash
chmod +x scripts/check-for-updates.sh
```

### Permission Prompts

If you see permission prompts for the update check, add to `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(bash \"$PWD/scripts/check-for-updates.sh\")",
      "Bash(git fetch *)",
      "Bash(git pull --ff-only)"
    ]
  }
}
```

---

## For Skill Developers

### Don't Add Update Logic to Skills

❌ **Don't do this in skill definitions**:
```markdown
## Prerequisites

1. Check for updates:
   ```bash
   git pull origin main
   ```
2. [Rest of prerequisites]
```

✅ **Instead, rely on the SessionStart hook**:
```markdown
## Prerequisites

The repository auto-updates at session start. Verify you have the latest:
- Check session startup message for update status
- If update failed, see [docs/AUTO-UPDATE.md](../docs/AUTO-UPDATE.md)
```

### Why?

- **DRY principle**: Update logic in one place
- **Maintainability**: Changes to update process don't require touching every skill
- **Reliability**: Hook runs before skills execute, ensuring consistency
- **User experience**: Seamless, no per-skill update commands needed

---

## Architecture Decision

**Question**: Why not per-skill update checks?

**Answer**: 
- **Redundancy**: Every skill would duplicate the same update logic
- **Maintenance burden**: Update process changes require modifying N files
- **Performance**: N skills = N git fetch/pull operations (slow)
- **Consistency**: Centralized hook ensures uniform behavior

**Trade-off**: 
- ✅ Pro: One update check covers all skills
- ⚠️ Con: Requires session restart to pick up updates (acceptable for typical usage)

---

## Related Files

- `.claude/settings.local.json` - Hook configuration
- `scripts/check-for-updates.sh` - Update check script
- `README.md` - Installation and quick start
- `CONTRIBUTING.md` - Development guidelines

---

**Last Updated**: 2026-07-01
