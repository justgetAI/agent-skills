---
name: status
description: Show current work status — specs, tasks, teams, and progress
argument-hint: "[--teams] [--cleanup]"
---

# status — Current Work Overview

Quick view of where you are and what's pending.

## Flags

| Flag | Effect |
|------|--------|
| `--teams` | Show team history from `~/.claude/teams/ship-*` |
| `--cleanup` | Remove completed team directories |

---

## Gather Status

### 1. Current Branch & Spec

```bash
# Get current branch
git branch --show-current

# Find active spec (most recent or matching branch)
ls -t context/specs/*.md | head -5
```

### 2. Spec Listing (from context-list)

List all specs with completion status:

```bash
# For each spec file, count checked vs unchecked criteria
for spec in context/specs/*.md; do
  name=$(basename "$spec" .md)
  done=$(grep -c "\[x\]" "$spec" 2>/dev/null || echo 0)
  total=$((done + $(grep -c "\[ \]" "$spec" 2>/dev/null || echo 0)))
  echo "$name: $done/$total"
done
```

### 3. Task Progress

Read current task list:

```javascript
TaskList()  // Native task list
```

Or scan spec for checkboxes:

```bash
grep -c "\[x\]" context/specs/*.md  # completed
grep -c "\[ \]" context/specs/*.md  # pending
```

### 4. Team History (--teams)

```bash
# List all ship teams
ls -d ~/.claude/teams/ship-* 2>/dev/null

# For each team, show task summary
for team in ~/.claude/teams/ship-*/; do
  team_name=$(basename "$team")
  echo "## $team_name"
  cat "$team/config.json" 2>/dev/null | head -5
  # Read task list for this team
  ls ~/.claude/tasks/$team_name/ 2>/dev/null
done
```

---

## Output Format

```markdown
## Status

**Branch:** feat/add-stripe-payments
**Spec:** context/specs/2026-01-26-feat-add-stripe-payments.md

### All Specs
| Spec | Progress | Status |
|------|----------|--------|
| 2026-01-26-feat-payments | 8/10 | in-progress |
| 2026-01-20-fix-login | 5/5 | done |
| 2026-01-15-improve-search | 3/7 | in-progress |

### Current Tasks
[x] Set up Stripe SDK
[x] Create payment intent endpoint
[x] Add webhook handler
[ ] Write tests <- in progress
[ ] Update docs

### Team History (--teams)
| Team | Date | Phases | Status |
|------|------|--------|--------|
| ship-stripe-payments-20260126 | Jan 26 | 5/5 | complete |
| ship-fix-login-20260120 | Jan 20 | 5/5 | complete |
| ship-search-perf-20260115 | Jan 15 | 3/5 | in-progress |

### Next Action
Continue with: "Write tests"
```

---

## Cleanup (--cleanup)

Remove completed team directories:

```bash
# List teams to clean
for team in ~/.claude/teams/ship-*/; do
  team_name=$(basename "$team")
  # Check if all phase tasks are complete
  # If so, offer to delete
done
```

**Confirm before deleting:** "Remove N completed team traces? (They're just history — no code affected)"

---

## Options After Status

1. **Continue** — pick up where you left off
2. **Review** — run `/review` on current work
3. **Ship** — create PR
4. **New** — start fresh with `/lets-ship`
