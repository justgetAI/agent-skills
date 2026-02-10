---
name: work
description: Execute current spec — task by task with progress tracking
argument-hint: "[spec file path, or empty to use current]"
---

# Work — Execute the Plan

Systematic execution with TodoWrite integration and incremental commits.

## Find Active Spec

<spec_path>$ARGUMENTS</spec_path>

**If empty:** 
```bash
# Find most recent spec
ls -t context/specs/*.md | head -1
```

Or check git branch name for hint.

**Confirm:** "Working on `<spec>`. Correct?"

---

## Setup Task List

**Auto-set `CLAUDE_CODE_TASK_LIST_ID` for cross-session sync.**

```bash
# Derive from spec name
SPEC_NAME=$(basename "<spec_path>" .md | sed 's/^[0-9-]*//')
export CLAUDE_CODE_TASK_LIST_ID="$SPEC_NAME"
```

**Why:** If you spawn sub-agents or continue in a new session, task state syncs automatically.

**Announce:** "Task list: `$CLAUDE_CODE_TASK_LIST_ID` — progress will sync across sessions."

---

## Setup

### 1. Read Spec

```
Read the spec file completely.
Extract:
- Acceptance criteria (the checkboxes)
- Technical approach
- References to existing code
```

### 2. Branch Setup

```bash
current=$(git branch --show-current)
default=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

if [ "$current" = "$default" ]; then
  # Create feature branch from spec name
  branch_name="feat/$(basename <spec> .md | sed 's/^[0-9-]*//')"
  git checkout -b "$branch_name"
fi
```

### 3. Create Tasks from Spec

Parse acceptance criteria into TodoWrite:

```javascript
TodoWrite({
  todos: [
    // Convert each [ ] criterion to a todo
    { id: "1", content: "First criterion", status: "pending" },
    { id: "2", content: "Second criterion", status: "pending" },
    // ...
  ]
})
```

---

## Execute

### Task Loop

```
while uncompleted tasks exist:
  
  1. Pick next pending task
     TodoWrite({ id: "<id>", status: "in_progress" })
  
  2. Read any referenced files from spec
  
  3. Find similar patterns in codebase:
     rg "pattern" --type <lang>
  
  4. Implement following conventions:
     - Match existing code style
     - Follow foundation rules
     - Keep it simple
  
  5. Run tests:
     # Use project's test command from foundation
  
  6. Mark complete:
     TodoWrite({ id: "<id>", status: "completed" })
  
  7. Update spec checkbox:
     Edit: [ ] → [x] for this criterion
  
  8. Commit if logical unit:
     git add <files>
     git commit -m "<type>(<scope>): <description>"
```

### Commit Guidelines

**Commit when:**
- Logical unit complete (model, endpoint, component)
- Tests pass
- Switching contexts (backend → frontend)

**Don't commit when:**
- Partial work that doesn't stand alone
- Tests failing
- Would require "WIP" message

---

## Progress Check

After each task, show:

```
## Progress
████████░░ 80% (4/5 tasks)

✅ Set up SDK
✅ Create endpoint
✅ Add validation
🔄 Write tests ← current
⬜ Update docs
```

---

## Completion

When all tasks done:

**"All tasks complete. Tests passing. What next?"**

1. **Review** — Run `/review` for code review
2. **Ship** — Create PR: `gh pr create`
3. **Compound** — Capture learnings
4. **Continue** — Add more tasks

---

## Quick Commands

| Situation | Action |
|-----------|--------|
| Stuck on task | Ask for help, spawn research agent |
| Need to pause | Tasks auto-save in TodoWrite |
| Want to skip | Mark task as `skipped` with reason |
| Found issue | Add new task via TodoWrite |
