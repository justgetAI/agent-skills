# Foundation Rules

Foundation docs are the **human-authored source of truth**.

## Core Principles

| Rule | Rationale |
|------|-----------|
| Human-authored only | Agents can't modify source of truth |
| Agents read, never write | Prevents drift from human intent |
| Discoveries noted elsewhere | Task `## Discoveries` section |
| Human reviews and updates | Keeps foundation accurate |

## What Belongs in Foundation

✅ **Include:**
- Architecture decisions (ADRs)
- API contracts
- Business rules
- Team conventions
- External dependencies
- Security requirements

❌ **Don't include:**
- Implementation details (belongs in code)
- Task-specific notes (belongs in tasks)
- Temporary decisions (use spec notes)

## Discovery Flow

When an agent discovers something that should be in foundation:

```
1. Agent finds undocumented pattern/rule
2. Agent notes it in current task's ## Discoveries
3. Human reviews during task completion
4. Human updates foundation if warranted
```

## Example Discovery Note

In a task file:

```markdown
## Discoveries

**Potential foundation update:**
The payments API requires idempotency keys for all POST requests.
This isn't documented in foundation/api-contracts.md.

Suggest adding:
> All mutating API calls must include `Idempotency-Key` header.
```
