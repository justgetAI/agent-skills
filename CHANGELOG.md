# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [2.2.0] - 2026-02-06

### Added
- `npx skills add` as primary install method via [Vercel Labs Skills CLI](https://github.com/vercel-labs/skills)
- `orchestrating-swarms` entry in marketplace.json
- `.claude-plugin/plugin.json` for orchestrating-swarms and marketing-copy
- `compatibility` and `metadata` fields in all SKILL.md frontmatter (agentskills.io spec)
- Cross-tool installation instructions in README (Cursor, Gemini CLI, etc.)

### Fixed
- Removed deleted `logging-standards` from marketplace.json
- Marketplace now lists exactly 3 skills matching repo contents

### Changed
- Bumped marketplace version to 2.2.0
- Replaced non-spec `activators` field in marketing-copy/SKILL.md with `metadata`

## [2.1.0] - 2026-01-26

### Added
- **context-engineering** skill
  - `/swarm-context-engineer` — Full autonomous workflow (understand → plan → work → review → compound)
  - `/audit-context` — Hierarchical swarm for codebase documentation (Haiku scout → Opus managers → Sonnet workers)
  - `/work` — Execute specs task-by-task with progress tracking
  - `/review` — Multi-agent code review (simplicity, spec compliance, bugs)
  - `/compound` — Capture learnings to docs/solutions/
  - `/status` — Progress overview with task completion %
  - Auto-sets `CLAUDE_CODE_TASK_LIST_ID` for cross-session sync
  - `references/task-list-setup.md` — Guide for local Claude Code setup

### Changed
- Task state now lives in Claude Code Tasks, not task files (enables cross-session sync)
- Subagents share task state via `CLAUDE_CODE_TASK_LIST_ID`

## [1.0.0] - 2026-01-19

### Added
- **context-engineering** skill
  - `init.sh` script for scaffolding context/ directory
  - `ctx` CLI for creating specs and tasks
  - Spec and task templates
  - Foundation guidelines
  - Integration snippets for Claude Code, Cursor, and generic agents
  - Example files with --with-examples flag
