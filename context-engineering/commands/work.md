---
name: work
description: Execute current spec — task by task with progress tracking
argument-hint: "[spec file path, or empty to use current]"
---

# work — Execute the Plan

Systematic execution with native task tracking and incremental commits.

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

## Team Awareness

If running inside a `lets-ship` team:
- Update the Phase 3 task status to `in_progress`
- Create implementation sub-tasks under the team
- All progress is traced in team task history

If running standalone:
- Create tasks locally for progress tracking

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

Parse acceptance criteria into native tasks:

```javascript
// For each acceptance criterion:
TaskCreate({
  subject: "Implement: <criterion>",
  description: "From spec: <criterion details>",
  activeForm: "Implementing <criterion>"
})
```

---

## Execute

### Task Loop

```
while uncompleted tasks exist:

  1. Pick next pending task
     TaskUpdate({ taskId, status: "in_progress" })

  2. Read any referenced files from spec

  3. Find similar patterns in codebase

  4. Implement following conventions:
     - Match existing code style
     - Follow foundation rules
     - Keep it simple

  5. Run tests

  6. Mark complete with changes:
     TaskUpdate({
       taskId,
       status: "completed",
       description: append "## Changes\n- file1.ts: added X\n- file2.ts: modified Y"
     })

  7. Update spec checkbox:
     Edit: [ ] -> [x] for this criterion

  8. Commit if logical unit:
     git add <files>
     git commit -m "<type>(<scope>): <description>"
```

### Commit Guidelines

**Commit when:**
- Logical unit complete (model, endpoint, component)
- Tests pass
- Switching contexts (backend -> frontend)

**Don't commit when:**
- Partial work that doesn't stand alone
- Tests failing
- Would require "WIP" message

---

## Progress Check

After each task, show:

```
## Progress
[========--] 80% (4/5 tasks)

[x] Set up SDK
[x] Create endpoint
[x] Add validation
[>] Write tests <- current
[ ] Update docs
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
| Need to pause | Tasks persist in native task list |
| Want to skip | Mark task as `completed` with "SKIPPED: reason" |
| Found issue | Add new task via TaskCreate |
