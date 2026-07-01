# Changelog - BoE Skill

All notable changes to the **Basis of Estimate (BoE)** skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.0.0] - 2026-07-01

### 🚀 MAJOR REDESIGN - Three Input Modes

**Breaking Change**: Complete skill redesign to complement `/solution` skill's new structured JSON output.

#### Three Input Modes (Automatic Detection)

**Mode 1: From Solution JSON (FAST PATH - NEW)**
- Detects `solution-data.json` from prior `/solution` run
- User confirms to use it
- Transforms JSON directly → BoE XLSX
- **Fastest path** - no re-analysis needed

**Mode 2: From Solution Markdown (FAST PATH - NEW)**
- Auto-detects solution markdown documents via pattern matching
- Detection signals: `## Native Salesforce Solution:`, `[KA-XXXX]` citations, `## Alternative Solutions`, etc.
- User confirms these are `/solution` outputs
- Parses markdown → BoE XLSX
- **Fast path** - minimal analysis

**Mode 3: From Raw Scope (FULL ANALYSIS - REFACTORED)**
- User provides raw scope documents
- Skill invokes `/solution` for architecture design
- Synthesizes responses → Epics → BoE XLSX
- **Full workflow** - comprehensive but slower

#### Key Improvements

✅ **Smart input detection** - Automatically recognizes solution outputs vs. raw scope
✅ **User control** - Always asks before assuming input mode
✅ **Fast paths** - Leverages `/solution`'s new JSON output for instant BoE generation
✅ **Simplified workflow** - Removed WIP file complexity (was over-engineered for the use case)
✅ **Cleaner prerequisites** - Streamlined skill availability checking
✅ **Better documentation** - Three example interaction flows showing each mode

#### Removed (Simplification)

- ❌ **WIP file management** - Removed `boe-wip.md` tracking (added complexity without clear benefit)
- ❌ **Verbose prerequisites** - Simplified skill availability checking
- ❌ **Multi-level resumption** - Not needed with faster workflows

#### Integration with `/solution` v1.1.0

This redesign depends on `/solution` v1.1.0's new feature:
- `/solution` now ALWAYS creates `solution-data.json` with structured data
- `solution-data.json` includes `epics` array designed for BoE compatibility
- BoE skill can consume this JSON directly (Mode 1) for instant XLSX generation

#### Migration Guide

**From v1.x to v2.0**:
- No breaking changes to XLSX output format (still 7 columns)
- WIP files from v1.4.0 are ignored (not read)
- If you have existing `/solution` markdown docs, skill auto-detects them (Mode 2)
- If you have `solution-data.json`, skill offers to use it (Mode 1)
- Otherwise, workflow is similar to v1.x (Mode 3)

### Why This Redesign?

**Problem**: v1.x overlapped heavily with `/solution` skill
- Both skills were designing architecture
- Both were breaking down epics
- Lots of duplicate work

**Solution**: Clear separation of concerns
- `/solution` = Architecture design + structured output
- `/boe` = BoE formatting with multiple input modes

**Benefits**:
- ⚡ **10x faster** when using Mode 1 or 2 (no re-design)
- 🎯 **Clear roles** - `/solution` designs, `/boe` formats
- 🔄 **Reusable data** - `solution-data.json` used by multiple skills
- 🧩 **Better composition** - Skills complement each other cleanly

---

## [1.4.0] - 2026-07-01

### Added - WIP File for Interruption Resilience

**Critical Enhancement**: BoE skill now creates and maintains a `boe-wip.md` (work-in-progress) file to track progress and enable resumption after interruption.

**New WIP File Management**:
- **Checks for existing WIP** at session start
  - If found: Reads WIP and resumes from "Current Step" and "Next Steps"
  - If not found: Creates new WIP file and starts fresh
- **Creates `boe-wip.md`** at the START of BoE generation
- **Updates WIP after EVERY major step**:
  - After reading scope documents (Step 1)
  - After clarifying ambiguities via `/grill-me` (Step 2)
  - After each `/solution` query and response (Step 3)
  - After each Epic created (Step 4)
  - After XLSX generation (Step 5)
- **Archives WIP when complete**:
  - Moves to `archive/boe-wip-[project]-[timestamp].md`
  - OR deletes if user prefers

**WIP File Contents**:
- Project name and scope folder path
- Progress summary (checklist of completed steps with % complete)
- Documents read (success and failures)
- Ambiguities identified and clarifications obtained
- All `/solution` queries executed and their findings
- All Epics created (with descriptions, assumptions, notes)
- Current step in workflow
- Next steps to complete
- Session state (ACTIVE or COMPLETE)

**Why This Change?**:
- **Interruption resilience**: Can resume after timeout, error, or user cancellation
- **No duplicate work**: Skips already-completed `/solution` queries and Epic creation
- **Progress tracking**: User can see exactly where BoE generation is at any moment
- **Audit trail**: Documents all decisions, clarifications, and findings
- **Debugging**: If generation fails, WIP shows exactly what was attempted
- **Follows `/solution` skill pattern**: Consistent WIP approach across skills

**Resume Example**:
```
User runs: /boe project-folder
Skill finds: boe-wip.md (85% complete, stopped at Step 4 - Epic creation)
Skill resumes: Reads WIP, skips Steps 1-3, continues creating remaining Epics
```

### Changed
- Updated "What it does" section to include WIP management (9 steps instead of 7)
- Updated Success Criteria to include WIP checks and updates
- Added new Step 0: Check for WIP and Resume (if applicable)
- Each workflow step now explicitly states "Update WIP after this step"

---

## [1.3.0] - 2026-07-01

### Added - Requirements Clarification via `/grill-me`

**Critical Enhancement**: BoE skill now uses `/grill-me` skill to systematically clarify ambiguous requirements BEFORE invoking `/solution` or generating estimates.

**New Step 2: Clarify Ambiguities and Open Questions**:
- **Scans scope documents** for ambiguity signals:
  - "Open question", "TBD", "to be determined", "pending"
  - Multiple options presented without decision
  - Dependencies on external inputs not yet received
  - Conditional statements and missing critical details
- **Uses `/grill-me` skill** to systematically resolve ambiguities through structured questioning
- **Documents clarifications** as assumptions with attribution (e.g., "per clarification on [date]")
- **Warns if `/grill-me` not available** but doesn't block (proceeds with assumptions flagged)

**Updated Prerequisites**:
- Now checks for BOTH `/solution` AND `/grill-me` skills
- Offers to install `/grill-me` (via `npx skills add mattpocock/skills`) if missing
- User can choose to proceed without `/grill-me` but all assumptions flagged prominently

**Why This Change?**:
- **Reduces re-estimation risk**: Clarifies ambiguities upfront instead of guessing
- **Improves accuracy**: Epics sized based on clarified requirements, not assumptions
- **Surfaces gaps early**: Identifies missing information before significant work invested
- **Follows best practice**: Requirements clarification is standard scoping discipline
- **Leverages skill composition**: `/boe` → `/grill-me` → `/solution` → XLSX generation

**Example Ambiguities Caught**:
- Architecture decisions not finalized (e.g., "GovSlack vs. Commercial Slack - which for Year 1?")
- External dependencies (e.g., "MOE documentation pending - when will it arrive?")
- Conditional scope (e.g., "Teams integration - which agencies need it?")
- Missing context (e.g., "mobile users" - field techs or sales reps?)

### Changed
- Updated "What it does" section to include Step 3: Clarifies Ambiguities
- Updated package.json to require `grill-me` skill (in addition to `solution`)
- Added "requirements-clarification" tag to skill metadata

---

## [1.2.0] - 2026-07-01

### Changed - Based on Real BoE Sample Analysis

**Column Structure (6 → 7 columns)**:
- **Added "Epic Description" column** (Column C): Full paragraph (100-300 words) explaining detailed scope
- **Added "Notes" column** (Column G): Additional context, rationale, references separate from Assumptions
- **Renamed columns** to match industry standard:
  - "Workstream" → "Scope / Workstream"
  - "Epic Name" → "Epic Summary" (now short name, 5-15 words)
  - "Epic Summary" → "Epic Description" (now detailed paragraph)
  - "Est. Points" → "Estimated Points"

**Assumptions Formatting**:
- Changed from bullet characters (`•`) to **plain text, one assumption per line**
- No bullet characters - just newline-separated statements
- Example: `"Assumption 1\nAssumption 2\nAssumption 3"`

**Styling Simplified**:
- **Removed**: Blue header background, freeze panes, auto-filter
- **Kept**: Bold headers, text wrapping on text-heavy columns
- Headers now: Bold text only (no background color)

**Semantic Changes**:
- Split "Epic Summary" into two distinct concepts:
  - **Epic Summary** = Short name (what it's called)
  - **Epic Description** = Full explanation (what will be built)
- Separated **Assumptions** (design decisions) from **Notes** (context/rationale)

### Why These Changes?
- Analyzed real `BOE Sample.xlsx` file (69 Epics, 7 columns)
- Aligns skill output with actual industry BoE format
- Clearer separation of Epic name vs. detailed description
- Assumptions as prose text (not bullets) matches stakeholder expectations
- Simpler styling (no colors) for easier editing and compatibility

## [1.1.0] - 2026-07-01

### Changed
- **Output format changed from CSV to XLSX (Excel)**
  - Generates `.xlsx` files instead of `.csv`
  - Includes Python `openpyxl` implementation pattern in SKILL.md
  - Bullet points in Assumptions column use `•` character with newlines (later changed to plain text in v1.2.0)
  - Column widths auto-sized for readability
- **Updated all documentation** (SKILL.md, README.md, package.json) to reflect XLSX output
- **Filename convention**: `[project-name]-boe-[YYYY-MM-DD].xlsx`

### Why XLSX?
- Better readability with text wrapping for multi-line cells
- Native Excel support for formatting (colors, fonts, alignment)
- Easier for stakeholders to work with (no CSV escaping issues)

## [1.0.1] - 2026-07-01

### Changed
- **Renamed skill** from `/boe-generator` to `/boe` for brevity
- Updated package.json name field

## [1.0.0] - 2026-07-01

### Added
- **Initial release** of BoE skill (originally named boe-generator)
- **Prerequisites validation** for `/solution` skill access
- **Scope document reading** from user-specified folder
  - Supports: Markdown (*.md), Word (*.docx), PDF (*.pdf), Text (*.txt)
- **Salesforce solution design** via `/solution` skill integration
  - Multiple targeted solution queries for different capabilities
- **Epic decomposition** logic with 9 Epic types:
  1. Data Model Epics
  2. User Interface Epics
  3. Business Logic Epics
  4. Integration Epics
  5. Security & Access Epics
  6. Reporting & Analytics Epics
  7. Migration & Data Epics
  8. Testing & Quality Epics
  9. Training & Enablement Epics
- **Workstream assignment** (MVP, Phase 1, Phase 2, etc.)
- **Assumption documentation** for every Epic
  - Technology choices, scope clarifications, constraints, risks
- **CSV generation** with proper formatting
  - Columns: Workstream, Epic Name, Epic Summary, Est. Points (blank), In/Out (blank), Assumptions
  - CSV escaping for commas, quotes, newlines
  - `<br>` formatting for bulleted assumptions
- **Honesty enforcement**: Flags ALL unclear requirements and assumptions explicitly
- **Error handling**: Stops and warns user if `/solution` unavailable or documents unreadable
- **Summary output**: Total Epics, Workstreams, Solution Approach, Key Assumptions, Risks
- **README.md** with comprehensive usage documentation
- **package.json** with skill metadata

### Design Decisions
- **Dependency on `/solution` skill**: Ensures all BoE Epics are grounded in Salesforce Knowledge Base guidance (not guesses)
- **Mandatory assumptions column**: Every Epic must document assumptions to surface risk and ambiguity
- **Feature-level Epics**: Avoids too-granular (task-level) or too-broad (cloud-level) breakdowns
- **Workstream flexibility**: Allows MVP/Phase or Release-based phasing per client preference

### Notes
- Skill is designed for Salesforce internal use (requires KB MCP server via `/solution`)
- Est. Points and In/Out columns left blank intentionally for user/PM to fill
- CSV filename format: `[project-name]-boe-[YYYY-MM-DD].csv`

---

## [Unreleased]

### Planned Enhancements
- [ ] Support for additional document formats (Google Docs, Confluence exports)
- [ ] Template library for common Epic types (CRM, Field Service, Data Cloud, etc.)
- [ ] Automated phasing recommendations based on Epic dependencies
- [ ] Risk scoring/categorization in Assumptions column
- [ ] Integration with estimation tools (Jira, Rally, etc.) for auto-import
- [ ] Multi-project BoE consolidation (rollup multiple BoEs)
- [ ] Alternative output formats (Excel, Google Sheets, JSON)

### Known Issues
- None reported yet

---

## Version History Summary

| Version | Date | Description |
|---------|------|-------------|
| 1.0.0 | 2026-07-01 | Initial release with core BoE generation workflow |

---

**Maintained by**: Matt Malling
