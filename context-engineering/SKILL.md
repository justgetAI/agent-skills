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
| [loading](rules/loading.md) | Context loading protocol |
| [lifecycle](rules/lifecycle.md) | Task states and transitions |
| [foundation](rules/foundation.md) | Foundation doc guidelines |
| [feedback](rules/feedback.md) | Self-improvement loop |

---

## Quick Reference

### Naming
```
specs/feat001-payments.md
tasks/feat001-task001-stripe.md
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
