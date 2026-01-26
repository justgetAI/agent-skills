---
name: context-engineering
description: Human-readable context management for AI coding agents. Filesystem-based specs, tasks, and foundation docs. Includes autonomous workflows with multi-agent research and review.
compatibility: Claude Code, Cursor, OpenCode, or any markdown-instruction agent
---

# Context Engineering

A filesystem-based context system with autonomous workflows.

> **Philosophy:** 80% planning, 20% execution. Each unit of work makes the next easier.

---

## Quick Start

### Full Workflow (Recommended)
```
/swarm-context-engineer "add stripe payments"
```
Runs: understand → plan → work → review → compound. Human approves at gates.

### Individual Commands
```
/context-new feat payments    # Create spec with auto-research
/work                         # Execute current spec
/review                       # Multi-agent code review
/compound                     # Capture learnings
/status                       # See where you are
```

---

## Commands

| Command | Purpose | Auto-Agents |
|---------|---------|-------------|
| [swarm-context-engineer](commands/swarm-context-engineer.md) | Full autonomous workflow | ✅ research, review |
| [context-new](commands/context-new.md) | Create spec with research | ✅ repo, learnings |
| [work](commands/work.md) | Execute spec task-by-task | — |
| [review](commands/review.md) | Multi-perspective code review | ✅ simplicity, spec, bugs |
| [compound](commands/compound.md) | Capture learnings | — |
| [status](commands/status.md) | Current progress overview | — |
| [context-load](commands/context-load.md) | Load active context | — |
| [deepen-plan](commands/deepen-plan.md) | Research to improve spec | ✅ best practices |

---

## Directory Structure

```
context/
├── foundation/    # Human-authored truth (read-only for agents)
│   ├── architecture.md
│   ├── conventions.md
│   └── gotchas.md
├── specs/         # Feature/fix/improve definitions
│   └── 2026-01-26-feat-payments.md
└── tasks/         # (Optional) Atomic task breakdowns
    └── feat001-task001-setup.md

docs/
└── solutions/     # Captured learnings from /compound
    └── 2026-01-26-stripe-webhooks.md
```

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────┐
│  /swarm-context-engineer "feature description"             │
├─────────────────────────────────────────────────────────────┤
│  1. UNDERSTAND — load foundation, spawn research agents    │
│     ✋ Gate: confirm understanding                          │
├─────────────────────────────────────────────────────────────┤
│  2. PLAN — create spec with acceptance criteria            │
│     ✋ Gate: approve / refine / deepen                      │
├─────────────────────────────────────────────────────────────┤
│  3. WORK — execute via TodoWrite, incremental commits      │
│     ✋ Gate: ready for review?                              │
├─────────────────────────────────────────────────────────────┤
│  4. REVIEW — spawn reviewers: simplicity, spec, bugs       │
│     ✋ Gate: fix / ship / discuss                           │
├─────────────────────────────────────────────────────────────┤
│  5. COMPOUND — capture learnings to docs/solutions/        │
│     ✋ Gate: done!                                          │
└─────────────────────────────────────────────────────────────┘
```

---

## Agents

Auto-spawned during workflows:

| Agent | When Used | Purpose |
|-------|-----------|---------|
| [repo-researcher](agents/repo-researcher.md) | /context-new, /let-it-rip | Find relevant codebase patterns |
| [learnings-researcher](agents/learnings-researcher.md) | /context-new, /let-it-rip | Surface past learnings |
| [options-researcher](agents/options-researcher.md) | /deepen-plan | Research approaches, present options |
| [simplicity-reviewer](agents/simplicity-reviewer.md) | /review | Challenge complexity |
| [spec-reviewer](agents/spec-reviewer.md) | /review | Check spec compliance |

---

## Rules

| Rule | Key Point |
|------|-----------|
| [planning](rules/planning.md) | 80% planning, 20% execution |
| [foundation](rules/foundation.md) | Foundation is read-only for agents |
| [learnings](rules/learnings.md) | Always run /compound after features |
| [subagents](rules/subagents.md) | Spawn parallel agents for research |

See [rules/](rules/) for complete guidelines.

---

## Integrations

| Integration | Description |
|-------------|-------------|
| [Linear](integrations/linear/INTEGRATION.md) | Bidirectional sync with Linear issues |

---

## Templates

- [spec-template.md](references/spec-template.md)
- [task-template.md](references/task-template.md)

---

## Philosophy

**Compound Engineering:** Each unit of work should make subsequent units easier.

- **Plan thoroughly** before writing code
- **Review** to catch issues and capture learnings  
- **Codify knowledge** so it's reusable
- **Keep quality high** so future changes are easy

---

*Inspired by [compound-engineering](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents), adapted for filesystem-based context management.*
