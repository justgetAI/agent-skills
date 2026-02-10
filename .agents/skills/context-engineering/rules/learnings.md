# Learnings System

Capture learnings after work completes. Make future work easier.

## The Compound Effect

> Every solved problem should make the next one easier.

When you solve a non-trivial problem, document it so the next person (or agent) doesn't repeat the journey.

## Directory Structure

```
context/
├── learnings/        # Solved problems, patterns discovered
│   ├── stripe-idempotency.md
│   ├── react-query-patterns.md
│   └── supabase-rls-gotchas.md
└── anti-patterns/    # What NOT to do
    ├── nested-callbacks.md
    └── god-objects.md
```

## Learning Format

```markdown
---
title: [Clear title]
date: 2026-01-22
source: [feat001 | fix002 | discovery]
tags: [api, payments, performance]
---

# [Title]

## Context
[When this applies]

## Problem
[What went wrong / was confusing]

## Solution
[What worked]

## Code Example
\`\`\`typescript
// Working pattern
\`\`\`

## Key Insight
[One-liner to remember]
```

## Anti-Pattern Format

```markdown
---
title: [Don't do X]
severity: HIGH | MEDIUM | LOW
date: 2026-01-22
---

# Don't: [Anti-pattern name]

## The Temptation
[Why this seems like a good idea]

## The Problem
[What actually happens]

## Instead, Do This
[The correct approach]

## Example
\`\`\`typescript
// ❌ Bad
[bad code]

// ✅ Good
[good code]
\`\`\`
```

## When to Document

| Signal | Action |
|--------|--------|
| Took >1 hour to figure out | Document as learning |
| Made the same mistake twice | Document as anti-pattern |
| Found undocumented gotcha | Document as learning |
| Discovered better pattern | Document as learning |
| Spec rated ≤3 | Extract learning from failure |

## Workflow Integration

After completing a spec:

1. Review what was learned
2. Check if it's already documented
3. If novel, create learning/anti-pattern
4. Link back to source spec

```bash
# Add learning
ctx learn "Stripe requires idempotency keys for retries"

# Add anti-pattern  
ctx anti-pattern "Don't nest more than 2 callbacks"
```

## Retrieval

Learnings are automatically searched during planning:

```
ctx plan "new feature" 
  → learnings-researcher scans context/learnings/
  → Surfaces relevant past solutions
```
