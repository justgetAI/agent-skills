# Context Loading Protocol

Use a **sub-agent** to load context. Keeps main agent lean.

## Two Sources of Truth

```
DEFINITIONS:  context/tasks/*.md        → What to do
STATE:        Claude Code Tasks         → Progress, blockers
```

Load both when starting work.

## Loader Prompt

```
Read and summarize the active context:

1. Read all files in context/foundation/
2. Identify active spec from git branch or Linear
3. Read that spec + its task definitions (context/tasks/{spec}-task*)
4. Check Claude Code Tasks for execution state (status, blockers)
5. Return condensed summary:
   - Key foundation facts relevant to current work
   - Spec goal
   - Task statuses (from Claude Code Tasks)
   - Any blockers (from Claude Code Tasks)

Be concise. Skip boilerplate.
```

## When to Reload

| Trigger | Action |
|---------|--------|
| Session start | Full context load + Tasks state |
| Switching specs | Load new spec + tasks + Tasks state |
| After long idle | Refresh from Claude Code Tasks |
| Spec completed | Clear spec context, reload foundation |

## Example: Loading feat001

```bash
# Set task list for state sync
export CLAUDE_CODE_TASK_LIST_ID=feat001-payments

# Agent reads DEFINITIONS:
context/foundation/*.md           # All foundation docs
context/specs/feat001-payments.md # Active spec
context/tasks/feat001-task*.md    # Task definitions

# Agent reads STATE from Claude Code Tasks:
~/.claude/tasks/feat001-payments.json  # Current statuses, blockers
```

## Context Summary Format

```markdown
## Foundation
- Key fact 1
- Key fact 2

## Active Spec: feat001-payments
Goal: Implement Stripe payment processing

## Tasks (state from Claude Code Tasks)
- [done] task001: Stripe integration
- [in-progress] task002: Webhook handling  
- [todo] task003: Error handling

## Blockers
- task002: Waiting for Stripe webhook secret
```
