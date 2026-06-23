#!/bin/bash

# Salesforce Solution Design Skill - Installation Script
# This script sets up the skill for global or project-level use

set -e

SKILL_NAME="solution"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_SKILLS_DIR="$HOME/.agents/skills"
PROJECT_SKILLS_DIR="$(pwd)/.agents/skills"

echo "🔧 Salesforce Solution Design Skill Installer"
echo "=============================================="
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."
echo ""

# Check for Claude Code
if ! command -v claude &> /dev/null; then
    echo "⚠️  Warning: 'claude' command not found. Is Claude Code installed?"
fi

# Check for KB MCP server
echo "Checking KB MCP server configuration..."
if grep -q "kb-salesforce" ~/.claude/settings.json 2>/dev/null; then
    echo "✅ KB MCP server configuration found"
else
    echo "⚠️  KB MCP server not configured in ~/.claude/settings.json"
    echo "   The skill will guide you through setup when first used"
fi

echo ""
echo "Choose installation type:"
echo "  1) Global (available in all projects)"
echo "  2) Project only (current project only)"
echo "  3) Both"
echo ""
read -p "Enter choice [1-3]: " choice

case $choice in
    1|3)
        echo ""
        echo "📦 Installing globally to $GLOBAL_SKILLS_DIR/$SKILL_NAME..."

        # Create global skills directory if it doesn't exist
        mkdir -p "$GLOBAL_SKILLS_DIR"

        # Copy or symlink skill
        if [ -L "$GLOBAL_SKILLS_DIR/$SKILL_NAME" ]; then
            echo "   Removing existing symlink..."
            rm "$GLOBAL_SKILLS_DIR/$SKILL_NAME"
        elif [ -d "$GLOBAL_SKILLS_DIR/$SKILL_NAME" ]; then
            echo "   Backing up existing installation..."
            mv "$GLOBAL_SKILLS_DIR/$SKILL_NAME" "$GLOBAL_SKILLS_DIR/${SKILL_NAME}.backup.$(date +%s)"
        fi

        # Create symlink
        ln -s "$SCRIPT_DIR" "$GLOBAL_SKILLS_DIR/$SKILL_NAME"
        echo "✅ Global installation complete (symlinked)"
        ;;
esac

case $choice in
    2|3)
        echo ""
        echo "📦 Installing to project at $PROJECT_SKILLS_DIR/$SKILL_NAME..."

        # Create project skills directory if it doesn't exist
        mkdir -p "$PROJECT_SKILLS_DIR"

        # Copy skill (not symlink for project - you want it versioned)
        if [ -d "$PROJECT_SKILLS_DIR/$SKILL_NAME" ]; then
            echo "   Backing up existing installation..."
            mv "$PROJECT_SKILLS_DIR/$SKILL_NAME" "$PROJECT_SKILLS_DIR/${SKILL_NAME}.backup.$(date +%s)"
        fi

        cp -r "$SCRIPT_DIR" "$PROJECT_SKILLS_DIR/$SKILL_NAME"
        echo "✅ Project installation complete"
        ;;
esac

echo ""
echo "🔑 Checking project permissions..."

if [ ! -f ".claude/settings.local.json" ]; then
    echo "   Creating .claude/settings.local.json with recommended permissions..."
    mkdir -p .claude
    cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(python3 *)",
      "Bash(npx skills@latest *)",
      "mcp__kb-salesforce__kb_search",
      "mcp__kb-salesforce__kb_get"
    ]
  }
}
EOF
    echo "✅ Permissions configured"
else
    echo "   .claude/settings.local.json exists - please verify permissions manually"
    echo "   See example-settings.json for recommended configuration"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Ensure KB MCP server is installed and configured"
echo "  2. Run KB sync: python3 ~/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/*/scripts/kb-sync.py"
echo "  3. (Optional) Install grilling skills: npx skills@latest add mattpocock/skills"
echo "  4. Use the skill: /solution"
echo ""
echo "Documentation: See README.md for detailed usage instructions"
