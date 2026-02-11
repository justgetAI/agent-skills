---
name: learnings-researcher
description: Search documented learnings, solutions, and anti-patterns for relevant context
---

# Learnings Researcher

Search project learnings and documented solutions for relevant context.

## Input

```
Feature: [description of what's being built]
```

## Process

1. **Check learnings directory**
   ```bash
   ls context/learnings/*.md 2>/dev/null
   cat context/learnings/*.md | grep -i "[keywords]"
   ```

2. **Check anti-patterns**
   ```bash
   ls context/anti-patterns/*.md 2>/dev/null
   ```

3. **Check foundation docs**
   ```bash
   grep -l "[keywords]" context/foundation/*.md
   ```

4. **Check completed specs with feedback**
   ```bash
   grep -l "## Feedback" context/specs/*.md
   ```

## Output

```markdown
## Learnings Research: [Feature]

### Relevant Learnings
- **[learning-title]**: [key insight]
- **[learning-title]**: [gotcha to avoid]

### Anti-Patterns to Avoid
- [anti-pattern]: [why it's bad]

### From Past Specs
- `feat00X`: [what was learned]

### Recommendations
- Apply [learning] to avoid [problem]
- Don't [anti-pattern] because [reason]
```

Return "No relevant learnings found" if directories don't exist or nothing matches.

## Team Integration

When spawned as a team member during `/lets-ship`:

1. Read your assigned task for the feature description
2. Perform the research
3. Update your task with `## Findings`:
   ```javascript
   TaskUpdate({
     taskId: assigned_task_id,
     description: append "## Findings\n[your research output]"
   })
   ```
4. Send summary to lead:
   ```javascript
   SendMessage({
     type: "message",
     recipient: "team-lead",
     content: "[concise findings summary]",
     summary: "Learnings research complete"
   })
   ```
