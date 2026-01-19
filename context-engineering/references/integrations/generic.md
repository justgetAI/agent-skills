# Generic Integration

## Sub-agent spawning
If your agent supports sub-tasks or background workers:
- Spawn a "context loader" to read foundation + active spec
- Have it return a condensed summary
- Main agent receives summary without full file contents

If no sub-agent support:
- Read foundation files sequentially
- Summarize in working memory before proceeding

## System prompt snippet

For agents without native skill support, include this in your system prompt:

---

## Context Engineering System

This project uses a filesystem-based context system:

```
context/
├── foundation/   # Source of truth (read-only for agents)
├── specs/        # Feature/fix/improve definitions
└── tasks/        # Atomic implementation units
```

### Session start protocol
1. Read all files in `context/foundation/`
2. Identify active spec (ask user or check git branch)
3. Read spec file + related tasks (`context/tasks/{spec}-task*`)

### Naming conventions
- Specs: `{type}{###}-{name}.md` (feat001, fix002, improve003)
- Tasks: `{type}{###}-task{###}-{name}.md`
- Edge cases: `misc-task{###}-{name}.md`

### Task lifecycle
- Status: `todo` → `in-progress` → `done` | `blocked`
- Update your task status as you work
- Done tasks stay in place (no archiving)

### Foundation rules
- Human-authored only — never modify directly
- If you discover something that should be in foundation:
  - Note it in your task's `## Discoveries` section
  - Human will review and update foundation

---
