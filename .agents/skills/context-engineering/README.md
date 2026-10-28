# Context Engineering

Ship features from spec to verified main merge. Filesystem-based specs, tasks and foundation docs, on Claude Code, Codex and OpenCode.

## What is it?

An engineering workflow: understand > plan > work > review > compound > PR loop > live verify > main merge. Every phase creates team members and tasks that persist as a queryable trace of **what** was built, **why**, and **how**.

Works across Claude Code, Codex, OpenCode, Cursor and any markdown-instruction agent. Install commands for each host are in the [root README](../README.md#install).

## Installation

### Claude Code Marketplace
```bash
claude plugin marketplace add justgetAI/agent-skills
claude plugin install context-engineering@justgetai-tools
```

### Codex
```bash
codex plugin marketplace add justgetAI/agent-skills
codex plugin add context-engineering@justgetai-tools
```

### OpenCode
```json
{ "plugin": ["context-engineering@git+https://github.com/justgetAI/agent-skills.git"] }
```

### npx
```bash
npx skills add justgetAI/agent-skills --skill "context-engineering"
```

### Manual
```bash
git clone https://github.com/justgetAI/agent-skills.git /tmp/agent-skills
mkdir -p ~/.claude/skills
cp -r /tmp/agent-skills/context-engineering ~/.claude/skills/
```

## Quick Start

```bash
/lets-ship "add stripe payments"            # asks which mode
/lets-ship --auto "fix login timeout"       # ships to dev, verifies, stops ready for main
```

| Mode | Flag | What happens |
|---|---|---|
| **full-stop** | `--full-stop` | You stay in the loop: it asks before each phase and before each merge. |
| **auto** | `--auto` | Ships to dev, verifies in a real environment, fixes PR findings, stops **ready for main**. |
| **yolo** | `--yolo` | auto, then merges main without asking if every check passes. |

No flag: it asks which mode first. Details: [references/ship-modes.md](references/ship-modes.md).

That's it. `lets-ship` handles everything: bootstraps `context/` if needed, spawns research agents, creates specs, executes tasks, runs multi-agent review, captures learnings.

## Skills

| Skill | What it does |
|---------|-------------|
| `/lets-ship` | Full pipeline: understand > plan > work > review > compound > PR loop > gated main merge |
| `/spec` | Create a spec with automatic research |
| `/work` | Execute current spec task-by-task |
| `/review` | Multi-agent code review (simplicity + spec + bugs) |
| `/compound` | Capture learnings + rate spec quality |
| `/pr-loop` | PR → bot review → dev merge → live verify → gated main merge |
| `/compound-refresh` | Audit `docs/solutions/` for stale/overlap (design stub) |
| `/status` | Progress overview, spec listing, team history |
| `/deepen` | Enhance spec with parallel research |
| `/audit` | Audit codebase docs via hierarchical swarm |

## Agents

Spawned as **team members** with persistent task traces:

| Agent | Role |
|-------|------|
| `repo-researcher` | Find codebase patterns and conventions |
| `learnings-researcher` | Surface past solutions (`docs/solutions/`) + foundation |
| `options-researcher` | Research approaches with trade-off analysis |
| `simplicity-reviewer` | Challenge complexity, find simpler alternatives |
| `spec-reviewer` | Verify spec compliance and completeness |
| `bug-hunter` | Hunt for bugs, edge cases, security issues |
| `anti-slop-reviewer` | Flag low-evidence TS/JS type patterns (advisory) |
| `finding-verifier` | Blind-challenge review findings — disprove or confirm with evidence |
| `context-worker` | Context-aware implementation agent |

## Directory Structure

```
context/
├── foundation/    # Human-authored truth (read-only for agents)
├── specs/         # Feature/fix/improve definitions
└── tasks/         # Atomic task breakdowns

docs/solutions/    # Captured learnings from /compound

~/.claude/teams/ship-*/   # Team traces (persist after completion)
~/.claude/tasks/ship-*/   # Task history (queryable via /status --teams)
```

## How Traceability Works

Every `/lets-ship` run creates a team (`ship-<feature>-<date>`) with tasks for each phase. Research agents, reviewers, and implementation steps all update their tasks with `## Findings` or `## Changes`. After completion:

- `/status --teams` lists all feature traces
- Each team's task list shows the full development history
- Research findings, review verdicts, and learnings are all queryable

## Philosophy

- **80% planning, 20% execution** — research before code
- **Compound engineering** — each unit of work makes the next easier
- **Trace everything** — teams and tasks persist as development history
- **Human gates** — full-stop asks at each phase; auto stops ready for main; only yolo merges main, and only when every check passes

## Full Documentation

See [SKILL.md](SKILL.md) for complete workflow, agent details, and rules.
