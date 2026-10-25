# Learnings System

Capture learnings after work completes. Make future work easier.

## The Compound Effect

> Every solved problem should make the next one easier.

When you solve a non-trivial problem, document it so the next person (or agent) doesn't repeat the journey.

## Where Learnings Live

`/compound` is the writer. Search what it actually writes:

```
docs/solutions/              # Dated solution write-ups (primary)
└── YYYY-MM-DD-<topic>.md

context/foundation/          # Durable project knowledge
├── gotchas.md               # Warnings / pitfalls
├── workflows.md             # Useful commands & flows
└── conventions.md           # Project conventions
```

See `/compound` Phase 2 for the routing table (convention → foundation, solution → `docs/solutions/`, etc.).

## Solution Format

```markdown
---
title: [Clear title]
date: 2026-01-22
source: [2026-01-22-feat-payments | discovery]
tags: [api, payments, performance]
---

# [Title]

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

## When to Document

| Signal | Action |
|--------|--------|
| Took >1 hour to figure out | Write a `docs/solutions/` entry |
| Made the same mistake twice | Add to `context/foundation/gotchas.md` |
| Found undocumented gotcha | Foundation gotchas or a solution doc |
| Discovered better pattern | Solution doc + conventions if durable |
| Spec rated ≤3 | Extract learning from failure via `/compound` |

## Workflow Integration

After completing a spec:

1. Run `/compound` (or `/lets-ship` Phase 5)
2. Check whether the lesson is already documented
3. If novel, write the solution / foundation update
4. Link back to the source spec when useful

## Retrieval

Learnings are searched during planning:

```
/lets-ship or /spec
  → learnings-researcher scans docs/solutions/ + context/foundation/
  → Surfaces relevant past solutions
```

## Legacy dirs

`context/learnings/` and `context/anti-patterns/` are **not** written by `/compound`. Do not advertise them as the store. If present in an old repo, read-only fallback only — see [structure.md](structure.md).
