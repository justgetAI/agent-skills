---
name: context-engineering
description: Spec-driven shipping for coding agents. Filesystem-based specs, tasks and foundation docs; research, plan, build, review, PR loop and verified main merge in full-stop, auto or yolo mode.
compatibility: Claude Code, Codex, OpenCode, Cursor, or any markdown-instruction agent
metadata:
  author: justgetAI
  version: "3.4.0"
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
Runs: understand > plan > work > review > compound > PR loop > live verify > main merge. Teams + tasks persist as a queryable trace.

### Modes
| Mode | Flag | What happens |
|---|---|---|
| **full-stop** | `--full-stop` | You stay in the loop: it asks before each phase and before each merge. |
| **auto** | `--auto` | Ships to dev, verifies in a real environment, fixes PR findings, stops **ready for main**. |
| **yolo** | `--yolo` | auto, then merges main without asking if every check passes. |

No flag: it asks which mode first. Details: [references/ship-modes.md](references/ship-modes.md).

Internal review auto-fixes are capped at 2 iterations; PR bot rounds have their own budget in `/pr-loop`.

### Other Hosts
Codex and OpenCode run the same skills. Claude tool names map via [references/harness-tools.md](references/harness-tools.md).

### Individual Commands
```
/spec feat payments      # Create spec with auto-research
/work                    # Execute current spec
/review                  # Multi-agent code review
/compound                # Capture learnings + rate spec
/pr-loop                 # PR → bots → dev → live verify → gated main
/status                  # See where you are
/status --teams          # View team history
```

---

## Skills

| Skill | Purpose | Team Members |
|---------|---------|-------------|
| [lets-ship](skills/lets-ship/SKILL.md) | Full workflow with teams + traceability | research, review |
| [spec](skills/spec/SKILL.md) | Create spec with research | repo, learnings |
| [work](skills/work/SKILL.md) | Execute spec task-by-task | — |
| [review](skills/review/SKILL.md) | Multi-perspective code review | simplicity, spec, bug-hunter |
| [compound](skills/compound/SKILL.md) | Capture learnings + rate spec | — |
| [pr-loop](skills/pr-loop/SKILL.md) | PR → bots → dev → live verify → gated main (lets-ship 6–8) | finding-verifier, live verifier |
| [compound-refresh](skills/compound-refresh/SKILL.md) | Audit `docs/solutions/` for stale/overlap (design stub) | — |
| [status](skills/status/SKILL.md) | Progress, specs, team history | — |
| [deepen](skills/deepen/SKILL.md) | Research to improve spec | options |
| [audit](skills/audit/SKILL.md) | Audit codebase docs, generate specs | hierarchical swarm |

---

## Directory Structure

```
context/
├── foundation/    # Human-authored truth (read-only for agents)
│   ├── architecture.md
│   ├── conventions.md
│   └── gotchas.md
├── specs/         # Feature/fix/improve definitions
│   └── 2026-01-26-feat-payments.md   # YYYY-MM-DD-<type>-<name>.md
└── tasks/         # (Optional) Atomic task breakdowns
    └── 2026-01-26-feat-payments-task001-setup.md

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
│  /lets-ship "feature" [--full-stop|--auto|--yolo]           │
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
│     Gate: ship / continue / done                            │
├─────────────────────────────────────────────────────────────┤
│  6. PR LOOP — PR to dev, triage bots, fix (3 rounds)        │
│  7. LIVE VERIFY — merge dev, fresh verifier, verdict on PR  │
│  8. MAIN GATE — report + approval (yolo: auto if all pass)  │
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
