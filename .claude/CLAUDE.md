# Salesforce Solution Design Project

## Project Purpose

This project is dedicated to **Salesforce-specific solution design and architecture questions**. Use this workspace to:
- Design Salesforce solutions grounded in Knowledge Base guidance
- Evaluate native vs. 3rd party alternatives
- Create architecture documentation and recommendations
- Research Salesforce capabilities, constraints, and best practices

---

## Salesforce Knowledge Base Integration

### ⚠️ KB MCP Server Prerequisite Check

**BEFORE answering any Salesforce question**, verify the Salesforce Knowledge Base MCP server is installed and accessible:

1. **Check if KB tools are available** by attempting to search:
   - Try: `mcp__kb-salesforce__kb_search` 
   - If the tool is available, proceed normally
   - If the tool returns an error or is not found, **STOP and warn the user**

2. **If KB MCP server is NOT available**:
   - **WARN THE USER** immediately: "⚠️ The Salesforce Knowledge Base MCP server is not installed or not accessible. This project requires the KB to provide grounded, authoritative Salesforce guidance."
   - **DO NOT proceed with solution design** - recommendations would lack authoritative KB grounding
   - **Provide installation instructions** (see "KB MCP Server Installation" section below)
   - Wait for user to install/configure before continuing

3. **If KB server is available but sync needed**:
   - Run KB sync if cache is stale or empty
   - Proceed with solution design

### Always Use KB for Solution Design

When answering Salesforce-related questions (after verifying KB access), **ALWAYS search the Salesforce Knowledge Base first** using the `mcp__kb-salesforce__kb_search` and `mcp__kb-salesforce__kb_get` tools.

**The KB contains authoritative guidance** on:
- Salesforce product capabilities and limitations
- Architecture patterns and anti-patterns
- Configuration and setup procedures
- Field Service, Sales Cloud, Service Cloud, Platform features
- Mobile solutions (Field Service Mobile, Salesforce Mobile SDK)
- Integration patterns
- Data Cloud, Analytics, and other cloud-specific guidance

### KB Search Workflow

1. **Search First**: Use `mcp__kb-salesforce__kb_search` with relevant keywords
   - Search multiple times with different keyword combinations
   - Try variations: "mobile offline", "Field Service Mobile offline", "disconnected data sync"
   - Use `limit: 15` for comprehensive results

2. **Retrieve Details**: Use `mcp__kb-salesforce__kb_get` to fetch full atom content
   - Get the top 3-5 most relevant atoms
   - Read the full "What it says", "When to apply", "When NOT to apply" sections

3. **Cite Sources**: Always reference KB atoms in recommendations
   - Format: `[KA-XXXX]` in markdown documents
   - Include atom titles when first referenced
   - Ground all architecture decisions in KB guidance

4. **Never Guess**: If the KB doesn't have information, state that explicitly
   - Don't rely on general training knowledge for Salesforce-specific features
   - Acknowledge gaps in KB coverage
   - Suggest alternative research paths if needed

### KB Sync

The Salesforce Knowledge Base cache should be kept current. If you encounter KB sync errors or stale data:

```bash
python3 C:/Users/mmalling/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/1.2.2/scripts/kb-sync.py
```

### KB MCP Server Installation

**If the KB MCP server is not available**, guide the user through installation:

#### Installation Steps

1. **Check MCP server configuration**:
   ```bash
   # Check if kb-salesforce is registered in Claude Code settings
   cat ~/.claude/settings.json | grep -A 5 "kb-salesforce"
   ```

2. **Install from Salesforce internal repository** (requires Salesforce network access):
   - The `kb-salesforce` MCP server is part of the internal Scopezilla/Salesforce tooling
   - Repository: `https://github.com/salesforce-internal/project-kb-salesforce`
   - Requires Salesforce GitHub access and EIP (on network or VPN)

3. **Register MCP server** in Claude Code:
   - Add to `~/.claude/settings.json` under `mcpServers`:
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

4. **Sync KB cache** after installation:
   ```bash
   python3 C:/Users/mmalling/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/1.2.2/scripts/kb-sync.py
   ```

#### Troubleshooting

**Error: "Access denied" or "Repository not found"**
- Requires Salesforce GitHub access (internal employees only)
- Must be on Salesforce network or VPN
- Follow EIP access steps to request repository access

**Error: "MCP server connection failed"**
- Check `~/.claude/settings.json` configuration
- Verify node path and server build exists
- Restart Claude Code after configuration changes

**Error: "KB cache empty or sync failed"**
- Run kb-sync.py script manually
- Check network connectivity to Salesforce repos
- May need VPN connection for first-time sync

#### Alternative if KB Unavailable

If KB MCP server **cannot be installed** (non-Salesforce users, network issues):
- **Warn user** that recommendations will not be grounded in authoritative KB guidance
- **Rely on**:
  - Public Salesforce documentation (help.salesforce.com, developer.salesforce.com)
  - General architectural knowledge (clearly flagged as not KB-grounded)
  - External Salesforce resources (Trailhead, Architect site)
- **Clearly mark** all recommendations as "not grounded in internal KB" throughout document
- **Recommend** user validate all guidance against official Salesforce documentation

---

## Solution Design Approach

### 0. Clarify Ambiguous Questions (Use /grill-me)

**When the user's question is vague, underspecified, or ambiguous**, use the `/grill-me` skill to systematically clarify requirements BEFORE diving into solution design.

**Trigger /grill-me when**:
- Question lacks context about users, use case, or constraints
- Multiple interpretations possible ("mobile" could mean FSM, standard mobile app, custom app)
- Technical details missing (online/offline, objects involved, data volumes)
- Business drivers unclear (why this approach vs. alternatives)

**Example ambiguous questions**:
- "How do I create Leads on mobile?" → Unclear: offline? which users? which mobile app?
- "Can I integrate Salesforce with our system?" → Unclear: which system? real-time or batch? what data?
- "How do I sync data?" → Unclear: which direction? which objects? frequency? conflict handling?

**Process**:
1. Recognize ambiguity or missing context
2. Invoke `/grill-me` to ask clarifying questions
3. Collect user responses to narrow requirements
4. THEN proceed to KB search and solution design

**Benefits**:
- Avoid designing the wrong solution
- Surface hidden requirements early
- Ensure recommendations match actual needs
- Save time by focusing research on relevant areas

### 1. Understand the Requirement

After clarifying with `/grill-me` (if needed), ensure you understand:
- **Who** are the users (sales reps, field techs, admins, customers)?
- **What** is the core use case (create records, reports, integrations)?
- **Where** does it run (mobile, desktop, both; online/offline)?
- **When** does it need to work (real-time, batch, scheduled)?
- **Why** this approach (business drivers, constraints)?

### 2. Search KB Comprehensively

- Search for the **core capability** (e.g., "mobile offline")
- Search for **related objects** (e.g., "Lead creation mobile")
- Search for **technical components** (e.g., "Lightning Web Components offline")
- Search for **constraints** (e.g., "Field Service Mobile limitations")

### 3. Evaluate Native Solutions First

Always evaluate native Salesforce capabilities before recommending 3rd party solutions:
- What does Salesforce provide out-of-the-box?
- What are the constraints and limitations?
- What licensing is required?
- Does it fit the user profile and use case?

### 4. Recommend Alternatives When Appropriate

If native solutions don't fit, provide **3 alternative approaches**:
1. A **low-complexity** option (AppExchange, config-heavy)
2. A **medium-complexity** option (low-code platform, partner solution)
3. A **high-flexibility** option (custom development, full control)

Include for each:
- When to use it
- Pros and cons
- Rough timeline and cost considerations
- Risk assessment

### 5. Document in Markdown

Create structured markdown documents with:
- Executive summary with key findings
- Native Salesforce solution architecture (with KB references)
- Alternative solutions comparison
- Recommendation by scenario
- Risk assessment
- Implementation roadmap
- References section (KB atoms, external docs)

---

## Document Structure Template

```markdown
# [Solution Name]

**Document Date**: YYYY-MM-DD
**Purpose**: [One-line description]

---

## Executive Summary

[2-3 paragraphs with key findings and recommendation]

---

## Native Salesforce Solution: [Name]

### Overview
[High-level description with KB references]

### Architecture Components
[Detailed breakdown with KB citations]

### Implementation Roadmap
[Phases with timelines]

### Limitations
[Constraints and when NOT to use]

---

## Alternative Solutions

### Option 1: [Name]
**Best for**: [Use case fit]

[Details with pros/cons/cost/timeline]

### Option 2: [Name]
[...]

### Option 3: [Name]
[...]

---

## Comparison Matrix

| Criteria | Native | Option 1 | Option 2 | Option 3 |
|----------|--------|----------|----------|----------|
[...]

---

## Recommendation by Scenario

### Scenario 1: [Description]
**Recommended Solution**: [Name]
**Rationale**: [Why]

[More scenarios...]

---

## Risk Assessment

[Risks by solution option]

---

## References (Salesforce Knowledge Base)

- **[KA-XXXX]**: [Title]
[...]
```

---

## Common Salesforce Solution Patterns

### Mobile Solutions
- **Field Service Mobile**: Only native offline-capable mobile app (CRUD operations)
- **Salesforce Mobile App**: Standard mobile app (requires connectivity for writes)
- **Mobile SDK**: For custom mobile app development
- **Progressive Web Apps (PWA)**: Custom solution with offline via Service Workers
- **Mobile Publisher**: Branded mobile app (deprecated/limited)

### Integration Patterns
- **REST API**: Standard integration approach
- **Bulk API**: Large data volumes
- **Streaming API / Platform Events**: Real-time event-driven
- **Change Data Capture**: Near real-time data sync
- **MuleSoft / Integration Cloud**: Enterprise integration platform

### Data & Analytics
- **Data Cloud**: Customer 360, identity resolution, data harmonization
- **Einstein Analytics / Tableau CRM**: Embedded analytics
- **Reports & Dashboards**: Standard reporting
- **External data via Connect**: OData, external objects

### Extensibility
- **Lightning Web Components (LWC)**: Modern component framework
- **Apex**: Server-side business logic
- **Flow**: Declarative automation (Screen Flow, Record-Triggered, Scheduled)
- **Experience Cloud**: Customer/partner portals

---

## Key Architectural Principles

### Mobile-First Offline
1. **Assume disconnection** - design for offline-first, online-enhanced
2. **Local-first writes** - write to local storage, sync as background task
3. **Eventual consistency** - accept delayed sync, not immediate
4. **Conflict resolution** - plan for last-write-wins or user resolution
5. **Draft queues** - FIFO queue for pending operations

### Salesforce Platform Constraints
1. **Governor Limits** - SOQL queries, DML operations, heap size, CPU time
2. **API Limits** - Daily API call limits per org and per user
3. **Licensing** - Feature availability tied to licenses (Sales, Service, Field Service, etc.)
4. **Security Model** - Object/field permissions, sharing rules, profiles, permission sets
5. **Offline Execution** - Only Screen Flows execute offline (not triggers, not record-triggered flows)

### Integration Best Practices
1. **Bulkify** - Design for bulk operations, not single-record loops
2. **Async when possible** - Use @future, Queueable, Batch for long-running operations
3. **Idempotency** - Design integrations to safely retry
4. **Error handling** - Capture and surface errors, don't fail silently
5. **Logging** - Platform Events or custom objects for audit trail

---

## Pre-Authorized Commands

The following commands are pre-authorized in this project (no permission prompts):

### Salesforce Knowledge Base
- `mcp__kb-salesforce__kb_search` - Search KB atoms
- `mcp__kb-salesforce__kb_get` - Retrieve full KB atom content

### KB Sync
- `Bash(python3 *)` - KB sync script execution

### Skills Management
- `Bash(npx skills@latest *)` - Install/manage skills (e.g., mattpocock/skills)
- `/grill-me` - Clarify ambiguous requirements before solution design
- `/grilling` - General grilling skill
- `/grill-with-docs` - Grilling with documentation context

These permissions are configured in `.claude/settings.local.json`.

---

## Workflow for Salesforce Questions

1. **User asks Salesforce question**
   - Example: "How do I create Leads offline on mobile?"

2. **⚠️ PREREQUISITE CHECK: Verify KB MCP Server Access**
   - Attempt a test KB search to verify access
   - **If KB tools unavailable or error**:
     - **STOP immediately** - do not proceed with solution design
     - **Warn user**: "⚠️ Salesforce Knowledge Base MCP server is not accessible"
     - **Provide installation instructions** (see "KB MCP Server Installation" section)
     - **Wait for user** to install/configure before continuing
   - **If KB accessible**: Proceed to step 3

3. **Assess clarity and completeness**
   - Is the question clear and specific?
   - Are user profiles, use case, and constraints defined?
   - **If ambiguous or underspecified**: Use `/grill-me` to clarify BEFORE research
   - **If clear**: Proceed to KB search

4. **Search KB comprehensively**
   ```
   mcp__kb-salesforce__kb_search("mobile offline create records")
   mcp__kb-salesforce__kb_search("Lead creation mobile")
   mcp__kb-salesforce__kb_search("Field Service Mobile offline")
   ```

5. **Retrieve relevant atoms**
   ```
   mcp__kb-salesforce__kb_get("KA-XXXX")
   [Get top 3-5 atoms]
   ```

6. **Analyze and synthesize**
   - What native solutions exist?
   - What are the constraints?
   - Does it fit the use case?
   - What alternatives exist?

7. **Create markdown document**
   - Native solution architecture (with KB citations)
   - 3 alternative approaches
   - Comparison matrix
   - Recommendation by scenario
   - Save to this project directory

8. **Provide verbal summary**
   - Key finding (1-2 sentences)
   - Recommended approach
   - Point user to markdown document

---

## Example Questions This Project Handles

### Solution Design
- "How do I implement offline mobile data capture for [Object]?"
- "What's the best way to integrate Salesforce with [System]?"
- "How can I build a customer portal for [Use Case]?"
- "What are the options for real-time data sync between Salesforce and [Platform]?"

### Architecture Evaluation
- "Should I use Field Service Mobile or build a custom app?"
- "When should I use Platform Events vs. Change Data Capture?"
- "What's the difference between Experience Cloud and Sites?"

### Capability Research
- "Can Salesforce do [Capability] natively?"
- "What are the limitations of [Feature]?"
- "Which Salesforce cloud/product supports [Use Case]?"

### Best Practices
- "What's the recommended pattern for [Integration Pattern]?"
- "How do I handle [Constraint] in [Scenario]?"
- "What are the governor limits for [Operation]?"

---

## Output Standards

### All Recommendations Must Include
1. **KB citations** - Ground in authoritative guidance [KA-XXXX]
2. **Native option first** - Evaluate Salesforce capabilities before 3rd party
3. **Alternatives** - Provide 3 options at different complexity levels
4. **Scenarios** - Recommend by user profile and use case
5. **Risks** - Call out limitations, costs, and trade-offs
6. **Timeline & cost** - Rough estimates for planning

### Markdown Documents Should
- Be comprehensive but scannable (good headings, tables, lists)
- Include executive summary at top
- Reference KB atoms throughout
- Provide comparison matrix
- End with clear recommendations
- Include references section

### Don't
- Recommend solutions without KB research
- Guess at Salesforce capabilities
- Ignore licensing requirements
- Oversimplify trade-offs
- Skip risk assessment

---

## Project Maintenance

### Keep KB Current
Run KB sync weekly or when starting new solution design:
```bash
python3 C:/Users/mmalling/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/1.2.2/scripts/kb-sync.py
```

### Install Grilling Skills (First Time Setup)
If `/grill-me` or related skills are not available, install them:
```bash
npx skills@latest add mattpocock/skills
```

This installs 34 skills including:
- `/grill-me` - Clarify requirements
- `/grilling` - General grilling
- `/grill-with-docs` - Grilling with docs context
- Plus TypeScript, writing, and development workflow skills

### Organize Documents
- Save all solution designs to project root
- Use descriptive filenames: `[feature]-[object]-solution.md`
- Example: `mobile-offline-lead-creation-solution.md`

### Update This File
As you discover useful patterns or constraints, add them to this CLAUDE.md file for future reference.

---

## Quick Reference: Salesforce Clouds

- **Sales Cloud**: Leads, Opportunities, Accounts, Contacts, forecasting
- **Service Cloud**: Cases, knowledge, omni-channel, field service (with add-on)
- **Field Service**: Field Service Mobile, scheduling, work orders, service appointments
- **Marketing Cloud**: Email, journeys, segmentation (separate platform)
- **Commerce Cloud**: B2B/B2C commerce, storefronts, order management
- **Experience Cloud**: Customer/partner portals, communities
- **Data Cloud**: Customer 360, identity resolution, data harmonization
- **Analytics Cloud**: Einstein Analytics, Tableau CRM, embedded analytics
- **Platform**: Custom apps, objects, Apex, LWC, Flow, integrations (core platform)
- **Integration Cloud**: MuleSoft, APIs, connectors

---

---

## Available Skills

### /grill-me
Use to clarify ambiguous or underspecified questions before diving into solution design. Systematically asks clarifying questions to surface hidden requirements and ensure recommendations match actual needs.

**When to use**:
- User question lacks context or is vague
- Multiple interpretations possible
- Missing technical details (online/offline, objects, volumes, etc.)
- Business drivers or constraints unclear

**Other related skills available**:
- `/grill-with-docs` - Grilling with documentation context
- `/grilling` - General grilling skill

---

## Diagnostic Commands

### Check KB MCP Server Status
```bash
# Test if KB tools are accessible
# Will succeed if MCP server is running, fail if not installed/configured
mcp__kb-salesforce__kb_search("test")
```

### Check KB Cache Status
```bash
# Check KB sync metadata
python3 C:/Users/mmalling/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/1.2.2/scripts/kb-sync.py --status
```

### Verify MCP Server Configuration
```bash
# Check Claude Code settings for kb-salesforce server
cat ~/.claude/settings.json | grep -A 10 "kb-salesforce"
```

### Quick Setup Verification Checklist
- [ ] KB MCP server installed and configured in `~/.claude/settings.json`
- [ ] KB cache synced (run `kb-sync.py`)
- [ ] KB tools accessible (`mcp__kb-salesforce__kb_search` works)
- [ ] Grilling skills installed (`npx skills@latest add mattpocock/skills`)
- [ ] Project permissions configured (`.claude/settings.local.json`)

---

**Last Updated**: 2026-06-22
