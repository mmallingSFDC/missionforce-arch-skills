# Salesforce Solution Design Skill

A reusable Claude Code skill for designing Salesforce solutions grounded in authoritative Salesforce Knowledge Base guidance.

## What It Does

This skill helps you design comprehensive Salesforce solutions by:

1. ✅ **Verifying KB Access** - Ensures Salesforce Knowledge Base MCP server is available
2. 🎯 **Clarifying Requirements** - Uses `/grill-me` for ambiguous questions
3. 🔍 **Researching Comprehensively** - Multiple KB searches with varied keywords
4. 📊 **Evaluating Native First** - Assesses what Salesforce provides out-of-the-box
5. 🔀 **Recommending Alternatives** - Provides 3 options (low/medium/high complexity)
6. 📝 **Creating Documentation** - Generates detailed markdown solution design documents

## Prerequisites

### Required

1. **Salesforce Knowledge Base MCP Server** (`kb-salesforce`)
   - Access to `https://github.com/salesforce-internal/project-kb-salesforce`
   - Configured in `~/.claude/settings.json`
   - Requires Salesforce internal network/VPN access
   - **The skill will check for this and guide installation if missing**

2. **KB Cache Synced**
   ```bash
   python3 ~/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/*/scripts/kb-sync.py
   ```

### Optional but Recommended

3. **Grilling Skills** (for requirement clarification)
   ```bash
   npx skills@latest add mattpocock/skills
   ```
   Provides: `/grill-me`, `/grilling`, `/grill-with-docs`

## Installation

### Option 1: Copy to Global Skills Directory

```bash
# Copy this skill to your global Claude Code skills directory
cp -r .agents/skills/solution ~/.agents/skills/

# Or create a symlink
ln -s "$(pwd)/.agents/skills/solution" ~/.agents/skills/solution
```

### Option 2: Use in Project Only

The skill is already available in this project at:

```
.agents/skills/solution/skill.md
```

### Option 3: Publish as npm Package

To make this skill installable via `npx skills@latest add`:

1. Create package structure:

   ```
   solution/
   ├── package.json
   ├── README.md
   └── skill.md
   ```

2. Publish to npm or GitHub
3. Install with: `npx skills@latest add your-org/solution`

## Usage

### Invoking the Skill

```
/solution
```

Or let Claude Code auto-detect when you ask Salesforce questions:

- "How do I implement [capability] in Salesforce?"
- "Design a solution for [use case]"
- "What are my options for [feature]?"
- "Should I use [Product A] or [Alternative B]?"

### Example Questions

**Mobile & Offline**:

- "How do I create Leads offline on mobile?"
- "What are the options for mobile data capture?"
- "Can Field Service Mobile work with custom objects?"

**Integration**:

- "How do I integrate Salesforce with an external system in real-time?"
- "What's the best way to sync data between Salesforce and our database?"
- "Should I use Platform Events or Change Data Capture?"

**Architecture**:

- "How do I build a customer portal?"
- "What are the options for embedding analytics?"
- "Can I extend Salesforce to support [custom requirement]?"

## What You Get

### Comprehensive Solution Document

The skill creates a markdown document with:

- **Executive Summary** - Key findings and recommendations
- **Native Salesforce Solution** - Architecture with KB citations [KA-XXXX]
- **Alternative Solutions** - 3 options (low/medium/high complexity)
- **Comparison Matrix** - Side-by-side evaluation
- **Scenario Recommendations** - Match solution to user profile/use case
- **Risk Assessment** - Limitations, costs, trade-offs per option
- **Implementation Roadmap** - Phases with timelines
- **KB References** - All cited atoms with titles

### Example Output

```markdown
# Mobile-First Lead Creation in Disconnected Environments

**Key Finding**: Native Salesforce offline capabilities are exclusive to
Field Service Mobile, designed for field service technicians not sales reps.

## Native Solution: Field Service Mobile [KA-1986]

[Detailed architecture...]

## Alternative Solutions

### Option 1: FormAssembly Mobile (Low Complexity)

- Timeline: 1-2 weeks
- Cost: Lower tier licensing
- Best for: Simple forms

### Option 2: Skuid Mobile (Medium Complexity)

- Timeline: 4-8 weeks
- Cost: Per-user licensing
- Best for: Balanced capability/ease

### Option 3: Custom PWA (High Flexibility)

- Timeline: 8-16 weeks
- Cost: Dev time only
- Best for: Complex requirements

[Comparison matrix, scenarios, risks...]
```

## Configuration

### Project-Level Settings

Add to `.claude/settings.local.json`:

```json
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
```

### Global Settings

For use across all projects, add KB permissions to `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": ["mcp__kb-salesforce__kb_search", "mcp__kb-salesforce__kb_get"]
  }
}
```

## Workflow

The skill follows this systematic process:

```
1. User asks Salesforce question
   ↓
2. ⚠️ Verify KB MCP server access
   ├─ ✅ Available → Continue
   └─ ❌ Not available → STOP, warn user, provide installation instructions
   ↓
3. Assess question clarity
   ├─ Clear → Continue
   └─ Ambiguous → Use /grill-me to clarify
   ↓
4. Search KB comprehensively (3+ searches)
   ↓
5. Retrieve detailed atoms (3-5 top results)
   ↓
6. Evaluate native Salesforce solution
   ↓
7. Recommend 3 alternatives (if native doesn't fit)
   ↓
8. Create comparison matrix
   ↓
9. Generate scenario recommendations
   ↓
10. Assess risks per option
   ↓
11. Create comprehensive markdown document
   ↓
12. Provide concise verbal summary
```

## KB MCP Server Setup

If the skill detects KB is unavailable, it will provide these instructions:

### 1. Check Current Configuration

```bash
cat ~/.claude/settings.json | grep -A 5 "kb-salesforce"
```

### 2. Access Requirements

- Salesforce GitHub access: `https://github.com/salesforce-internal/project-kb-salesforce`
- Salesforce network or VPN connection
- EIP access approval (if first time)

### 3. Install & Configure

Clone and build the KB MCP server, then add to `~/.claude/settings.json`:

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

### 4. Sync KB Cache

```bash
python3 ~/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/*/scripts/kb-sync.py
```

### 5. Restart Claude Code

## Troubleshooting

### "KB MCP server not accessible"

**Cause**: Server not installed or not configured correctly

**Fix**:

1. Check `~/.claude/settings.json` for `kb-salesforce` entry
2. Verify path to `build/index.js` is correct
3. Restart Claude Code after config changes

### "Access denied" to KB repository

**Cause**: No Salesforce GitHub access or not on VPN

**Fix**:

1. Ensure on Salesforce network or VPN
2. Request EIP access to repository
3. Verify GitHub SSH keys configured

### "KB cache empty or stale"

**Cause**: Cache never synced or outdated

**Fix**:

```bash
python3 ~/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/*/scripts/kb-sync.py
```

### "/grill-me skill not found"

**Cause**: Grilling skills not installed

**Fix**:

```bash
npx skills@latest add mattpocock/skills
```

## Best Practices

### For Skill Users

1. **Be specific in questions** - "How do I create Leads offline on mobile for sales reps?" vs. "mobile leads?"
2. **Provide context upfront** - User types, use cases, constraints
3. **Review the full document** - Verbal summary is just a teaser
4. **Validate KB citations** - Use [KA-XXXX] links to verify claims
5. **Consider scenarios** - Match recommendation to your actual situation

### For Skill Maintainers

1. **Keep KB synced** - Run weekly: `kb-sync.py`
2. **Update KB atom knowledge** - As new Salesforce products/features release
3. **Evolve solution patterns** - Add new common patterns as discovered
4. **Version the skill** - Track changes to instructions
5. **Test edge cases** - Ambiguous questions, KB unavailable scenarios

## Common Use Cases

### ✅ Great Fit

- **Solution architecture** - Native vs. custom evaluation
- **Product selection** - Which Salesforce cloud/product?
- **Mobile solutions** - Offline capabilities, FSM vs. alternatives
- **Integration patterns** - Real-time, batch, event-driven
- **Capability research** - Can Salesforce do X? What are limits?
- **Best practices** - Recommended patterns per KB guidance

### ⚠️ Not Ideal

- **Implementation details** - Step-by-step configuration (use docs)
- **Debugging issues** - Troubleshooting errors (use support)
- **Code generation** - Writing Apex/LWC (use code-focused skills)
- **Org-specific questions** - "What's wrong with MY org?" (needs context)

## Extending the Skill

### Adding New Solution Patterns

Edit `skill.md` and add to "Key Architectural Knowledge":

```markdown
#### [New Pattern Category]

- **[Pattern Name]**: [Description]
- **[When to use]**: [Guidance]
```

### Adding New KB Search Strategies

Add to "KB Search Strategy" section with examples.

### Creating Skill Variants

Create specialized versions:

- `salesforce-integration-design` - Integration-focused
- `salesforce-mobile-design` - Mobile-specific
- `salesforce-data-cloud-design` - Data Cloud-focused

## Version History

- **v1.0** (2026-06-22) - Initial release
  - KB prerequisite checking
  - `/grill-me` integration for clarity
  - 3-option recommendation framework
  - Comprehensive documentation generation

## License

[Specify license - MIT, Apache 2.0, Proprietary, etc.]

## Contributing

[Instructions for contributing improvements to the skill]

## Support

For issues or questions:

- Internal Salesforce: [Slack channel / mailing list]
- GitHub Issues: [If published to GitHub]

---

**Maintained by**: [Your Name/Team]
**Last Updated**: 2026-06-22
