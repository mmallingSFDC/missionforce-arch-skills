# Basis of Estimate (BoE) Skill

## Overview

The **BoE** skill transforms Salesforce scope documents into structured, estimable work packages (Epics) within a Basis of Estimate XLSX (Excel) file.

This skill acts as a **Salesforce Solution Architect** that:
1. Checks for existing `boe-wip.md` file to resume interrupted sessions
2. Reads client scope documents
3. Uses `/grill-me` skill to clarify ambiguous requirements and open questions
4. Uses `/solution` skill to design appropriate Salesforce architecture (grounded in KB)
5. Decomposes the solution into logical Epics
6. Generates an XLSX BoE with Workstreams, Epic Names, Summaries, and Assumptions
7. Maintains `boe-wip.md` file throughout (updated after each step for interruption resilience)

---

## When to Use

Invoke this skill when you need to:
- Create a Basis of Estimate from scope documents
- Translate client requirements into Salesforce Epics
- Break down a Salesforce solution into estimable work packages
- Document assumptions and risks for a scoping engagement

**Trigger phrases**:
- "Create a BoE from [folder]"
- "Generate a Basis of Estimate"
- "Estimate this scope"
- "Create an Epic breakdown"

---

## Prerequisites

### 1. `/solution` Skill (REQUIRED)

This skill **depends on the `/solution` skill** to design Salesforce architecture grounded in Salesforce Knowledge Base guidance.

**Verify `/solution` is available**:
- The skill will check for `/solution` access at startup
- If unavailable, it will STOP and warn you

**Why `/solution` is required**:
- Grounds architecture in Salesforce KB atoms (authoritative guidance)
- Prevents guessing at implementation approaches
- Provides constraints and limitations for assumptions
- Ensures estimates are based on real Salesforce capabilities

### 2. `/grill-me` Skill (RECOMMENDED)

This skill **uses the `/grill-me` skill** to systematically clarify ambiguous requirements before designing solutions.

**Verify `/grill-me` is available**:
- The skill will check for `/grill-me` access at startup
- If unavailable, it will WARN but not block (proceeds with assumptions)

**Why `/grill-me` is recommended**:
- Clarifies "open questions" and "TBD" items upfront (before estimation)
- Reduces re-estimation risk from incorrect assumptions
- Surfaces missing information early
- Provides structured clarification workflow

**If `/grill-me` is missing**, install it:
```bash
npx skills@latest add mattpocock/skills --yes
```

### 3. Scope Documents

You must provide scope documents in a folder. The skill will read:
- Markdown files (*.md)
- Word documents (*.docx)
- PDFs (*.pdf)
- Text files (*.txt)

**If you don't specify a folder, the skill will ask for one before proceeding.**

---

## What It Generates

### Output: XLSX Basis of Estimate

An Excel (XLSX) file with 7 columns:

| Column | Description | Owner |
|--------|-------------|-------|
| **Scope / Workstream** | Delivery phase or domain grouping (MVP, Core 1, Mule 1, etc.) | Skill assigns based on scope |
| **Epic Summary** | Short, concise name (5-15 words) | Skill generates |
| **Epic Description** | Detailed paragraph (100-300 words) | Skill generates |
| **Estimated Points** | Story points for estimation | **Left blank for user (or filled for "In" items)** |
| **In/Out** | Scope decision ("In" = included, "Out" = excluded) | Skill assigns based on scope analysis |
| **Assumptions** | Architecture/design assumptions (plain text, one per line, no bullets) | Skill generates from `/solution` and scope analysis |
| **Notes** | Additional context, rationale, references, open questions | Skill generates as needed |

---

## Interruption Resilience (WIP File)

The skill maintains a **`boe-wip.md`** (work-in-progress) file throughout execution:

### WIP File Purpose
- **Resume after interruption**: If the skill times out, errors, or is cancelled, you can re-run it and it will pick up where it left off
- **No duplicate work**: Already-completed `/solution` queries and Epics are skipped
- **Progress tracking**: Check `boe-wip.md` at any time to see % complete and current step
- **Audit trail**: Full record of all decisions, clarifications, and findings

### How It Works
1. **At session start**: Checks for existing `boe-wip.md`
   - If found: Reads WIP and resumes from "Current Step"
   - If not found: Creates new WIP and starts fresh
2. **During execution**: Updates WIP after every major step (reading docs, clarifying ambiguities, each `/solution` query, each Epic)
3. **At completion**: Archives WIP to `archive/boe-wip-[project]-[timestamp].md`

### Example Resume Scenario
```
1st Run:  /boe project-folder
          → Completes Steps 1-3, creates 5 Epics, then times out
          → boe-wip.md saved (60% complete)

2nd Run:  /boe project-folder
          → Finds boe-wip.md
          → Skips Steps 1-3 (already done)
          → Resumes creating remaining Epics from Step 4
          → Completes and generates XLSX
```

---

## How It Works

### Step-by-Step Workflow

1. **Check for WIP**:
   - Look for `boe-wip.md` to resume interrupted session
   - If found, skip to last completed step

2. **Prerequisites Check**:
   - Verify `/solution` and `/grill-me` skills are accessible
   - Confirm scope documents location with user
   - Create WIP file if starting fresh

3. **Read Scope Documents**:
   - List all files in provided folder
   - Read each document (md, docx, pdf, txt)
   - Flag any unreadable documents

3. **Analyze Scope**:
   - Extract business objectives, user personas, requirements, constraints
   - Identify 3-5 major solution areas

4. **Design Salesforce Solution** (via `/solution`):
   - Invoke `/solution` for each major capability
   - Example: "How do I implement offline mobile Work Order management?"
   - Read solution documents and capture recommendations, constraints, risks

5. **Decompose into Epics**:
   - Break down solution into feature-level Epics
   - Assign to Workstreams (MVP, Phase 1, Phase 2, etc.)
   - Common Epic types:
     - Data Model (objects, fields, relationships)
     - User Interface (Lightning pages, Screen Flows, mobile)
     - Business Logic (Apex, Flows, automation)
     - Integration (REST APIs, MuleSoft, Platform Events)
     - Security & Access (profiles, permission sets, sharing)
     - Reporting & Analytics (dashboards, reports)
     - Migration & Data (data loads, cleansing)
     - Testing & Quality (UAT, test scripts)
     - Training & Enablement (user training, documentation)

6. **Document Assumptions**:
   - **EVERY Epic has assumptions** (technology choices, scope clarifications, constraints, risks)
   - Assumptions surface uncertainty and risk
   - Honesty is critical: flag anything unclear or guessed

7. **Generate XLSX**:
   - Create `[project-name]-boe-[YYYY-MM-DD].xlsx`
   - Properly formatted Excel spreadsheet with styling, text wrapping, and auto-filter
   - Save to project directory

8. **Provide Summary**:
   - Total Epics, Workstreams, Solution Approach, Key Assumptions, Risks

---

## Example Usage

### Scenario 1: Army Field Service Project

**User**: "Create a BoE from the `army-field-service` folder"

**Skill Actions**:
1. ✅ Check `/solution` → Available
2. ✅ Read scope documents:
   - `requirements.md`
   - `technical-architecture.md`
   - `integration-overview.md`
3. **Analyze**: Field techs need offline Work Order management, real-time ERP sync
4. **Design** (via `/solution`):
   - `/solution` "How do I implement offline Work Order management?" → Field Service Mobile [KA-1986]
   - `/solution` "How do I integrate with SAP ERP?" → MuleSoft [KA-0855]
   - `/solution` "How do I build performance dashboards?" → Standard Reports [KA-1120]
5. **Epics Created**:
   - MVP: Configure FSM objects, Build mobile interface, Implement assignment automation, Set up security
   - Phase 1: ERP integration, Management dashboards
   - Phase 2: Einstein AI, Customer portal
6. **XLSX Generated**: `army-field-service-boe-2026-07-01.xlsx`

**Output Summary**:
```
**BoE Generated**: army-field-service-boe-2026-07-01.xlsx

**Summary**:
- Total Epics: 8
- Workstreams: MVP (4), Phase 1 (2), Phase 2 (2)
- Solution Approach: Field Service Mobile for offline, MuleSoft for ERP integration
- Key Assumptions:
  - FSM licenses available for 100 users
  - MuleSoft license available
  - Offline sync < 24 hours acceptable
  - SAP provides REST APIs

Next Steps: Review assumptions, add estimation points, validate phasing
```

---

## Assumptions Column: Critical Component

The **Assumptions column is the most important part of the BoE**.

### What to Include

Document assumptions such as:

1. **Technology choices** from `/solution`:
   - "Assumes Field Service Mobile is chosen solution (per /solution KA-1986)"
   - "Assumes MuleSoft for ERP integration (alternative: native REST API)"

2. **Scope clarifications** (inferred from vague requirements):
   - "Assumes 'real-time sync' means < 5 second latency (not true real-time)"
   - "Scope unclear on conflict resolution; assumes last-write-wins"

3. **Data and volume assumptions**:
   - "Assumes < 50,000 Work Orders per year"
   - "Assumes < 100 concurrent mobile users"

4. **Integration assumptions**:
   - "Assumes ERP provides REST API endpoints (documented API available)"
   - "Assumes external system can receive webhook calls"

5. **Licensing assumptions**:
   - "Assumes Field Service licenses available for 50 users"
   - "Assumes Data Cloud license procured"

6. **Constraints from KB** (via `/solution`):
   - "Note: Only Screen Flows execute offline; triggers will not fire until online (per KA-XXXX)"
   - "Note: Governor limits apply; max 50,000 SOQL queries per 24 hours"

7. **Risks flagged**:
   - "Risk: Custom PWA requires mobile dev expertise not in scope"
   - "Risk: ERP API availability not verified"

### Why Assumptions Matter

- **Surface risk** early in the engagement
- **Clarify ambiguity** in scope documents
- **Ground estimates** in explicit constraints
- **Enable negotiation** with client on scope interpretation

**Never hide uncertainty.** If you guess, document it.

---

## Common Pitfalls

1. ❌ **Proceeding without `/solution`** → Cannot ground BoE in real Salesforce capabilities
2. ❌ **Not reading all scope documents** → Miss critical requirements
3. ❌ **Single `/solution` call for entire scope** → Break into multiple targeted questions
4. ❌ **Hiding uncertainty** → Document ALL assumptions, never guess silently
5. ❌ **Too granular Epics** → "Add a button" is not an Epic; "Build mobile UI" is
6. ❌ **Too broad Epics** → "Implement Sales Cloud" is not estimable
7. ❌ **Ignoring KB constraints** → Document limitations from `/solution` as assumptions
8. ❌ **Empty Assumptions column** → EVERY Epic has assumptions (even if just tech choice)

---

## Integration with Other Skills

### `/solution` (REQUIRED)

This skill **wraps `/solution`** and structures the output into BoE format.

- `/solution` provides Salesforce architecture grounded in KB guidance
- BoE Generator translates architecture into Epics with assumptions

### `/grill-me` (OPTIONAL)

If scope is vague or ambiguous:
- Use `/grill-me` to clarify requirements BEFORE invoking `/solution`
- Clarifications become assumptions in the BoE

---

## Success Criteria

A successful BoE includes:

✅ `/solution` skill verified (or user warned)
✅ All scope documents read (or user informed of failures)
✅ 3-5 solution areas researched via `/solution`
✅ Epics at appropriate granularity (feature-level, not task-level)
✅ Workstreams assigned logically (MVP + phases)
✅ Every Epic has a concise summary (< 150 words)
✅ **Every Epic has documented assumptions**
✅ Any uncertainty flagged explicitly
✅ XLSX properly formatted, styled, and saved
✅ Summary provided to user

---

## Example BoE XLSX Output

**Spreadsheet structure** (7 columns):

| Scope / Workstream | Epic Summary | Epic Description | Estimated Points | In/Out | Assumptions | Notes |
|--------------------|--------------|------------------|------------------|--------|-------------|-------|
| Core 1 | Org Setup / Security / Role Hierarchy | Org standup on Gov Cloud Plus: My Domain, Company Information, sandbox strategy, Education Cloud package configuration. Role hierarchy for ~90 internal users. Shield encryption for PII/PHI fields. SSO integration with DoD authentication. | 30 | In | Platform is Salesforce Education Cloud on Gov Cloud Plus<br>Gov is responsible for end-to-end ATO process | |
| Core 1 | Student-Facing Applicant Portal | Experience Cloud site: conditional dynamic fields, document upload, application progress tracking, mobile-enabled. Sized for ~15,350 enrolled + ~7,500 non-enrolled CAHS students. | 60 | In | Student portal sized for ~23,000 total users<br>VPAT default configuration sufficient | Single shared org with permission-based data visibility |
| Core 1 | 50-Year Applicant History Storage | If native Gov Cloud Plus storage cannot meet 50-year retention requirements, an archival data flow from Salesforce to GCP (BigQuery or cold storage) is required. | | Out | Retention architecture TBD<br>No archival pipeline currently scoped | Requires architecture decision in Cycle 1 discovery |

**Note**: In the actual Excel file, Assumptions and Notes appear as multi-line text within cells (no bullet characters, just newlines).

---

## Troubleshooting

### Error: `/solution` skill not accessible

**Symptom**: Skill stops at prerequisites check with warning about `/solution`

**Resolution**:
- Ensure `/solution` skill is installed in `.agents/skills/solution/`
- Check that `solution` appears in the skills list
- Restart Claude Code if recently installed

### Error: Cannot read scope documents

**Symptom**: Skill reports it cannot read files in the provided folder

**Resolution**:
- Verify folder path is correct
- Check file permissions (especially PDFs and Word docs)
- Try converting unreadable files to markdown or text
- Proceed with readable documents only (skill will warn)

### XLSX formatting issues

**Symptom**: Excel displays formatting incorrectly or cells don't wrap

**Resolution**:
- Ensure commas in text are escaped with quotes
- Use `<br>` for line breaks in Assumptions column (not literal newlines)
- Test opening in Excel or Google Sheets

---

## File Naming Convention

**BoE XLSX**: `[project-name]-boe-[YYYY-MM-DD].xlsx`

Examples:
- `army-field-service-boe-2026-07-01.xlsx`
- `commercial-insurance-portal-boe-2026-07-01.xlsx`

---

## Version History

- **v1.0** (2026-07-01): Initial release
  - Prerequisites check for `/solution`
  - Comprehensive scope document reading
  - Epic decomposition with assumption documentation
  - XLSX generation with proper formatting and styling

---

## Contributing

To improve this skill:
1. Test with real scope documents
2. Refine Epic breakdown patterns
3. Add more assumption templates
4. Improve XLSX formatting and styling options

---

**Maintained by**: Matt Malling
**Last Updated**: 2026-07-01
