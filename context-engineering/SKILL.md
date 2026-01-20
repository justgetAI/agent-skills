---
name: context-engineering
description: Human-readable context management for AI coding agents. Provides filesystem-based specs, tasks, and foundation docs that work across Claude Code, Cursor, OpenCode, and any markdown-instruction agent.
compatibility: Claude Code, Cursor, OpenCode, or any markdown-instruction agent
---

# Context Engineering

A filesystem-based context system. Human-readable, agent-friendly.

## Directory Structure

```
context/
├── foundation/    # Human-authored source of truth
├── specs/         # Feature/fix/improve definitions
└── tasks/         # Atomic implementation units
```

Run `scripts/init.sh` to scaffold.

---

## Naming Conventions

### Spec types
- `feat` — new functionality
- `fix` — bug fixes  
- `improve` — enhancements

### Format
- Specs: `{type}{###}-{name}.md`
- Tasks: `{type}{###}-task{###}-{name}.md`
- Edge cases: `misc-task{###}-{name}.md`

### Examples
```
specs/feat001-payments.md
specs/fix002-login-redirect.md
specs/improve003-dashboard-perf.md

tasks/feat001-task001-stripe-integration.md
tasks/feat001-task002-webhook-handling.md
tasks/misc-task001-bump-deps.md
```

### Numbering
- Spec numbers: global (feat001, feat002, fix001...)
- Task numbers: per-spec (feat001-task001, feat001-task002)

---

## Context Loading Protocol

**Use a sub-agent to load context.** Keeps main agent lean.

### Loader prompt
```
Read and summarize the active context:

1. Read all files in context/foundation/
2. Identify active spec from git branch or Linear
3. Read that spec + its tasks (context/tasks/{spec}-task*)
4. Return condensed summary:
   - Key foundation facts relevant to current work
   - Spec goal
   - Task statuses
   - Any blockers

Be concise. Skip boilerplate.
```

### When to reload
- Session start
- Switching specs
- After long idle

---

## Task Lifecycle

```
todo → in-progress → done
                  → blocked
```

- Agent updates own task status
- `done` tasks stay in place (no archiving)
- `blocked` must list blockers

---

## Foundation Rules

See [foundation-guidelines.md](references/foundation-guidelines.md)

- Human-authored only
- Agents read, never write directly
- Discoveries noted in task `## Discoveries` section
- Human reviews and updates foundation

---

## Conflict Resolution

- Humans assign spec numbers
- Agents only create tasks within assigned specs
- Prevents collision when multiple agents work same repo

---

## Self-Improvement Loop

Rate completed specs to drive system improvement.

### Feedback command
```
ctx feedback <spec> <1-5> [issue-slug]
```

### Rating guide
- 5: perfect
- 4: good, minor friction
- 3: acceptable, notable issues
- 2: poor, needs improvement  
- 1: failed

### Auto-improvement
When rating ≤ 3 with issue:
1. Updates spec's `## Feedback` section
2. Auto-creates `improve{###}-{issue}.md`
3. Links back to source spec

### Common issues
- `too-verbose` — sacrifice grammar for conciseness
- `wrong-format` — templates need adjustment
- `missed-context` — loading protocol gaps
- `unclear-instructions` — SKILL.md needs clarity

---

## Templates

- [spec-template.md](references/spec-template.md)
- [task-template.md](references/task-template.md)
