# MissionForce Architecture Skills

A collection of Claude Code skills for Salesforce solution design and architecture, grounded in authoritative Salesforce Knowledge Base guidance.

[![GitHub](https://img.shields.io/badge/GitHub-missionforce--arch--skills-blue?logo=github)](https://github.com/mmallingSFDC/missionforce-arch-skills)
[![License](https://img.shields.io/badge/license-Proprietary-red)](LICENSE)

**Repository**: [https://github.com/mmallingSFDC/missionforce-arch-skills](https://github.com/mmallingSFDC/missionforce-arch-skills)

---

## Overview

This repository provides reusable Claude Code skills that help solution architects, developers, and technical leads design comprehensive Salesforce solutions by:

- 🔍 **Researching** Salesforce capabilities through Knowledge Base integration
- 🏗️ **Architecting** native and alternative solutions
- 📊 **Evaluating** trade-offs across multiple approaches
- 📝 **Documenting** recommendations with KB citations
- ⚖️ **Assessing** risks, costs, and timelines

---

## Available Skills

### [Salesforce Solution Design](skills/solution/) `v1.1.0`

Design comprehensive Salesforce solutions grounded in Knowledge Base guidance.

**Use when**:
- "How do I implement [capability] in Salesforce?"
- "Design a solution for [use case]"
- "What are my options for [feature]?"
- "Should I use [Product A] or [Alternative B]?"

**What it does**:
1. ✅ Verifies KB MCP server access
2. 🎯 Clarifies ambiguous requirements
3. 🔍 Searches KB comprehensively
4. 📊 Evaluates native Salesforce solutions
5. 🔀 Recommends 3 alternatives (low/medium/high complexity)
6. 📝 Creates detailed markdown documentation
7. **🆕 Generates structured JSON output** (`solution-data.json`) for programmatic consumption

**Output**: 
- Markdown document with executive summary, architecture, comparison matrix, recommendations
- **JSON structured data** with epics array for BoE compatibility

📖 [Full Documentation](skills/solution/README.md)

---

### [Basis of Estimate (BoE) Generator](skills/boe/) `v2.0.0`

Generate structured Basis of Estimate XLSX (Excel) spreadsheets from solution data or scope documents.

**Use when**:
- "Create a BoE from [folder/documents]"
- "Generate a Basis of Estimate"
- "Estimate this scope"
- "Convert solution to BoE"

**Three input modes** (automatic detection):

1. **🚀 Mode 1: From Solution JSON (FAST)** - Transforms `solution-data.json` → XLSX (~10 sec)
2. **⚡ Mode 2: From Solution Markdown (FAST)** - Parses solution markdown → XLSX (~30 sec)
3. **🔄 Mode 3: From Raw Scope (FULL)** - Invokes `/solution` → synthesizes → XLSX (~5-10 min)

**What it does**:
1. 🔍 Checks for `solution-data.json` (fast path)
2. 📄 Auto-detects solution markdown documents
3. 🏗️ Invokes `/solution` for raw scope (if needed)
4. 📦 Breaks down into estimable Epics
5. 📊 Generates XLSX with 7 columns: Scope/Workstream, Epic Summary, Epic Description, Estimated Points, In/Out, Assumptions, Notes

**Output**: XLSX Basis of Estimate file ready for estimation and client delivery.

📖 [Full Documentation](skills/boe/README.md)

---

## How Skills Work Together

The skills are designed to complement each other with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                     User Question                            │
│  "Design a Salesforce solution for offline case management" │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
            ┌────────────────────────┐
            │   /solution Skill      │
            │  (Architecture Design) │
            └────────┬───────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
┌─────────────────┐    ┌─────────────────────┐
│  Markdown Doc   │    │  solution-data.json │ ← Structured data
│  (Human Read)   │    │  (Machine Read)     │
└─────────────────┘    └──────────┬──────────┘
                                  │
                                  │ Consumed by
                                  ▼
                     ┌─────────────────────────┐
                     │     /boe Skill          │
                     │  (BoE Formatting)       │
                     │  • Mode 1: From JSON    │ ← Fast (10s)
                     │  • Mode 2: From MD      │ ← Fast (30s)
                     │  • Mode 3: From Raw     │ ← Full (5-10min)
                     └──────────┬──────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │  BoE XLSX File  │
                       │  (7 columns)    │
                       └─────────────────┘
```

**Key Benefits**:
- ✅ `/solution` designs once, outputs are reusable
- ✅ `solution-data.json` consumed by multiple skills (BoE, roadmap, commercials)
- ✅ Fast paths when solution already exists
- ✅ Each skill has one clear purpose

**Example Workflow**:
```bash
# Step 1: Design solution
/solution "How do I implement Experience Cloud for case management?"
# → Creates: solution.md + solution-data.json

# Step 2: Generate BoE (uses JSON automatically)
/boe
# → Detects solution-data.json
# → Asks: "Use solution data (fast)?"
# → Creates: project-boe-2026-07-01.xlsx in 10 seconds
```

---

## Quick Start

### Prerequisites

1. **Claude Code** ([claude.ai/code](https://claude.ai/code))
2. **Salesforce Knowledge Base MCP Server** (`kb-salesforce`)
   - Repository: [salesforce-internal/project-kb-salesforce](https://github.com/salesforce-internal/project-kb-salesforce)
   - Requires Salesforce internal network/VPN access
3. **(Optional)** Grilling skills for requirement clarification:
   ```bash
   npx skills@latest add mattpocock/skills
   ```

### Installation

#### Option 1: Clone for Project Use

```bash
# Clone this repository
git clone https://github.com/mmallingSFDC/missionforce-arch-skills.git
cd missionforce-arch-skills

# Skills are available in .claude/skills/ for project use
```

#### Option 2: Install Globally

```bash
# Clone the repository
git clone https://github.com/mmallingSFDC/missionforce-arch-skills.git

# Symlink to global skills directory
ln -s "$(pwd)/missionforce-arch-skills/skills/solution" ~/.claude/skills/solution
```

#### Option 3: Copy to Project

```bash
# Copy skill to a specific project
cp -r skills/solution /path/to/your-project/.claude/skills/
```

### Auto-Update

This repository includes a **SessionStart hook** that automatically checks for updates when you start a Claude Code session. No manual update commands needed — skills are always current.

📖 See [docs/AUTO-UPDATE.md](docs/AUTO-UPDATE.md) for details on how it works.

### Configuration

Add to `.claude/settings.json` or project `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "mcp__kb-salesforce__kb_search",
      "mcp__kb-salesforce__kb_get",
      "Bash(python3 *)"
    ]
  }
}
```

---

## Usage

### Invoke Skills

```bash
# In Claude Code
/solution
```

Or simply ask Salesforce architecture questions:
- "How do I create Leads offline on mobile?"
- "What are my options for integrating Salesforce with an external system?"
- "Should I use Field Service Mobile or build a custom app?"

Claude Code will automatically invoke the relevant skill.

### Example Session

**User**: "How do I enable offline Lead creation for sales reps on mobile?"

**Claude** (using `/solution` skill):
1. Verifies KB MCP server is accessible
2. Clarifies: "Are these field sales reps or inside sales? Do they need full CRM or just Lead capture?"
3. Searches KB: "mobile offline", "Lead creation", "Field Service Mobile"
4. Evaluates: Native FSM vs. alternatives
5. Generates: Comprehensive solution document with 3 options

**Output**: `mobile-offline-lead-creation-solution.md` with:
- Executive summary
- Native solution architecture (Field Service Mobile)
- 3 alternatives (FormAssembly, Skuid, Custom PWA)
- Comparison matrix
- Scenario recommendations
- Risk assessment
- Implementation roadmap

---

## Repository Structure

```
missionforce-arch-skills/
├── .claude/
│   ├── CLAUDE.md              # Project-level instructions
│   └── settings.local.json    # Permissions configuration
├── skills/
│   └── solution/              # Salesforce Solution Design skill
│       ├── skill.md           # Agent instructions
│       ├── README.md          # User documentation
│       ├── CHANGELOG.md       # Version history
│       ├── package.json       # npm metadata
│       ├── install.sh         # Installation script
│       └── example-settings.json
├── CONTRIBUTING.md            # Contribution guidelines
└── README.md                  # This file
```

---

## Skills Roadmap

### Current Skills

- ✅ **Salesforce Solution Design** (v1.0.0) - Comprehensive solution architecture

### Planned Skills

- 🔜 **Integration Architecture** - Deep-dive on integration patterns
- 🔜 **Mobile Architecture** - Mobile-specific solution design
- 🔜 **Data Cloud Architecture** - Data Cloud and CDP solutions
- 🔜 **Security & Compliance Review** - Security assessment for solutions
- 🔜 **Field Service Optimization** - FSM-specific architecture
- 🔜 **Experience Cloud Design** - Portal and community solutions

Vote for or suggest skills via [GitHub Issues](https://github.com/mmallingSFDC/missionforce-arch-skills/issues).

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

**Quick Start**:

```bash
# Fork and clone
git clone https://github.com/YOUR-USERNAME/missionforce-arch-skills.git
cd missionforce-arch-skills

# Create a feature branch
git checkout -b feature/your-feature

# Make changes, test locally
ln -s "$(pwd)/skills/solution" ~/.claude/skills/solution

# Commit and push
git commit -m "feat: add new solution pattern"
git push origin feature/your-feature

# Open a Pull Request
```

**What to Contribute**:
- 🆕 New skills or solution patterns
- 📚 Documentation improvements
- 🐛 Bug fixes
- ✨ Feature enhancements
- 🧪 Test cases and examples

---

## Documentation

### Skill Documentation

- [Salesforce Solution Design - README](skills/solution/README.md)
- [Salesforce Solution Design - Changelog](skills/solution/CHANGELOG.md)

### Project Documentation

- [Contributing Guidelines](CONTRIBUTING.md)
- [Project Instructions (.claude/CLAUDE.md)](.claude/CLAUDE.md)

### External Resources

- [Claude Code Documentation](https://docs.claude.ai/code)
- [Salesforce Knowledge Base](https://github.com/salesforce-internal/project-kb-salesforce) (internal)
- [Salesforce Architect Resources](https://architect.salesforce.com/)

---

## Troubleshooting

### "KB MCP server not accessible"

**Cause**: Salesforce Knowledge Base MCP server not installed or configured.

**Fix**:
1. Install from [salesforce-internal/project-kb-salesforce](https://github.com/salesforce-internal/project-kb-salesforce)
2. Add to `~/.claude/settings.json`:
   ```json
   {
     "mcpServers": {
       "kb-salesforce": {
         "command": "node",
         "args": ["/path/to/kb-salesforce/build/index.js"],
         "env": {}
       }
     }
   }
   ```
3. Restart Claude Code

### "Skill not found"

**Cause**: Skill not in Claude Code's skill path.

**Fix**:
```bash
# Check if skill is in global or project skills directory
ls ~/.claude/skills/solution
ls .claude/skills/solution

# If not, symlink or copy
ln -s "$(pwd)/skills/solution" ~/.claude/skills/solution
```

### "Permission denied" for KB search

**Cause**: Permissions not configured for KB MCP tools.

**Fix**: Add to `.claude/settings.json`:
```json
{
  "permissions": {
    "allow": [
      "mcp__kb-salesforce__kb_search",
      "mcp__kb-salesforce__kb_get"
    ]
  }
}
```

---

## Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/mmallingSFDC/missionforce-arch-skills/issues)
- **Pull Requests**: [Contribute improvements](https://github.com/mmallingSFDC/missionforce-arch-skills/pulls)
- **Internal Salesforce**: Contact Solution Architecture team

---

## License

This repository is proprietary and intended for internal Salesforce use only.

---

## Acknowledgments

- **Built for**: [Claude Code](https://claude.ai/code) by Anthropic
- **Powered by**: Salesforce Knowledge Base MCP server
- **Integrates with**: `/grill-me` skill by Matt Pocock
- **Maintained by**: Michael Malling / Salesforce Solution Architects

---

## Quick Links

- 📖 [Full Documentation](skills/solution/README.md)
- 🤝 [Contributing Guidelines](CONTRIBUTING.md)
- 🐛 [Report an Issue](https://github.com/mmallingSFDC/missionforce-arch-skills/issues)
- 💡 [Request a Feature](https://github.com/mmallingSFDC/missionforce-arch-skills/issues)
- 🔀 [Submit a Pull Request](https://github.com/mmallingSFDC/missionforce-arch-skills/pulls)

---

**Repository**: [https://github.com/mmallingSFDC/missionforce-arch-skills](https://github.com/mmallingSFDC/missionforce-arch-skills)  
**Last Updated**: 2026-06-23
