# Changelog - BoE Skill

All notable changes to the **Basis of Estimate (BoE)** skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
