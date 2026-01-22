# Planning Workflow

**80% planning, 20% execution.** Thorough planning prevents wasted work.

## The Planning Flow

```
Idea → Refinement → Research → Options → Decision → Spec Draft → Review → Approved Spec
```

**80% planning, 20% execution.** The options research closes the loop upfront.

### Phase 1: Idea Refinement

Before any research, clarify the idea:

```markdown
## Idea Refinement

**What:** [one sentence]
**Why:** [problem being solved]
**Who:** [who benefits]
**Success looks like:** [measurable outcome]
```

Ask clarifying questions until the idea is crisp.

### Phase 2: Research (Parallel)

Run two researchers in parallel:

| Agent | Purpose |
|-------|---------|
| [repo-researcher](../agents/repo-researcher.md) | Find existing patterns, conventions, related code |
| [learnings-researcher](../agents/learnings-researcher.md) | Surface past learnings and anti-patterns |

```
┌─────────────────┐     ┌─────────────────┐
│ repo-researcher │     │learnings-researcher│
└────────┬────────┘     └────────┬────────┘
         │                       │
         └───────────┬───────────┘
                     ▼
           [Consolidated Research]
```

### Phase 3: Research Decision

Based on findings, decide if external research is needed:

| Signal | Action |
|--------|--------|
| Familiar pattern, clear path | Skip external research |
| New technology/pattern | Research framework docs |
| High risk/complexity | Deep research before proceeding |
| Security/compliance implications | Mandatory security research |

### Phase 4: Options Research (Recommended)

Before committing to an approach, research how others solve it:

Run [options-researcher](../agents/options-researcher.md):

```
┌─────────────────────────────────────────────┐
│            Options Researcher               │
├─────────────────────────────────────────────┤
│ 1. Identify enterprise companies in space   │
│ 2. Identify open-source solutions           │
│ 3. Research their approaches                │
│ 4. Present 2-4 options with trade-offs      │
└─────────────────────────────────────────────┘
                    ↓
        ┌─────────────────────┐
        │  Option A: Stripe   │
        │  Option B: Square   │
        │  Option C: Simple   │
        └─────────────────────┘
                    ↓
        User picks approach with
        full context of trade-offs
```

**Example output:**
```markdown
## Options: Payment State Handling

### Option A: Event Sourcing (Stripe's approach)
- Used by: Stripe, Adyen
- Pros: Full audit trail, time-travel debugging
- Cons: Complex, learning curve
- Best when: Need complete history, regulatory requirements

### Option B: State Machine + Audit Log (Square's approach)
- Used by: Square, most fintech
- Pros: Simpler, familiar pattern
- Cons: Audit log separate from state
- Best when: Moderate scale, team knows state machines

### Option C: Status Field + History Table
- Used by: Most startups
- Pros: Dead simple, fast to build
- Cons: No formal transitions, easy to corrupt
- Best when: MVP, low scale, need speed
```

This **closes the loop** — user makes informed decision before spec is written.

### Phase 5: Spec Creation

Using research findings, create the spec:

```markdown
---
type: feat
number: [assigned by human]
title: [clear title]
planning:
  detail_level: MINIMAL | MORE | COMPREHENSIVE
  research_done: [local | local+external]
  confidence: HIGH | MEDIUM | LOW
---

# [spec-id] - [Title]

## Goal
[One paragraph max]

## Research Summary
[Key findings from research phase]

## Requirements
- [ ] [Requirement 1]
- [ ] [Requirement 2]

## Non-Goals
- [What we're explicitly NOT doing]

## Tasks
- [ ] task001: [atomic task]
- [ ] task002: [atomic task]

## Risks
- [Risk 1]: [mitigation]
```

### Phase 6: Review

Before marking spec as ready:

```
┌─────────────────┐     ┌─────────────────┐
│  spec-reviewer  │     │simplicity-reviewer│
└────────┬────────┘     └────────┬────────┘
         │                       │
         └───────────┬───────────┘
                     ▼
           [Approved or Revise]
```

Both must pass for spec to be approved.

---

## Detail Levels

Choose based on complexity:

| Level | When to Use | Spec Size |
|-------|-------------|-----------|
| **MINIMAL** | Simple, familiar patterns | ~50 lines |
| **MORE** | Moderate complexity, some unknowns | ~100 lines |
| **COMPREHENSIVE** | High risk, new territory | ~200+ lines |

---

## Quick Commands

```bash
# Start planning flow
ctx plan "feature idea"

# Run research
ctx research "feature keywords"

# Review spec
ctx review specs/feat001-feature.md
```

---

## Example Flow

```
Human: "We need Stripe payments"

1. Refinement:
   - What: Accept card payments
   - Why: Revenue
   - Success: Checkout completes, money received

2. Research (parallel):
   - repo-researcher: Found existing Payment interface
   - learnings-researcher: "Use idempotency keys" from past issue

3. Decision: Need Stripe docs (new integration)

4. External research: Stripe Payment Intents API

5. Spec draft: feat001-stripe-payments.md

6. Review:
   - spec-reviewer: APPROVED (clear, complete)
   - simplicity-reviewer: APPROVED (no over-engineering)

7. Result: Spec ready for implementation
```
