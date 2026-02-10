---
name: context-engineering
description: Human-readable context management for AI coding agents. Filesystem-based specs, tasks, and foundation docs. Ships features with full traceability via native Teams.
compatibility: Claude Code, Cursor, OpenCode, or any markdown-instruction agent
metadata:
  author: justgetAI
  version: "3.0"
---

# Context Engineering

A filesystem-based context system with autonomous workflows and native Teams traceability.

> **Philosophy:** 80% planning, 20% execution. Each unit of work makes the next easier. Every feature gets a persistent trace of **what** was built, **why**, and **how**.

---

## Quick Start

### Full Workflow (Recommended)
```
/lets-ship "add stripe payments"
```
Runs: understand > plan > work > review > compound. Human approves at gates.
Teams + tasks persist as queryable trace.

### Autonomous Mode
```
/lets-ship --auto "fix login timeout"
```
Skips all gates. Auto-fixes review issues (max 2 iterations). Auto-creates PR.

### Individual Commands
```
/spec feat payments      # Create spec with auto-research
/work                    # Execute current spec
/review                  # Multi-agent code review
/compound                # Capture learnings + rate spec
/status                  # See where you are
/status --teams          # View team history
```

---

## Commands

| Command | Purpose | Team Members |
|---------|---------|-------------|
| [lets-ship](commands/lets-ship.md) | Full workflow with teams + traceability | research, review |
| [spec](commands/spec.md) | Create spec with research | repo, learnings |
| [work](commands/work.md) | Execute spec task-by-task | — |
| [review](commands/review.md) | Multi-perspective code review | simplicity, spec, bug-hunter |
| [compound](commands/compound.md) | Capture learnings + rate spec | — |
| [status](commands/status.md) | Progress, specs, team history | — |
| [deepen](commands/deepen.md) | Research to improve spec | options |
| [audit](commands/audit.md) | Audit codebase docs, generate specs | hierarchical swarm |

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

~/.claude/
├── teams/ship-<slug>-<date>/    # Team config (persists as trace)
└── tasks/ship-<slug>-<date>/    # Task history (persists as trace)
```

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────┐
│  /lets-ship "feature description" [--auto]                  │
├─────────────────────────────────────────────────────────────┤
│  0. BOOTSTRAP — cold start if no context/ (create dirs,    │
│     interactive Q&A, generate foundation)                    │
│     + TeamCreate("ship-<slug>-<date>")                      │
├─────────────────────────────────────────────────────────────┤
│  1. UNDERSTAND — load foundation, spawn research agents     │
│     Team: repo-researcher, learnings-researcher             │
│     Gate: confirm understanding                             │
├─────────────────────────────────────────────────────────────┤
│  2. PLAN — create spec with acceptance criteria             │
│     Gate: approve / deepen / refine / simplify              │
├─────────────────────────────────────────────────────────────┤
│  3. WORK — execute via TaskCreate, incremental commits      │
│     Gate: ready for review?                                 │
├─────────────────────────────────────────────────────────────┤
│  4. REVIEW — spawn reviewer team members                    │
│     Team: simplicity-reviewer, spec-reviewer, bug-hunter    │
│     Gate: fix / ship / discuss                              │
├─────────────────────────────────────────────────────────────┤
│  5. COMPOUND — capture learnings, rate spec                 │
│     Gate: create PR / continue / done                       │
│     Shutdown team (trace persists)                          │
└─────────────────────────────────────────────────────────────┘
```

---

## Agents

Spawned as **team members** (traced) during workflows:

| Agent | When Used | Purpose |
|-------|-----------|---------|
| [repo-researcher](agents/repo-researcher.md) | /lets-ship, /spec | Find relevant codebase patterns |
| [learnings-researcher](agents/learnings-researcher.md) | /lets-ship, /spec | Surface past learnings |
| [options-researcher](agents/options-researcher.md) | /deepen | Research approaches, present options |
| [simplicity-reviewer](agents/simplicity-reviewer.md) | /review, /lets-ship | Challenge complexity |
| [spec-reviewer](agents/spec-reviewer.md) | /review, /lets-ship | Check spec compliance |
| [bug-hunter](agents/bug-hunter.md) | /review, /lets-ship | Hunt for bugs and security issues |
| [context-worker](agents/context-worker.md) | /work | Context-aware implementation |

See [rules/agents.md](rules/agents.md) for subagent vs team member decision matrix.

---

## Rules

| Rule | Key Point |
|------|-----------|
| [planning](rules/planning.md) | 80% planning, 20% execution |
| [foundation](rules/foundation.md) | Foundation is read-only for agents |
| [learnings](rules/learnings.md) | Always run /compound after features |
| [agents](rules/agents.md) | Subagents (disposable) vs team members (traced) |

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
- **Trace everything** so you know what happened and why

---

*Inspired by [compound-engineering](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents), adapted for filesystem-based context management with native Teams traceability.*
