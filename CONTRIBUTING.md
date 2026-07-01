# Contributing to MissionForce Architecture Skills

Thank you for your interest in contributing to the MissionForce Architecture Skills repository! This repository contains Claude Code skills for Salesforce solution design and architecture.

## Table of Contents

- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Contribution Guidelines](#contribution-guidelines)
- [Code Review Process](#code-review-process)
- [Reporting Issues](#reporting-issues)
- [Feature Requests](#feature-requests)

---

## Getting Started

### Prerequisites

Before contributing, ensure you have:

1. **Claude Code** installed ([https://claude.ai/code](https://claude.ai/code))
2. **Git** configured with your GitHub account
3. **Salesforce Knowledge Base MCP Server** (`kb-salesforce`) for testing
4. **Node.js** (v16 or higher) if working on npm packaging

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:

   ```bash
   git clone https://github.com/YOUR-USERNAME/missionforce-arch-skills.git
   cd missionforce-arch-skills
   ```

3. Add the upstream remote:

   ```bash
   git remote add upstream https://github.com/mmallingSFDC/missionforce-arch-skills.git
   ```

4. Verify remotes:

   ```bash
   git remote -v
   # origin    https://github.com/YOUR-USERNAME/missionforce-arch-skills.git (fetch)
   # origin    https://github.com/YOUR-USERNAME/missionforce-arch-skills.git (push)
   # upstream  https://github.com/mmallingSFDC/missionforce-arch-skills.git (fetch)
   # upstream  https://github.com/mmallingSFDC/missionforce-arch-skills.git (push)
   ```

---

## How to Contribute

### Types of Contributions

We welcome:

- 🆕 **New Skills** - Additional architecture/solution design skills
- 📚 **Documentation** - Improvements to README, guides, examples
- 🐛 **Bug Fixes** - Corrections to skill logic or instructions
- ✨ **Features** - Enhancements to existing skills
- 🔧 **Tooling** - Installation scripts, automation, configuration
- 📝 **KB Content** - New solution patterns, architecture guidance
- 🧪 **Testing** - Test cases, validation scripts

### What Makes a Good Contribution?

**For Skills**:
- ✅ Grounded in Salesforce Knowledge Base atoms (cite sources)
- ✅ Tested with real Salesforce architecture questions
- ✅ Clear trigger conditions and instructions
- ✅ Comprehensive documentation in README
- ✅ CHANGELOG entry describing changes

**For Documentation**:
- ✅ Clear, concise writing
- ✅ Code examples that work
- ✅ Updated table of contents if needed
- ✅ Proper markdown formatting

**For Bug Fixes**:
- ✅ Clear description of the bug
- ✅ Steps to reproduce (if applicable)
- ✅ Test case demonstrating the fix

---

## Development Workflow

### 1. Create a Feature Branch

Always work on a feature branch, never directly on `main`:

```bash
git checkout -b feature/your-feature-name
```

**Branch Naming Conventions**:
- `feature/` - New features or skills
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `chore/` - Maintenance, tooling, config

**Examples**:
- `feature/data-cloud-skill`
- `fix/kb-search-timeout`
- `docs/installation-guide`

### 2. Make Your Changes

#### Working on Skills

Skills are located in `skills/[skill-name]/`:

```
skills/
└── solution/
    ├── skill.md              # Agent instructions (main file)
    ├── README.md             # User documentation
    ├── CHANGELOG.md          # Version history
    ├── package.json          # npm metadata + claudeCode config
    ├── install.sh            # Installation script (optional)
    └── example-settings.json # Permissions template (optional)
```

**Important**: Do NOT add update check logic to individual skills. The repository uses a centralized `SessionStart` hook that auto-updates all skills before execution. See [docs/AUTO-UPDATE.md](docs/AUTO-UPDATE.md) for details.

**Key Files to Update**:
1. **`skill.md`** - Agent instructions (always update this)
2. **`README.md`** - User-facing documentation
3. **`CHANGELOG.md`** - Add entry under `[Unreleased]` section
4. **`package.json`** - Update version if releasing

#### Testing Your Changes

**Test locally before submitting**:

```bash
# Option 1: Symlink to global skills directory
ln -s "$(pwd)/skills/solution" ~/.claude/skills/solution

# Option 2: Test in a project
cp -r skills/solution /path/to/test-project/.claude/skills/

# Then invoke the skill in Claude Code
/solution
```

**Test Cases to Validate**:
- ✅ Skill triggers correctly
- ✅ KB search works with varied keywords
- ✅ Markdown document generates correctly
- ✅ All KB citations are valid
- ✅ No errors or warnings
- ✅ Instructions are clear to Claude

### 3. Commit Your Changes

Use **conventional commit messages**:

```bash
git add .
git commit -m "feat: add Data Cloud solution pattern guidance"
```

**Commit Message Format**:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Formatting, missing semicolons, etc.
- `refactor` - Code refactoring
- `test` - Adding tests
- `chore` - Maintenance, tooling

**Examples**:
```bash
feat(solution): add support for integration architecture patterns
fix(solution): correct KB search timeout handling
docs(readme): add troubleshooting section for KB sync
refactor(solution): simplify requirement clarification logic
chore(deps): update KB MCP server version reference
```

### 4. Keep Your Branch Updated

Regularly sync with upstream:

```bash
git fetch upstream
git rebase upstream/main
```

**If conflicts occur**:

```bash
# Resolve conflicts in your editor
git add .
git rebase --continue
```

### 5. Push Your Changes

```bash
git push origin feature/your-feature-name
```

**If you rebased** (and already pushed):

```bash
git push --force-with-lease origin feature/your-feature-name
```

### 6. Create a Pull Request

1. Go to GitHub and open a Pull Request
2. **Title**: Clear, descriptive (use conventional commit style)
3. **Description**: Include:
   - What changed and why
   - How to test
   - Related issues (if any)
   - Screenshots (if UI-related)

**PR Template**:

```markdown
## Summary
[Brief description of changes]

## Type of Change
- [ ] New skill
- [ ] Bug fix
- [ ] Documentation update
- [ ] Feature enhancement
- [ ] Refactor

## Changes Made
- [List key changes]

## Testing
- [ ] Tested locally with `/solution` skill
- [ ] Verified KB searches work
- [ ] Checked markdown document generation
- [ ] Validated KB citations

## Checklist
- [ ] Updated CHANGELOG.md
- [ ] Updated README.md (if needed)
- [ ] Followed commit message conventions
- [ ] Code is KB-grounded (cites sources)
- [ ] No breaking changes (or documented if necessary)
```

---

## Contribution Guidelines

### Code Standards

**Skill Instructions (`skill.md`)**:
- Write clear, imperative instructions for Claude
- Include examples for complex logic
- Cite KB atoms with [KA-XXXX] format
- Use markdown formatting (headers, lists, code blocks)
- Keep instructions focused and actionable

**Documentation (`README.md`)**:
- Write for users, not developers
- Include real-world examples
- Use clear section headers
- Provide troubleshooting guidance
- Keep language concise

**CHANGELOG.md**:
- Follow [Keep a Changelog](https://keepachangelog.com/) format
- Group changes: Added, Changed, Deprecated, Removed, Fixed, Security
- Use present tense: "Add feature" not "Added feature"

### KB-Grounded Guidance

All Salesforce solution guidance MUST:
- ✅ Reference Salesforce Knowledge Base atoms
- ✅ Use correct KB atom IDs [KA-XXXX]
- ✅ Cite sources in recommendations
- ✅ Never invent or guess Salesforce capabilities

### Breaking Changes

If your change breaks existing behavior:
1. Clearly document in PR description
2. Add `BREAKING CHANGE:` footer in commit message
3. Update version appropriately (major bump)
4. Provide migration guidance

**Example**:
```bash
git commit -m "feat: change KB search default limit to 20

BREAKING CHANGE: KB search now defaults to limit:20 instead of limit:15.
Users who relied on 15-result limit should explicitly set limit:15 in their searches."
```

### Performance Considerations

- Minimize KB search calls (batch related searches)
- Use appropriate KB search limits (balance coverage vs. speed)
- Avoid infinite loops in skill logic
- Consider token usage in generated documents

### Security

- Never commit credentials, API keys, or secrets
- Don't include sensitive Salesforce org data in examples
- Sanitize any logs or error messages
- Follow Salesforce security best practices in guidance

---

## Code Review Process

### What to Expect

1. **Initial Review** - Maintainer checks for basic requirements
2. **Detailed Review** - In-depth review of changes
3. **Feedback** - Comments, suggestions, or requested changes
4. **Approval** - Once all feedback addressed
5. **Merge** - PR merged to `main` branch

### Review Timeline

- **Triage**: Within 1 business day
- **Initial Review**: Within 2-3 business days
- **Follow-up**: Within 1-2 business days after feedback addressed

### Review Criteria

Reviewers will check:
- ✅ Follows contribution guidelines
- ✅ KB-grounded (for Salesforce guidance)
- ✅ Tested locally
- ✅ Documentation updated
- ✅ CHANGELOG updated
- ✅ Commit messages follow conventions
- ✅ No breaking changes (or documented)
- ✅ Code is clear and maintainable

### Addressing Feedback

1. **Read all comments** before making changes
2. **Ask questions** if feedback is unclear
3. **Make requested changes** in new commits
4. **Respond to comments** when done
5. **Request re-review** when ready

**Don't**:
- ❌ Force-push over feedback (use new commits during review)
- ❌ Argue without understanding the concern
- ❌ Ignore feedback
- ❌ Make unrelated changes in the same PR

---

## Reporting Issues

### Before Reporting

1. **Search existing issues** - May already be reported
2. **Check CHANGELOG** - May be fixed in unreleased version
3. **Test with latest version** - Ensure issue still exists

### Creating an Issue

Go to [GitHub Issues](https://github.com/mmallingSFDC/missionforce-arch-skills/issues) and provide:

**For Bugs**:
- Clear, descriptive title
- Steps to reproduce
- Expected behavior
- Actual behavior
- Environment details:
  - Claude Code version
  - KB MCP server version
  - Operating system
  - Skill version
- Error messages or logs
- Screenshots (if applicable)

**Issue Template**:

```markdown
**Description**
[Clear description of the bug]

**Steps to Reproduce**
1. Invoke `/solution`
2. Ask: "How do I..."
3. Observe error

**Expected Behavior**
[What should happen]

**Actual Behavior**
[What actually happened]

**Environment**
- Claude Code version: [e.g., 1.2.3]
- KB MCP server: [installed/not installed]
- OS: [e.g., macOS 14.5]
- Skill version: [e.g., 1.0.0]

**Error Message**
```
[Paste error here]
```

**Screenshots**
[If applicable]
```

---

## Feature Requests

### Before Requesting

1. **Check existing issues** - May already be requested
2. **Check CHANGELOG** - May be in [Unreleased] section
3. **Consider alternatives** - Is there another way to achieve this?

### Creating a Feature Request

Provide:
- **Use Case**: What problem does it solve?
- **Proposed Solution**: How would it work?
- **Alternatives**: What other approaches exist?
- **Additional Context**: Any other relevant information

**Feature Request Template**:

```markdown
**Problem Statement**
[Describe the problem this feature would solve]

**Proposed Solution**
[How would this feature work?]

**Use Case**
[Who would use this and why?]

**Alternatives Considered**
[What other approaches did you consider?]

**Additional Context**
[Any other relevant details]
```

---

## Community

### Code of Conduct

This project follows the Salesforce Community Code of Conduct:
- Be respectful and inclusive
- Assume good intentions
- Provide constructive feedback
- Focus on what's best for the community

### Getting Help

- **GitHub Issues**: For bugs and feature requests
- **Pull Requests**: For code discussions
- **Internal Salesforce**: Contact Solution Architecture team

### Recognition

Contributors will be recognized:
- In CHANGELOG.md for contributions
- In PR comments for reviews and feedback
- Through GitHub contribution graph

---

## Additional Resources

- [Claude Code Documentation](https://docs.claude.ai/code)
- [Salesforce Knowledge Base](https://github.com/salesforce-internal/project-kb-salesforce) (internal)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)

---

**Thank you for contributing to MissionForce Architecture Skills!**

For questions, open an issue or contact the maintainers.
