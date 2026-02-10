# Task Lifecycle

## States

```
todo → in-progress → done
                  ↘ blocked
```

| State | Meaning |
|-------|---------|
| `todo` | Not started |
| `in-progress` | Currently being worked on |
| `done` | Completed (stays in place, no archiving) |
| `blocked` | Cannot proceed — must list blockers |

## State Management

**Execution state lives in Claude Code Tasks, not in task files.**

```
context/tasks/*.md          → DEFINITION (what to do)
~/.claude/tasks/<list>.json → STATE (progress, blockers)
```

### Why?
- Cross-session sync (subagents see each other's progress)
- No file conflicts
- Live broadcasts when state changes

### How?
```bash
# Use native Teams for shared state across agents
TeamCreate({ team_name: "ship-payments-20260126" })

# Or use TaskCreate/TaskList for single-session tracking
TaskCreate({ subject: "Implement payments", ... })
```

## Updating State

Use Claude Code Tasks commands (not file edits):

```
# Mark task in-progress
Task feat001-task001: starting

# Mark blocked
Task feat001-task001: blocked - waiting for Stripe webhook secret

# Mark done
Task feat001-task001: done
```

## Task File Content (Definition Only)

Task files contain **what** to do, not **status**:

```markdown
# feat001-task001: Stripe Integration

## Goal
Implement payment processing with Stripe.

## Acceptance Criteria
- Customer creation works
- Payment intent flow handles success/failure
- Errors logged properly

## Technical Notes
- Use stripe-node SDK
- Idempotency keys required
```

## Completion

When done, optionally add a `## Summary` section to the task file for future reference:

```markdown
## Summary
Implemented Stripe payment processing with:
- Customer creation
- Payment intent flow
- Error handling for declined cards

## Files Changed
- src/payments/stripe.ts
- src/api/checkout.ts
```

This stays in the definition file as documentation. State remains in Claude Code Tasks.
