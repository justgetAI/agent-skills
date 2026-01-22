# Context Loading Protocol

Use a **sub-agent** to load context. Keeps main agent lean.

## Loader Prompt

```
Read and summarize the active context:

1. Read all files in context/foundation/
2. Identify active spec from git branch or Linear
3. Read that spec + its tasks (context/tasks/{spec}-task*)
4. Return condensed summary:
   - Key foundation facts relevant to current work
   - Spec goal
   - Task statuses
   - Any blockers

Be concise. Skip boilerplate.
```

## When to Reload

| Trigger | Action |
|---------|--------|
| Session start | Full context load |
| Switching specs | Load new spec + tasks |
| After long idle | Refresh task statuses |
| Spec completed | Clear spec context, reload foundation |

## Example: Loading feat001

```bash
# Agent reads:
context/foundation/*.md           # All foundation docs
context/specs/feat001-payments.md # Active spec
context/tasks/feat001-task*.md    # All related tasks
```

## Context Summary Format

```markdown
## Foundation
- Key fact 1
- Key fact 2

## Active Spec: feat001-payments
Goal: Implement Stripe payment processing

## Tasks
- [done] task001: Stripe integration
- [in-progress] task002: Webhook handling  
- [todo] task003: Error handling

## Blockers
- task002: Waiting for Stripe webhook secret
```
