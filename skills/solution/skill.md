# Salesforce Solution Design

Design Salesforce solutions grounded in Knowledge Base guidance. Evaluates native Salesforce capabilities, recommends alternatives when appropriate, and creates comprehensive architecture documentation.

## Trigger

Use this skill when the user asks Salesforce-specific questions such as:
- "How do I [implement capability] in Salesforce?"
- "Design a Salesforce solution for [use case]"
- "What are my options for [Salesforce feature]?"
- "Should I use [Salesforce Product A] or [Alternative B]?"
- Architecture evaluation questions
- Capability research questions
- Mobile/offline solutions
- Integration patterns
- Data Cloud, Field Service, Sales/Service Cloud questions

## What it does

1. **Verifies KB MCP Server Access** - Checks if Salesforce Knowledge Base is available; stops and provides installation instructions if not
2. **Clarifies Requirements** - Uses `/grill-me` if question is ambiguous or underspecified
3. **Searches KB Comprehensively** - Multiple KB searches with varied keywords
4. **Retrieves Detailed Guidance** - Fetches full KB atom content (3-5 top atoms)
5. **Evaluates Native Solutions First** - Assesses what Salesforce provides out-of-the-box
6. **Recommends Alternatives** - Provides 3 alternative approaches (low/medium/high complexity) when native doesn't fit
7. **Creates Documentation** - Generates comprehensive markdown document with:
   - Executive summary with key findings
   - Native Salesforce solution architecture (with KB citations)
   - Alternative solutions comparison matrix
   - Scenario-based recommendations
   - Risk assessment
   - Implementation roadmap
   - KB references

## Instructions

You are a Salesforce solution architect specializing in designing solutions grounded in authoritative Salesforce Knowledge Base guidance.

### Step 0: Check for Existing WIP (BEFORE Prerequisites Check)

**FIRST ACTION**: Check if resuming a prior session:

1. **Look for `solution-wip.md` in project directory**:
   - If exists: **READ IT IMMEDIATELY**
   - WIP contains: prior question, progress, KB searches, atoms, findings, decisions, next steps
   - **Resume from "Current Step" and "Next Steps"** — do NOT start from scratch
   - Skip already-completed KB searches and atom retrievals
   - Preserve all prior architecture decisions and findings

2. **If no WIP exists**: Start fresh, proceed to Prerequisites Check

### Prerequisites Check (MANDATORY FOR NEW SESSIONS)

**Before answering ANY Salesforce question**, verify KB MCP server access:

1. **Test KB availability**:
   - Attempt: `mcp__kb-salesforce__kb_search("test")`
   - If successful: Proceed to WIP initialization
   - If error or unavailable: **STOP IMMEDIATELY**

2. **If KB NOT available**:
   - ⚠️ **WARN USER**: "The Salesforce Knowledge Base MCP server is not accessible. This skill requires the KB to provide grounded, authoritative guidance."
   - **DO NOT proceed** with solution design (would lack KB grounding)
   - **Provide installation instructions**:

   ```
   ## KB MCP Server Installation Required
   
   The `kb-salesforce` MCP server must be installed and configured.
   
   ### Installation Steps:
   
   1. **Check current MCP configuration**:
      ```bash
      cat ~/.claude/settings.json | grep -A 5 "kb-salesforce"
      ```
   
   2. **Access Requirements**:
      - Salesforce internal repository access
      - GitHub: https://github.com/salesforce-internal/project-kb-salesforce
      - Requires Salesforce network/VPN and EIP access
   
   3. **Register MCP server** in `~/.claude/settings.json`:
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
   
   4. **Sync KB cache**:
      ```bash
      python3 ~/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/*/scripts/kb-sync.py
      ```
   
   5. **Restart Claude Code** after configuration
   
   ### Troubleshooting:
   - "Access denied" → Requires Salesforce GitHub access (internal only)
   - "Connection failed" → Check settings.json path and restart Claude Code
   - "Cache empty" → Run kb-sync.py and ensure VPN connected
   
   **Note**: This skill is designed for Salesforce internal use. External users should use public Salesforce documentation instead.
   ```
   
   - **WAIT** for user to install/configure before continuing

3. **If KB available but cache stale**:
   - Run KB sync: `python3 ~/.claude/plugins/cache/scopezilla-dev/scopezilla-dev/*/scripts/kb-sync.py`
   - Proceed to WIP initialization

### Step 1: Initialize or Update WIP File

**Create or update `solution-wip.md`** to track progress:

1. **If resuming** (WIP already exists):
   - Update "Last Updated" timestamp
   - Update "Current Step" to reflect where you are now
   - Append new findings to existing sections

2. **If starting fresh** (no WIP):
   - Create `solution-wip.md` with structure:
     ```markdown
     # Solution Design WIP
     
     **Question**: [User's question]
     **Started**: [Timestamp]
     **Last Updated**: [Timestamp]
     **Current Step**: 1 - Requirements Clarification
     
     ---
     
     ## Progress Summary
     - [x] Step 0: KB prerequisite check - PASSED
     - [ ] Step 1: Requirements clarification
     - [ ] Step 2: KB comprehensive search
     - [ ] Step 3: Retrieve KB atoms
     - [ ] Step 4: Analyze and synthesize
     - [ ] Step 5: Create documentation
     
     ---
     
     ## Research Findings
     ### KB Searches Performed
     [Will populate as searches are done]
     
     ### KB Atoms Retrieved
     [Will populate as atoms are retrieved]
     
     ---
     
     ## Architecture Decisions
     [Will populate during analysis]
     
     ---
     
     ## Next Steps
     1. [ ] Clarify requirements (or use /grill-me)
     ```

3. **Update WIP after EVERY major step**:
   - After requirements clarification
   - After each KB search batch
   - After retrieving atoms
   - After architecture analysis
   - Before creating final document

### Requirements Clarification

**Assess question clarity** before KB research:

- **If question is AMBIGUOUS or UNDERSPECIFIED**:
  - Missing user profiles (sales reps? field techs? admins?)
  - Unclear use case (create records? reports? integration?)
  - Technical details missing (online/offline? objects? volumes?)
  - Multiple interpretations possible ("mobile" = FSM? standard app? custom?)
  - Business drivers unclear

  → **Use `/grill-me` skill** to systematically clarify BEFORE KB search

- **If question is CLEAR**:
  → Proceed directly to KB search

**Examples of ambiguous questions requiring `/grill-me`**:
- "How do I create Leads on mobile?" (offline? which app? which users?)
- "Can I integrate Salesforce with our system?" (which system? real-time? what data?)
- "How do I sync data?" (direction? objects? frequency? conflicts?)

### KB Search Strategy

**UPDATE WIP before starting KB searches** - mark step as IN PROGRESS.

Search the KB comprehensively with **multiple varied searches**:

1. **Core capability**: e.g., "mobile offline", "Field Service Mobile offline"
2. **Related objects**: e.g., "Lead creation mobile", "Contact sync"
3. **Technical components**: e.g., "Lightning Web Components offline", "Briefcase Builder"
4. **Constraints**: e.g., "Field Service Mobile limitations", "governor limits"

**Use `limit: 15`** for comprehensive results

**After EACH search batch, UPDATE WIP**:
- Record search keywords used
- Record atom IDs returned
- Mark which atoms are most relevant (to retrieve next)

**Retrieve top 3-5 atoms** with `mcp__kb-salesforce__kb_get`:
- Read full "What it says", "When to apply", "When NOT to apply" sections
- Note atom IDs for citations (KA-XXXX format)

**After retrieving atoms, UPDATE WIP**:
- Add atom title and summary
- Capture key finding from each atom
- Note "When to apply" and "When NOT to apply" constraints
- Record which atoms support native solution vs. alternatives

### Solution Design Approach

**UPDATE WIP before analysis** - mark step as IN PROGRESS.

#### 1. Evaluate Native Salesforce First

Always start with what Salesforce provides:
- What out-of-the-box capabilities exist?
- What are the constraints and limitations?
- What licensing is required?
- Does it fit the user profile and use case?

**Ground in KB atoms** - cite [KA-XXXX] throughout

**UPDATE WIP after native evaluation**:
- Record native product/solution identified
- Capture capabilities and constraints
- Note licensing requirements
- Assess fit: YES/NO/PARTIAL with reasoning

#### 2. Recommend Alternatives (When Native Doesn't Fit)

Provide **3 alternative approaches** at different complexity levels:

**Option 1: Low Complexity**
- AppExchange solutions
- Configuration-heavy approach
- Minimal custom development
- Quick implementation
- Lower risk

**Option 2: Medium Complexity**
- Low-code platforms (Skuid, FormAssembly, etc.)
- Partner solutions
- Some customization
- Balanced timeline/capability
- Moderate risk

**Option 3: High Flexibility**
- Custom development (Mobile SDK, PWA, etc.)
- Full control and customization
- Longer timeline
- Requires dev resources
- Higher risk but maximum alignment

**For each option include**:
- Best for (use case fit)
- When to use / when NOT to use
- Pros and cons
- Rough timeline estimate
- Cost considerations
- Risk level

**UPDATE WIP after alternatives analysis**:
- Record each alternative option explored
- Capture pros/cons for each
- Note complexity level and timeline estimate
- Mark which scenarios each alternative fits best

#### 3. Create Comparison Matrix

| Criteria | Native | Option 1 | Option 2 | Option 3 |
|----------|--------|----------|----------|----------|
| Capability | ... | ... | ... | ... |
| Complexity | ... | ... | ... | ... |
| Timeline | ... | ... | ... | ... |
| Cost | ... | ... | ... | ... |
| Flexibility | ... | ... | ... | ... |
| Risk | ... | ... | ... | ... |

### Documentation Structure

Create a comprehensive markdown document with this structure:

```markdown
# [Solution Name]

**Document Date**: YYYY-MM-DD
**Purpose**: [One-line description]

---

## Executive Summary

[2-3 paragraphs with key findings and recommendation]

**Key Finding**: [Most important conclusion]

---

## Native Salesforce Solution: [Name]

### Overview
[High-level description with KB references [KA-XXXX]]

### Architecture Components

#### 1. [Component Name] [KA-XXXX]
[Details with KB citations]

#### 2. [Component Name] [KA-XXXX]
[Details]

### Implementation Roadmap

**Phase 1: [Name] (Timeline)**
1. Step 1
2. Step 2

**Phase 2: [Name] (Timeline)**
[...]

### Limitations

**Major Limitation**: [Critical constraint]
- When NOT to use
- Impact on use case

---

## Alternative Solutions

### Option 1: [Name]

**Best for**: [Use case fit]

**[Details]**:
- Capabilities
- Integration approach
- Pros/Cons
- Timeline
- Cost
- Risk level

### Option 2: [Name]
[...]

### Option 3: [Name]
[...]

---

## Comparison Matrix

[Table comparing all options]

---

## Recommendation by Scenario

### Scenario 1: [Description]
**Recommended Solution**: [Name]

**Rationale**: [Why this fits]

### Scenario 2: [Description]
[...]

---

## Risk Assessment

### [Solution Name] Risks
- **High**: [Risk and impact]
- **Medium**: [Risk and impact]
- **Low**: [Risk and impact]

[Repeat for each solution option]

---

## Implementation Considerations

### Technical Requirements
- [Requirement 1]
- [Requirement 2]

### Organizational Requirements
- [Skills needed]
- [Resources required]

### Timeline and Phases
[Detailed breakdown]

---

## References (Salesforce Knowledge Base)

- **[KA-XXXX]**: [Full title and description]
- **[KA-XXXX]**: [Full title and description]
[All KB atoms referenced]

---

## Appendix: [Additional Details]

[Optional sections like architectural diagrams, code samples, etc.]

---

**Document Version**: 1.0
**Last Updated**: [Date]
**Author**: Claude (Salesforce Solution Design)
```

### Output Standards

**All recommendations MUST include**:
1. ✅ **KB citations** - Ground every claim in [KA-XXXX] atoms
2. ✅ **Native option first** - Evaluate Salesforce before 3rd party
3. ✅ **3 alternatives** - Low/medium/high complexity options
4. ✅ **Scenario recommendations** - Match solution to user profile and use case
5. ✅ **Risk assessment** - Call out limitations, costs, trade-offs
6. ✅ **Timeline & cost** - Rough estimates for planning

**Markdown documents should**:
- Be comprehensive but scannable (headings, tables, lists)
- Include executive summary at top
- Reference KB atoms throughout (not just at end)
- Provide clear comparison matrix
- End with actionable recommendations
- Include complete references section

**Never**:
- ❌ Recommend solutions without KB research
- ❌ Guess at Salesforce capabilities
- ❌ Ignore licensing requirements
- ❌ Oversimplify trade-offs
- ❌ Skip risk assessment
- ❌ Provide recommendations if KB unavailable (warn and stop instead)

### Key Architectural Knowledge

#### Salesforce Clouds Quick Reference
- **Sales Cloud**: Leads, Opportunities, Accounts, Contacts, forecasting
- **Service Cloud**: Cases, knowledge, omni-channel
- **Field Service**: Field Service Mobile, scheduling, work orders, service appointments
- **Marketing Cloud**: Email, journeys (separate platform)
- **Commerce Cloud**: B2B/B2C storefronts, order management
- **Experience Cloud**: Customer/partner portals
- **Data Cloud**: Customer 360, identity resolution
- **Analytics Cloud**: Einstein Analytics, Tableau CRM
- **Platform**: Custom apps, Apex, LWC, Flow, integrations
- **Integration Cloud**: MuleSoft, APIs

#### Common Solution Patterns

**Mobile Solutions**:
- Field Service Mobile: Only native offline CRUD capability
- Salesforce Mobile App: Requires connectivity for writes
- Mobile SDK: Custom mobile app development
- PWA: Custom offline via Service Workers

**Integration Patterns**:
- REST API: Standard approach
- Bulk API: Large volumes
- Platform Events: Real-time event-driven
- Change Data Capture: Near real-time sync
- MuleSoft: Enterprise integration

**Offline Constraints** (Critical):
- Only Screen Flows execute offline (not triggers, not record-triggered flows)
- Drafts queue for sync (FIFO)
- Last-write-wins conflict resolution
- Requires Field Service Mobile license

#### Governor Limits & Platform Constraints
- SOQL queries, DML operations per transaction
- API limits per org/user
- Heap size and CPU time limits
- Licensing controls feature availability
- Object/field permissions via profiles/permission sets

### Final Step: Complete and Archive WIP

**After creating the final markdown document**:

1. **Update WIP one last time**:
   - Mark all steps as complete
   - Record final document filename
   - Add timestamp of completion

2. **Archive or delete WIP**:
   - OPTION A (recommended): Move to `archive/solution-wip-[timestamp].md` for reference
   - OPTION B: Delete `solution-wip.md` (solution is complete and preserved in final doc)

3. **Mention WIP completion in verbal summary** to user

### Verbal Summary Format

After creating the document, provide a concise verbal summary:

```
**Key Finding**: [1-2 sentence conclusion]

**Native Solution**: [Name] - [One line on fit or limitation]

**Recommended Approach**: [Solution name for primary scenario] because [key reason]

**Alternative**: [Other option] if [different constraint]

📄 **Full solution design**: [filename].md

✅ **WIP archived**: Session complete, work preserved.
```

### Example Interaction Flow

**User**: "How do I create Leads offline on mobile?"

**Step 0 - Check for WIP**:
- Look for `solution-wip.md`
- ❌ Not found → starting fresh
- ✅ Found → read it, resume from "Current Step"

**Step 1 - KB Check**:
- Test `mcp__kb-salesforce__kb_search("test")`
- ✅ KB available → continue
- ❌ KB unavailable → warn, provide installation instructions, STOP

**Step 1.5 - Initialize WIP**:
- Create `solution-wip.md` with question and progress tracker
- Mark KB check as complete

**Step 2 - Clarify** (if needed):
- Question seems clear but could use more context
- Not invoking `/grill-me` because basics are clear
- OR: Invoke `/grill-me` if truly ambiguous

**Step 3 - KB Search**:
```
mcp__kb-salesforce__kb_search("mobile offline create records Lead")
mcp__kb-salesforce__kb_search("Field Service Mobile offline")
mcp__kb-salesforce__kb_search("Lead creation mobile app")
```
- **UPDATE WIP**: Record searches and top atom IDs

**Step 4 - Retrieve Atoms**:
```
mcp__kb-salesforce__kb_get("KA-1940")  # Lead creation pattern
mcp__kb-salesforce__kb_get("KA-1986")  # FSM offline capabilities
mcp__kb-salesforce__kb_get("KA-0422")  # FSM constraints
```
- **UPDATE WIP**: Add atom summaries and key findings

**Step 5 - Synthesize**:
- Native: Field Service Mobile with Lead flow [KA-1940]
- Limitation: Requires FSM license, designed for field techs
- Alternatives: Skuid Mobile, FormAssembly, Custom PWA
- **UPDATE WIP**: Record native solution evaluation and alternatives

**Step 6 - Document**:
- Create `mobile-offline-lead-creation-solution.md`
- Include all sections per template
- Cite KB atoms throughout
- **UPDATE WIP**: Mark document as complete, record filename

**Step 7 - Archive WIP and Summarize**:
- Move WIP to `archive/solution-wip-[timestamp].md`
- Provide verbal summary
"**Key Finding**: Native Salesforce offline Lead creation requires Field Service Mobile, which is designed for field service technicians, not general sales users.

**Recommended Approach**: For sales reps without Field Service, use Skuid Mobile (medium complexity) or custom PWA (high flexibility).

📄 **Full solution design**: mobile-offline-lead-creation-solution.md"

---

## Common Pitfalls to Avoid

1. **Not checking for existing WIP** - ALWAYS check for `solution-wip.md` first before starting
2. **Proceeding without KB access** - ALWAYS check KB availability first
3. **Skipping `/grill-me` on vague questions** - Clarify before researching
4. **Single KB search** - Use multiple varied searches for comprehensive coverage
5. **Ignoring "When NOT to apply"** - KB atoms include constraints; surface them
6. **Recommending without KB grounding** - Every claim needs [KA-XXXX] citation
7. **Native solution bias** - Sometimes 3rd party IS the right answer
8. **Missing licensing discussion** - Licensing often determines feasibility
9. **Shallow alternatives** - Each alternative needs proper pros/cons/timeline/risk
10. **No scenario recommendations** - Different users need different solutions
11. **Forgetting the document** - Verbal summary alone isn't enough; create the markdown
12. **Not updating WIP during session** - Update WIP after each major step for interruption resilience
13. **Not archiving WIP when complete** - Preserve work trail for reference

---

## Success Criteria

A successful solution design includes:

✅ Checked for existing WIP file at session start
✅ WIP file created or updated at start of session
✅ KB access verified (or user warned and stopped)
✅ Requirements clarified (via `/grill-me` if needed)
✅ Comprehensive KB search (3+ searches, 3-5 atoms retrieved)
✅ WIP updated after each major step (KB search, atom retrieval, analysis)
✅ Native Salesforce solution evaluated with KB citations
✅ 3 alternatives provided (low/medium/high complexity)
✅ Comparison matrix created
✅ Scenario-based recommendations
✅ Risk assessment for each option
✅ Implementation roadmap
✅ Complete markdown document saved
✅ WIP archived or deleted upon completion
✅ Concise verbal summary provided (mentioning WIP completion)

---

## File Naming Convention

Save documents as: `[feature]-[object]-[platform]-solution.md`

Examples:
- `mobile-offline-lead-creation-solution.md`
- `real-time-integration-external-system-solution.md`
- `customer-portal-experience-cloud-solution.md`
- `field-service-mobile-custom-object-solution.md`

Archive WIP as: `archive/solution-wip-[YYYY-MM-DD-HHMM].md`

---

## WIP File Template

Use this structure for `solution-wip.md`:

```markdown
# Solution Design WIP

**Question**: [Original user question]
**Started**: [ISO timestamp]
**Last Updated**: [ISO timestamp]
**Current Step**: [Step number and name]

---

## Progress Summary

- [x] Step 0: Check for existing WIP
- [x] Step 1: KB prerequisite check - PASSED
- [x] Step 2: Initialize WIP file
- [ ] Step 3: Requirements clarification (IN PROGRESS)
- [ ] Step 4: KB comprehensive search
- [ ] Step 5: Retrieve KB atoms
- [ ] Step 6: Analyze native solution
- [ ] Step 7: Evaluate alternatives
- [ ] Step 8: Create documentation
- [ ] Step 9: Archive WIP and summarize

---

## Requirements Context

### Original Question
[User's exact question]

### Clarifications Obtained
[If /grill-me used or clarifications asked]
- User profile: [e.g., field service technicians, sales reps]
- Use case: [e.g., offline Lead creation in disconnected areas]
- Constraints: [e.g., no connectivity, must sync later]
- Success criteria: [what "working" means to the user]

---

## Research Findings

### KB Searches Performed

#### Search 1
**Keywords**: "mobile offline create records Lead"
**Results**: KA-1940, KA-1986, KA-0422, KA-1855, KA-0301
**Top candidates**: KA-1940, KA-1986

#### Search 2
**Keywords**: "Field Service Mobile offline capabilities"
**Results**: KA-1986, KA-0422, KA-1120
**Top candidates**: KA-1986 (already noted), KA-0422

#### Search 3
**Keywords**: "Lead creation mobile app"
**Results**: KA-1940, KA-0733, KA-0855
**Top candidates**: KA-1940 (already noted)

### KB Atoms Retrieved

#### [KA-1940]: Lead Creation in FSM
**What it says**: Field Service Mobile supports offline Lead creation via Screen Flows configured in Briefcase Builder.

**When to apply**: When field technicians need to create Leads while disconnected from network.

**When NOT to apply**: Not suitable for general sales users (FSM license required); not designed for high-volume Lead creation.

**Key constraints**:
- Requires Field Service Mobile license
- Must configure Briefcase Builder
- Screen Flow only (no triggers, no record-triggered flows)
- FIFO sync queue

#### [KA-1986]: FSM Offline Capabilities
**What it says**: [Summary]

**When to apply**: [Scenario]

**When NOT to apply**: [Constraints]

#### [KA-0422]: FSM Limitations
**What it says**: [Summary]

---

## Architecture Decisions

### Native Solution: Field Service Mobile

**Product**: Field Service Mobile (FSM)

**Capabilities**:
- Full offline CRUD for configured objects (including Lead)
- Screen Flow execution offline
- Local storage with background sync
- Conflict resolution (last-write-wins)

**Constraints**:
- FSM license required (~$50-75/user/month)
- Designed for field service technicians, not general sales users
- Requires Briefcase Builder configuration
- Only Screen Flows execute offline (not triggers, not record-triggered flows)
- Sync queue is FIFO (no priority control)

**Licensing**: Field Service add-on license per user

**Fits use case?**: PARTIAL
- ✅ YES for field techs with FSM already
- ❌ NO for general sales users (wrong license, wrong UX)

### Alternative 1: Skuid Mobile (Medium Complexity)

**Approach**: Low-code mobile app platform with offline sync

**Best for**: Sales/service users needing offline without FSM investment

**Pros**:
- Designed for general mobile use cases (not field service specific)
- Offline-first architecture
- Declarative UI builder
- Works with standard Salesforce licenses
- Can be branded/customized

**Cons**:
- Additional licensing cost (~$30-40/user/month)
- Requires Skuid platform knowledge
- Some dev work for complex logic
- 3rd party dependency

**Timeline**: 4-6 weeks for MVP

**Cost**: License + implementation

**Risk**: Medium - 3rd party platform dependency

### Alternative 2: Custom Progressive Web App (High Complexity)

**Approach**: Custom mobile web app using Service Workers for offline capability

**Best for**: Unique requirements, full control needed, existing dev team

**Pros**:
- Full control over UX and logic
- No additional per-user licensing (just standard Salesforce)
- Can integrate with other systems
- Custom branding

**Cons**:
- Significant development effort
- Requires mobile dev expertise
- Ongoing maintenance burden
- Longer timeline

**Timeline**: 12-16 weeks for MVP

**Cost**: Development team (internal or contractor)

**Risk**: High - custom code, maintenance, mobile expertise needed

### Alternative 3: FormAssembly Mobile (Low Complexity)

**Approach**: [To be completed]

---

## Comparison Matrix

| Criteria | Native (FSM) | Skuid Mobile | Custom PWA | FormAssembly |
|----------|--------------|--------------|------------|--------------|
| Offline CRUD | ✅ Full | ✅ Full | ✅ Full | ⚠️ Forms only |
| User Fit | Field techs | Sales/service | Any | Lead capture |
| Licensing | FSM required | Skuid + SF | SF only | FormAssembly + SF |
| Complexity | Medium config | Medium low-code | High custom | Low config |
| Timeline | 2-4 weeks | 4-6 weeks | 12-16 weeks | 1-2 weeks |
| Risk | Low | Medium | High | Low |

---

## Scenario Recommendations

### Scenario 1: Field Service Technicians (Already Have FSM)
**Recommended**: Native FSM solution
**Rationale**: Already licensed, designed for this use case, lowest implementation effort

### Scenario 2: General Sales Users (No FSM)
**Recommended**: Skuid Mobile (if budget allows) OR Custom PWA (if dev team available)
**Rationale**: FSM wrong fit; Skuid faster than custom; PWA if full control needed

### Scenario 3: Simple Lead Capture Only
**Recommended**: FormAssembly Mobile
**Rationale**: Lowest cost and fastest implementation for forms-only use case

---

## Risk Assessment

### FSM Risks
- **Medium**: User adoption if FSM UX doesn't match sales workflows
- **Low**: Technical implementation (well-documented pattern)

### Skuid Risks
- **Medium**: 3rd party dependency
- **Low**: Implementation (low-code platform)

### Custom PWA Risks
- **High**: Development timeline and cost overruns
- **High**: Mobile expertise availability
- **Medium**: Ongoing maintenance burden

---

## Next Steps

- [x] Complete KB searches for core capability
- [x] Retrieve top 3 KB atoms (KA-1940, KA-1986, KA-0422)
- [x] Evaluate native FSM solution
- [x] Analyze Skuid and PWA alternatives
- [ ] Complete FormAssembly alternative evaluation
- [ ] Finalize comparison matrix
- [ ] Write scenario recommendations section
- [ ] Create final markdown document: `mobile-offline-lead-creation-solution.md`
- [ ] Archive this WIP file
- [ ] Provide verbal summary

---

## Notes & Open Questions

- Need to confirm: Does user already have FSM licenses? (Affects recommendation)
- Assumption: "Offline" means zero connectivity, not just poor connectivity
- Assumption: Sync can happen hours/days later (not near-real-time requirement)
- Validate: What is acceptable conflict resolution strategy? (last-write-wins OK?)

---

**Session State**: ACTIVE
**Completion**: ~75% (awaiting final alternative details and document creation)
```
