# Context Engineering

Ship features with full traceability. Filesystem-based specs, tasks, and foundation docs — powered by native Claude Code Teams.

## What is it?

An autonomous engineering workflow: understand > plan > work > review > compound. Every phase creates team members and tasks that persist as a queryable trace of **what** was built, **why**, and **how**.

Works across Claude Code, Cursor, OpenCode, and any markdown-instruction agent.

## Installation

### Claude Code Marketplace
```bash
claude plugin marketplace add justgetAI/agent-skills
claude plugin install context-engineering@justgetai-tools
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
# Full workflow — human gates at each phase
/lets-ship "add stripe payments"

# Autonomous — skip gates, auto-fix, auto-PR
/lets-ship --auto "fix login timeout"
```

That's it. `lets-ship` handles everything: bootstraps `context/` if needed, spawns research agents, creates specs, executes tasks, runs multi-agent review, captures learnings.

## Commands

| Command | What it does |
|---------|-------------|
| `/lets-ship` | Full pipeline: understand > plan > work > review > compound |
| `/spec` | Create a spec with automatic research |
| `/work` | Execute current spec task-by-task |
| `/review` | Multi-agent code review (simplicity + spec + bugs) |
| `/compound` | Capture learnings + rate spec quality |
| `/status` | Progress overview, spec listing, team history |
| `/deepen` | Enhance spec with parallel research |
| `/audit` | Audit codebase docs via hierarchical swarm |

## Agents

Spawned as **team members** with persistent task traces:

| Agent | Role |
|-------|------|
| `repo-researcher` | Find codebase patterns and conventions |
| `learnings-researcher` | Surface past solutions and anti-patterns |
| `options-researcher` | Research approaches with trade-off analysis |
| `simplicity-reviewer` | Challenge complexity, find simpler alternatives |
| `spec-reviewer` | Verify spec compliance and completeness |
| `bug-hunter` | Hunt for bugs, edge cases, security issues |
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
- **Human gates** — approve at each phase (or skip with `--auto`)

## Full Documentation

See [SKILL.md](SKILL.md) for complete workflow, agent details, and rules.
