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

## State Updates

Agents update their own task status in the frontmatter:

```yaml
---
status: in-progress  # was: todo
updated: 2026-01-22
---
```

## Blocked Tasks

When blocked, add a `## Blockers` section:

```markdown
---
status: blocked
---

# feat001-task002: Webhook Handling

## Blockers
- [ ] Waiting for Stripe webhook secret from ops team
- [ ] Need clarification on retry policy

## Work Done So Far
- Set up webhook endpoint
- Added signature verification logic
```

## Completion

When done, update status and add summary:

```markdown
---
status: done
completed: 2026-01-22
---

# feat001-task001: Stripe Integration

## Summary
Implemented Stripe payment processing with:
- Customer creation
- Payment intent flow
- Error handling for declined cards

## Files Changed
- src/payments/stripe.ts
- src/api/checkout.ts
```
