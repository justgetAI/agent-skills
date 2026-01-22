---
name: context-engineering
description: Human-readable context management for AI coding agents. Filesystem-based specs, tasks, and foundation docs.
compatibility: Claude Code, Cursor, OpenCode, or any markdown-instruction agent
---

# Context Engineering

A filesystem-based context system. Human-readable, agent-friendly.

```
context/
├── foundation/    # Human-authored source of truth
├── specs/         # Feature/fix/improve definitions
└── tasks/         # Atomic implementation units
```

Run `scripts/init.sh` to scaffold.

---

## Rules

| Rule | Description |
|------|-------------|
| [structure](rules/structure.md) | Directory layout and purpose |
| [naming](rules/naming.md) | File naming conventions |
| [planning](rules/planning.md) | Planning workflow (80/20 rule) |
| [loading](rules/loading.md) | Context loading protocol |
| [lifecycle](rules/lifecycle.md) | Task states and transitions |
| [foundation](rules/foundation.md) | Foundation doc guidelines |
| [learnings](rules/learnings.md) | Capturing learnings and anti-patterns |
| [subagents](rules/subagents.md) | Parallel sub-agent patterns |
| [feedback](rules/feedback.md) | Self-improvement loop |

---

## Agents

| Agent | Purpose |
|-------|---------|
| [repo-researcher](agents/repo-researcher.md) | Research codebase patterns and conventions |
| [learnings-researcher](agents/learnings-researcher.md) | Surface past learnings and anti-patterns |
| [options-researcher](agents/options-researcher.md) | Research enterprise/OSS approaches, present options |
| [spec-reviewer](agents/spec-reviewer.md) | Review specs for clarity and completeness |
| [simplicity-reviewer](agents/simplicity-reviewer.md) | Challenge complexity, find simpler solutions |

---

## Quick Reference

### Planning Flow (80% planning, 20% execution)
```
Idea → Refinement → Research → Options → Decision → Spec Draft → Review → Approved
```

### Naming
```
specs/feat001-payments.md
tasks/feat001-task001-stripe.md
learnings/stripe-idempotency.md
```

### Task States
```
todo → in-progress → done
                  ↘ blocked
```

### Load Context (sub-agent)
```
Read context/foundation/*.md + active spec + its tasks.
Return condensed summary.
```

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

## Commands

See [commands/](commands/) for available CLI commands.
