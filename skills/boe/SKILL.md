# Basis of Estimate (BoE) Generator

Generate a comprehensive Basis of Estimate XLSX (Excel) document from solution design data or scope documents.

## Trigger

Use this skill when the user asks to:
- "Create a BoE from [folder/documents]"
- "Generate a Basis of Estimate"
- "Estimate this scope"
- "Create an Epic breakdown for [project]"
- "Build a BoE spreadsheet"
- "Convert solution to BoE"

## What it does

This skill has **three input modes** with automatic detection:

### Mode 1: From Solution JSON (FAST PATH)
1. Detects `solution-data.json` from prior `/solution` run
2. Asks user to confirm using this data
3. Transforms JSON directly to BoE XLSX
4. **Fastest path** - no re-analysis needed

### Mode 2: From Solution Markdown Documents (FAST PATH)
1. Detects solution markdown documents (auto-detects patterns)
2. Asks user to confirm these are `/solution` outputs
3. Parses markdown to extract epics and architecture
4. Transforms to BoE XLSX
5. **Fast path** - minimal analysis needed

### Mode 3: From Raw Scope Documents (FULL ANALYSIS)
1. Reads raw scope documents
2. Identifies ambiguities
3. Optionally uses `/grill-me` to clarify
4. Invokes `/solution` with targeted architecture questions
5. Synthesizes responses into Epics
6. Generates BoE XLSX
7. **Full workflow** - comprehensive but slower

---

## Instructions

You are a **Salesforce Solution Architect** specializing in translating solution designs and scope documents into structured, estimable work packages (Epics) within a Basis of Estimate (BoE).

---

## Workflow

### Step 0: Check for Solution JSON (FAST PATH CHECK)

**FIRST ACTION**: Look for existing `solution-data.json` in the current directory.

```bash
ls -la solution-data.json
```

**If found**:
- **ASK USER** with AskUserQuestion:
  - Question: "I found solution data from a prior `/solution` run. How would you like to proceed?"
  - Options:
    1. "Use solution data (fast)" - Go to Step 6 (Generate XLSX from JSON)
    2. "Provide different scope documents" - Continue to Step 1
  
**If NOT found**:
- Continue to Step 1

---

### Step 1: Get Scope Documents or Folder

**If user has NOT yet provided documents/folder**:
- **ASK**: "Please provide the scope documents or folder path for this BoE."
- **Wait for user response**

**If user HAS provided folder/files**:
- Note the path(s)
- Continue to Step 2

---

### Step 2: Read Documents

**Read all files** from the specified location:

```bash
ls -la [user-provided-folder]
```

**Supported formats**:
- Markdown (*.md)
- Text files (*.txt)
- Word documents (*.docx)
- PDFs (*.pdf)

**For each file**:
- Use `Read` tool to load contents
- Track success/failure
- Store contents in memory

**If ANY file fails to read**:
- **WARN USER**: "Cannot read [filename]. This may contain critical information."
- **ASK**: "Proceed without this file, or stop so you can make it accessible?"
- **Wait for decision**

---

### Step 3: Detect Solution Documents (AUTO-DETECTION)

**Scan all read documents for solution output patterns**:

**Detection signals** (any 3+ present = likely solution output):
1. File naming: `*-solution.md`
2. Content markers:
   - Heading: `## Native Salesforce Solution:`
   - Heading: `## Alternative Solutions`
   - KB citations: `[KA-XXXX]` pattern (3+ occurrences)
   - Heading: `## References (Salesforce Knowledge Base)`
   - Heading: `## Recommendation by Scenario`
   - Section: `## Implementation Roadmap`
   - Section: `## Comparison Matrix`

**If solution documents detected** (3+ signals):
- Flag as "likely solution output"
- Continue to Step 4

**If NOT detected**:
- Flag as "raw scope documents"
- Skip Step 4, go to Step 5

---

### Step 4: Confirm Solution Document Usage (USER CHOICE)

**ASK USER** with AskUserQuestion:
- Question: "These documents appear to be `/solution` skill outputs. How would you like to proceed?"
- Options:
  1. "Use as solution outputs (faster)" - Go to Step 6 (Parse markdown → XLSX)
  2. "Treat as raw scope (full analysis)" - Go to Step 5 (Full BoE workflow)

**If user chooses Option 1**:
- Skip Step 5
- Go directly to Step 6 (parse markdown mode)

**If user chooses Option 2**:
- Continue to Step 5 (treat as raw scope)

---

### Step 5: Full BoE Workflow (Raw Scope Documents)

**This step only runs when processing RAW SCOPE** (not solution outputs).

#### 5.1: Check `/solution` Skill Availability

**Test if `/solution` is accessible**:
- Check system reminder for available skills
- Look for "solution" in skill list

**If `/solution` NOT accessible**:
- ⚠️ **WARN USER**: "The `/solution` skill is not accessible. This skill requires `/solution` to design grounded Salesforce architecture."
- **EXPLAIN**: "Without `/solution`, I cannot ground the BoE in actual Salesforce capabilities. Estimates would be unreliable."
- **ASK**: "Please ensure `/solution` is installed (in `skills/solution/` directory) before proceeding."
- **STOP** - do not proceed

**If `/solution` IS accessible**:
- Continue to Step 5.2

#### 5.2: Identify Ambiguities and Open Questions

**Scan scope documents for ambiguity signals**:
- Phrases: "open question", "TBD", "to be determined", "pending", "unclear"
- Multiple options without decision: "Option 1... Option 2... Option 3..."
- Dependencies on external inputs: "pending from [person]", "waiting for [info]"
- Conditional statements: "if X then Y"
- Conflicting requirements
- Missing critical details: user volumes, data volumes, performance SLAs

**Common ambiguity categories**:
1. Architecture decisions not finalized (e.g., cloud choice, integration pattern)
2. External dependencies (vendor schema, API docs pending)
3. Conditional scope (e.g., "only if agency has X")
4. Missing user context (who are the users? volumes?)
5. Undefined non-functional requirements (what is "real-time"?)
6. Budget/timeline constraints unstated

**Document all ambiguities found**:
- Create a list of unclear areas
- Note which Epic areas each impacts
- Flag CRITICAL vs. NICE-TO-HAVE clarifications

#### 5.3: Optionally Use `/grill-me` to Clarify

**If ambiguities identified AND `/grill-me` is available**:
- **RECOMMEND** using `/grill-me`: "I found [N] ambiguities in the scope. I recommend using `/grill-me` to clarify before estimation. Proceed with clarification?"
- **If user agrees**: Invoke `/grill-me` skill
- **If user declines**: Document all ambiguities as assumptions, continue

**If `/grill-me` NOT available**:
- **INFORM USER**: "Found ambiguities but `/grill-me` skill not available. Will document as assumptions."
- Continue (flag all ambiguities as assumptions in BoE)

#### 5.4: Analyze Scope and Identify Functional Areas

**Extract from scope documents**:
- **Business objectives**: What is the client trying to achieve?
- **User personas**: Who will use the system?
- **Functional requirements**: What capabilities are needed?
- **Non-functional requirements**: Performance, security, compliance, offline, integrations
- **Constraints**: Budget, timeline, licensing, existing systems
- **Assumptions already stated**: Capture for BoE assumptions column
- **Clarified decisions** (from `/grill-me` if used): Integrate into requirements model

**Identify 3-5 major functional areas**:
- Example: "Support & Case Management", "Collaboration & Communication", "Analytics & Reporting", "Compliance & Security"

#### 5.5: Design Salesforce Solution (Using `/solution` Skill)

**For EACH major functional area**:

1. **Formulate targeted question** for `/solution`:
   - Be specific about use case, users, constraints
   - Example: "How do I implement a branded self-service portal for government agency customers to submit support cases? Users are field operators in high-stress environments needing simple access."

2. **Invoke `/solution` skill**:
   ```
   /solution [your question]
   ```

3. **Wait for `/solution` to complete**:
   - `/solution` will create markdown document
   - `/solution` will create `solution-data.json` (if updated per Step 2)

4. **Read solution outputs**:
   - **Prefer JSON** if available: `solution-data.json`
   - **Fallback to markdown** if JSON not available
   - Extract:
     - Recommended approach (native vs. alternatives)
     - Architecture components
     - Constraints and limitations
     - Implementation phases
     - Risks identified
     - KB atom references

5. **Repeat for each functional area** (3-5 queries total)

#### 5.6: Synthesize into Epics

**Decompose each solution area into Epics**:

**Epic definition guidelines**:
- Cohesive piece of functionality (not too granular, not too broad)
- Estimable by a development team
- Maps to Salesforce features/objects/integrations
- Typically 5-20 epics total for a project

**Epic categories to consider**:
1. **Data Model Epics**: Custom objects, standard object extensions, relationships
2. **User Interface Epics**: Lightning pages, components, Screen Flows, mobile config
3. **Business Logic Epics**: Apex triggers/classes, record-triggered flows, automation
4. **Integration Epics**: REST/SOAP APIs, MuleSoft flows, Platform Events
5. **Security & Access Epics**: Permission sets, profiles, sharing rules, field-level security
6. **Reporting & Analytics Epics**: Reports, dashboards, Einstein Analytics
7. **Migration & Data Epics**: Data migration, cleansing, transformation
8. **Testing & Quality Epics**: Test data, UAT planning
9. **Training & Enablement Epics**: User training, admin training

**For each Epic, capture**:
- `epic_id`: E01, E02, etc.
- `workstream`: MVP, Phase 1, Core 1, etc.
- `summary`: Short name (5-15 words)
- `description`: Detailed paragraph (100-300 words)
- `solution_approach`: Technical approach
- `complexity_drivers`: What makes this complex
- `skills_needed`: Roles required
- `risks`: Key risks
- `assumptions`: Architecture/design assumptions (one per line)
- `notes`: Additional context, rationale, references
- `kb_references`: KB atoms referenced (KA-XXXX)

#### 5.7: Assign Workstreams (Phasing)

**Workstreams** = delivery phases or releases:
- **MVP**: Must-have for go-live
- **Phase 1**: Additional value-add features
- **Phase 2+**: Enhancements, optimizations

**If scope documents specify phasing**: Use that.

**If scope does NOT specify phasing**:
- **ASK USER**: "The scope doesn't specify delivery phases. Should I propose an MVP + Phase 1 breakdown, or do you have a preferred approach?"
- Wait for response
- Apply phasing based on user guidance

**Assign each Epic to a workstream** based on:
- Dependency order (foundation first)
- Business value (high-value in MVP)
- Risk (risky items in earlier phases for validation)

---

### Step 6: Generate BoE XLSX

**This step runs in ALL modes** (from JSON, from markdown, or from full analysis).

#### Input Source Determination

**Mode 1: From JSON** (`solution-data.json` exists and user confirmed):
- Read `solution-data.json`
- Extract `epics` array directly
- Minimal transformation needed

**Mode 2: From Parsed Markdown** (solution documents detected and confirmed):
- Parse markdown solution documents
- Extract epic information from sections:
  - Implementation Roadmap
  - Architecture Components
  - Recommendations
- Synthesize into epic structure
- May need to infer some fields (best effort)

**Mode 3: From Full Analysis** (Step 5 completed):
- Use epics synthesized in Step 5.6
- All fields should be populated

#### Create Python Script to Generate XLSX

**Use Python with `openpyxl` library**:

```python
from openpyxl import Workbook
from openpyxl.styles import Font, Alignment

# Create workbook
wb = Workbook()
ws = wb.active
ws.title = "BoE"

# Headers (7 columns)
headers = [
    "Scope / Workstream",
    "Epic Summary", 
    "Epic Description",
    "Estimated Points",
    "In/Out",
    "Assumptions",
    "Notes"
]
ws.append(headers)

# Style headers (bold only)
for cell in ws[1]:
    cell.font = Font(bold=True)

# Add Epic rows
for epic in epics:
    # Assumptions: plain text, one per line (no bullets)
    assumptions_text = "\n".join(epic.get('assumptions', []))
    
    # Notes: optional context
    notes_text = "\n".join(epic.get('notes', [])) if epic.get('notes') else ""
    
    ws.append([
        epic.get('workstream', 'MVP'),        # Scope / Workstream
        epic['summary'],                       # Epic Summary
        epic['description'],                   # Epic Description
        epic.get('estimated_points', ''),      # Estimated Points (blank for user)
        epic.get('in_out', ''),                # In/Out (blank for user)
        assumptions_text,                      # Assumptions
        notes_text                             # Notes
    ])

# Enable text wrapping
for row in ws.iter_rows(min_row=2, max_row=ws.max_row):
    row[1].alignment = Alignment(wrap_text=True, vertical='top')  # Epic Summary
    row[2].alignment = Alignment(wrap_text=True, vertical='top')  # Epic Description
    row[5].alignment = Alignment(wrap_text=True, vertical='top')  # Assumptions
    row[6].alignment = Alignment(wrap_text=True, vertical='top')  # Notes

# Set column widths
ws.column_dimensions['A'].width = 20  # Scope / Workstream
ws.column_dimensions['B'].width = 35  # Epic Summary
ws.column_dimensions['C'].width = 70  # Epic Description
ws.column_dimensions['D'].width = 15  # Estimated Points
ws.column_dimensions['E'].width = 10  # In/Out
ws.column_dimensions['F'].width = 50  # Assumptions
ws.column_dimensions['G'].width = 50  # Notes

# Save
wb.save(filename)
```

#### XLSX Filename Convention

**Format**: `[project-name]-boe-[YYYY-MM-DD].xlsx`

**Examples**:
- `emberpoint-boe-2026-07-01.xlsx`
- `field-service-mobile-boe-2026-07-01.xlsx`

**If project name not specified**: Ask user for project name or use `untitled-boe-[date].xlsx`

#### Save Location

**Save to**:
- Current working directory (default)
- OR user-specified folder if provided

---

### Step 7: Provide Summary

**After creating XLSX, provide concise summary**:

```
**BoE Generated**: [filename].xlsx

**Summary**:
- **Total Epics**: [count]
- **Workstreams**: [list workstreams and epic counts]
- **Input Source**: [JSON / Solution Markdown / Raw Scope + /solution queries]
- **Solution Approach**: [One-line summary of Salesforce architecture]
- **Key Assumptions**: [3-5 most critical assumptions flagged]
- **Flagged Risks**: [Any high-risk or unclear areas]

**Next Steps**:
- Review Assumptions column for each Epic
- Add estimation points (Est. Points column)
- Mark In/Out scope decisions
- Validate phasing (Workstream assignments)

📄 **File**: [absolute path to XLSX]
```

---

## XLSX Column Definitions

| Column | Description | Example | Source |
|--------|-------------|---------|--------|
| **Scope / Workstream** | Delivery phase (MVP, Phase 1, Core 1, etc.) | Core 1 | epic.workstream |
| **Epic Summary** | Short epic name (5-15 words) | Org Setup / Security / Role Hierarchy / Shield / SSO | epic.summary |
| **Epic Description** | Detailed paragraph (100-300 words) | Org standup on Gov Cloud Plus: My Domain, Company Information, sandbox strategy... | epic.description |
| **Estimated Points** | Story points (leave blank for user to fill) | 30 | epic.estimated_points (usually blank) |
| **In/Out** | Scope decision: "In", "Out", or blank | In | epic.in_out (usually blank) |
| **Assumptions** | Architecture/design assumptions, one per line (plain text, no bullets) | Platform is Salesforce Education Cloud on Gov Cloud Plus<br>Gov is responsible for end-to-end ATO process | epic.assumptions (array → newline-joined) |
| **Notes** | Additional context, rationale, references | Single shared org with permission-based data visibility | epic.notes (array → newline-joined) |

---

## Common Pitfalls to Avoid

1. ❌ **Not checking for solution-data.json first** - Always check Step 0 before asking for documents
2. ❌ **Not detecting solution documents** - Auto-detect patterns in Step 3
3. ❌ **Proceeding without `/solution` for raw scope** - MUST have `/solution` for Mode 3
4. ❌ **Single `/solution` call for entire scope** - Break into 3-5 targeted questions
5. ❌ **Hiding uncertainty** - Document ALL assumptions in Assumptions column
6. ❌ **Too granular Epics** - Epics should be feature-level, not task-level
7. ❌ **Too broad Epics** - "Implement Sales Cloud" is not estimable
8. ❌ **Ignoring KB constraints from `/solution`** - Document limitations as assumptions
9. ❌ **Forgetting to assign Workstreams** - Every Epic needs a phase
10. ❌ **Empty Assumptions column** - EVERY Epic has assumptions

---

## Success Criteria

A successful BoE includes:

✅ Checked for `solution-data.json` first (Step 0)
✅ If JSON found, offered user choice to use it
✅ If documents provided, read all successfully (or user informed of failures)
✅ Auto-detected solution documents (if applicable)
✅ Confirmed with user how to treat documents (solution output vs. raw scope)
✅ If raw scope: checked `/solution` availability (stopped if not accessible)
✅ If raw scope: identified ambiguities and optionally clarified with `/grill-me`
✅ If raw scope: invoked `/solution` for each functional area (3-5 queries)
✅ Epics decomposed at appropriate granularity (feature-level)
✅ Workstreams assigned logically (MVP + phases)
✅ Every Epic has documented assumptions
✅ XLSX file generated with proper 7-column format
✅ XLSX saved with proper naming convention
✅ Concise summary provided to user

---

## Escalation Scenarios

**STOP and inform user if**:
1. `/solution` not accessible AND processing raw scope → Cannot proceed
2. No documents provided and no JSON found → Cannot generate BoE without source
3. Cannot read critical scope documents → May miss essential requirements
4. User does not confirm phasing approach → Cannot assign Workstreams

**In ALL cases**: Be transparent, explain the blocker, wait for user guidance.

---

## Example Interaction Flows

### Example 1: Fast Path from JSON

**User**: "Create a BoE from this project"

**Step 0**: Check for JSON
```bash
ls -la solution-data.json
# Found!
```

**ASK USER**: "I found solution data from a prior `/solution` run. How would you like to proceed?"
- User chooses: "Use solution data (fast)"

**Step 6**: Generate XLSX from JSON
- Read `solution-data.json`
- Extract epics array
- Generate XLSX directly
- ✅ **DONE** - Fast path complete!

**Summary**: 
- Total Epics: 12
- Workstreams: MVP (5 epics), Phase 1 (7 epics)
- Input Source: solution-data.json
- 📄 File: `/path/to/project-boe-2026-07-01.xlsx`

---

### Example 2: Fast Path from Solution Markdown

**User**: "Create a BoE from the `solutions/` folder"

**Step 0**: Check for JSON
```bash
ls -la solution-data.json
# Not found
```

**Step 1**: Get folder
- User provided: `solutions/`

**Step 2**: Read documents
```bash
ls -la solutions/
# Found: experience-cloud-portal-solution.md, analytics-platform-solution.md
```
- Read both files

**Step 3**: Auto-detect solution documents
- ✅ Detected `## Native Salesforce Solution:` in both
- ✅ Detected `[KA-XXXX]` citations (10+ occurrences)
- ✅ Detected `## Alternative Solutions`
- → **Likely solution output**

**Step 4**: Confirm with user
**ASK**: "These documents appear to be `/solution` skill outputs. How would you like to proceed?"
- User chooses: "Use as solution outputs (faster)"

**Step 6**: Parse markdown and generate XLSX
- Parse implementation roadmap sections
- Extract architecture components as epics
- Generate XLSX
- ✅ **DONE** - Fast path from markdown!

---

### Example 3: Full Workflow from Raw Scope

**User**: "Create a BoE from `scope/emberpoint-scope.txt`"

**Step 0**: Check for JSON
```bash
ls -la solution-data.json
# Not found
```

**Step 1**: Get documents
- User provided: `scope/emberpoint-scope.txt`

**Step 2**: Read document
- ✅ Read successfully

**Step 3**: Auto-detect
- ❌ No solution document patterns detected
- → **Raw scope document**

**Step 4**: Skipped (not solution output)

**Step 5**: Full BoE workflow
- **5.1**: Check `/solution` availability → ✅ Available
- **5.2**: Identify ambiguities → Found 7 open questions (GovSlack vs. commercial, MOE list pending, etc.)
- **5.3**: `/grill-me` not available → Document as assumptions
- **5.4**: Analyze scope → 4 functional areas identified:
  1. Support & Case Management
  2. Collaboration & Communication
  3. Analytics & Data
  4. Compliance & Security
- **5.5**: Design solutions:
  - Invoke `/solution` "How do I implement Experience Cloud portal for case management?" → Creates solution doc + JSON
  - Invoke `/solution` "How do I integrate Slack with Salesforce for mission coordination?" → Creates solution doc + JSON
  - Invoke `/solution` "How do I implement Tableau Server for analytics dashboards?" → Creates solution doc + JSON
  - Invoke `/solution` "How do I implement Shield + GovCloud compliance?" → Creates solution doc + JSON
- **5.6**: Synthesize into 14 epics across 4 solution areas
- **5.7**: Assign workstreams → MVP (6 epics), Phase 1 (8 epics)

**Step 6**: Generate XLSX
- Use epics from Step 5.6
- Create `emberpoint-boe-2026-07-01.xlsx`

**Step 7**: Summary
- Total Epics: 14
- Workstreams: MVP (6), Phase 1 (8)
- Input Source: Raw scope + 4 `/solution` queries
- Key Assumptions: 7 flagged (GovSlack decision TBD, MOE list pending, etc.)
- 📄 File: `/path/to/emberpoint-boe-2026-07-01.xlsx`

---

## File Naming Convention

**BoE XLSX**: `[project-name]-boe-[YYYY-MM-DD].xlsx`

**Examples**:
- `emberpoint-boe-2026-07-01.xlsx`
- `field-service-mobile-boe-2026-07-01.xlsx`
- `customer-portal-boe-2026-07-01.xlsx`

---

## Integration with `/solution` Skill

**The `/solution` skill** (in `skills/solution/`) is designed to:
1. Answer specific Salesforce architecture questions
2. Create comprehensive solution markdown documents
3. **Create `solution-data.json`** with structured data (including epics array)

**This `/boe` skill**:
- Can consume `solution-data.json` directly (fastest)
- Can parse solution markdown documents (fast)
- Can invoke `/solution` multiple times for raw scope (full workflow)

**Key benefit**: `/solution` outputs are reusable across skills (`/boe`, roadmapping, commercials, etc.)

---

**Last Updated**: 2026-07-01
