# Changelog

All notable changes to the Salesforce Solution Design skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-22

### Added
- Initial release of Salesforce Solution Design skill
- KB MCP server prerequisite checking with installation guidance
- Integration with `/grill-me` skill for requirement clarification
- Comprehensive KB search strategy (multiple searches with varied keywords)
- Native Salesforce solution evaluation framework
- 3-tier alternative recommendation system (low/medium/high complexity)
- Comparison matrix generation
- Scenario-based recommendation engine
- Risk assessment per solution option
- Implementation roadmap generation
- Markdown documentation template
- KB atom citation system ([KA-XXXX] format)
- Installation script for global and project-level deployment
- Example settings.json for permissions
- Comprehensive README with usage instructions
- Package.json for npm distribution

### Features
- Automatic KB access verification before proceeding
- Stops and warns user if KB unavailable
- Provides detailed installation instructions for KB MCP server
- Clarifies ambiguous questions before research
- Searches KB with 15 result limit for comprehensive coverage
- Retrieves 3-5 top atoms for detailed analysis
- Generates executive summaries
- Creates comparison matrices
- Provides scenario-specific recommendations
- Assesses risks per solution
- Documents implementation roadmaps
- Cites all KB sources
- Produces professional markdown documents

### Documentation
- README.md with installation and usage guide
- skill.md with complete agent instructions
- example-settings.json for permissions reference
- CHANGELOG.md for version tracking
- Installation script with interactive setup

### Configuration
- Pre-authorized commands for KB search/get
- Pre-authorized KB sync script execution
- Pre-authorized skills installation
- Project-level settings template

## [1.1.0] - 2026-07-01

### Added
- **Structured JSON Output** - Skill now ALWAYS generates `solution-data.json` alongside markdown documents
- **Epic Breakdown** - JSON includes detailed `epics` array for BoE compatibility
- **solution-data-schema.json** - Formal JSON schema definition for programmatic consumption
- **Metadata Tracking** - JSON includes metadata about design process (KB searches, atoms retrieved, clarification used)

### Changed
- **Step 8: Generate Structured JSON Output** - New mandatory step after markdown document creation
- **Success Criteria** - Updated to include JSON output requirement
- **Verbal Summary** - Now mentions both markdown and JSON outputs
- **Example Interaction Flow** - Updated to include JSON generation step

### Integration
- **BoE Skill Compatibility** - JSON output enables fast-path BoE generation without re-analysis
- **Reusable Data** - Structured data can be consumed by roadmap, commercials, and other skills

### Documentation
- Added JSON schema documentation in skills/solution/solution-data-schema.json
- Updated SKILL.md with JSON output workflow
- Enhanced example interaction flow with JSON generation

## [Unreleased]

### Changed
- Updated repository URL to `https://github.com/mmallingSFDC/missionforce-arch-skills`
- Enhanced README with repository badges and metadata
- Added comprehensive contribution guidelines
- Updated package.json with correct repository information

### Added
- Root-level README.md for repository overview
- CONTRIBUTING.md with detailed contribution workflow
- LICENSE file for proprietary software
- **Step 0.1: Check for Skill Updates** - Automatically checks for and pulls updates from git repository before running
- **Step 0.2: Check for Existing WIP** - Looks for `solution-wip.md` to resume interrupted sessions
- **Step 1: Capture Use Case** - Skill now prompts for use case if invoked without context (e.g., `/solution` alone)
- **WIP File Management** - Comprehensive work-in-progress tracking for interruption resilience

### Planned
- Integration with additional MCP servers (if available)
- Specialized variants (mobile-focused, integration-focused, data-cloud-focused)
- Template library for common solution patterns
- Automated KB atom updates
- Solution design templates per Salesforce cloud
- Cost estimation models
- Timeline calculators
- Risk scoring framework
- Interactive clarification mode (enhanced beyond /grill-me)

### Ideas
- Visual architecture diagram generation
- Comparison to similar past solutions
- Automated gap analysis
- Compliance/security assessment integration
- Auto-generation of RFP responses
- Solution presentation slide generation

---

## Version Format

- **Major** (X.0.0): Breaking changes to skill interface or workflow
- **Minor** (1.X.0): New features, backward compatible
- **Patch** (1.0.X): Bug fixes, documentation updates

## Links

- [1.0.0]: Initial release
