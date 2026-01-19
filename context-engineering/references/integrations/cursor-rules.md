# Cursor Integration

## Sub-agent spawning
Cursor Composer can handle multi-file reads efficiently.
For large foundations, consider chunked reading or ask user to specify focus area.

## .cursorrules snippet

Add this to `.cursor/rules` or `.cursorrules`:

```
## Context Engineering

This project uses context engineering for specs and tasks.

On session start:
- Read context/foundation/* for project ground truth
- Ask user which spec is active, or infer from branch
- Read that spec + its tasks from context/tasks/

When creating tasks:
- Use naming: {type}{###}-task{###}-{name}.md
- Status options: todo | in-progress | done | blocked
- Update status as you work

Foundation is read-only:
- Never modify context/foundation/ directly
- Note discoveries in task ## Discoveries section
- Human will review and update foundation
```
