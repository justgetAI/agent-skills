---
name: status
description: Show current work status — active spec, tasks, and progress
---

# Status — Current Work Overview

Quick view of where you are and what's pending.

## Gather Status

### 1. Current Branch & Spec

```bash
# Get current branch
git branch --show-current

# Find active spec (most recent or matching branch)
ls -t context/specs/*.md | head -5
```

### 2. Task Progress

```bash
# If TodoRead available
TodoRead
```

Or scan spec for checkboxes:

```bash
# Count completed vs total
grep -c "\[x\]" context/specs/*.md  # completed
grep -c "\[ \]" context/specs/*.md  # pending
```

### 3. Active Teams (if using swarm)

```bash
ls ~/.claude/teams/ 2>/dev/null
cat ~/.claude/teams/*/config.json 2>/dev/null | jq -r '.teammates[] | "\(.name): \(.status)"'
```

## Output Format

```markdown
## 📊 Status

**Branch:** feat/add-stripe-payments
**Spec:** context/specs/2026-01-26-add-stripe-payments.md

### Progress
████████░░ 80% (8/10 tasks)

### Tasks
- [x] Set up Stripe SDK
- [x] Create payment intent endpoint
- [x] Add webhook handler
- [ ] Write tests ← in progress
- [ ] Update docs

### Active Agents
- simplicity-reviewer: idle
- spec-reviewer: running

### Next Action
Continue with: "Write tests"
```

## Options After Status

1. **Continue** — pick up where you left off
2. **Review** — run `/review` on current work
3. **Ship** — create PR
4. **New** — start fresh with `/let-it-rip`
