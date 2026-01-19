# Claude Code Integration

Add this to your `CLAUDE.md`:

```markdown
## Context Engineering

This project uses context engineering for specs and tasks.

### On session start
Spawn a sub-agent to load context:
1. Read all files in `context/foundation/`
2. Read active spec from current branch name or ask user
3. Read related tasks: `context/tasks/{spec}-task*`
4. Return condensed summary

### When creating tasks
- Use templates from skill references
- Naming: `{type}{###}-task{###}-{name}.md`
- Update status as you work

### Foundation is read-only
- Never modify `context/foundation/` directly
- Note discoveries in task `## Discoveries` section
```
