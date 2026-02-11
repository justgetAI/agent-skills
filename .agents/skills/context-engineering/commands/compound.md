---
name: compound
description: Capture learnings so future work is easier
argument-hint: "[topic or empty to reflect on current work]"
---

# Compound — Capture Learnings

Make future work easier by documenting what you learned.

> "Each unit of engineering work should make subsequent units easier—not harder."

---

## Reflect on Current Work

<topic>$ARGUMENTS</topic>

**If empty:** Look at recent commits and current spec:
```bash
git log --oneline -10
ls -t context/specs/*.md | head -1
```

---

## Phase 1: Extract Learnings

Ask yourself (or the user):

### Patterns Discovered
- "What patterns did we use that worked well?"
- "Any code worth referencing for future work?"

### Gotchas & Pitfalls  
- "What tripped us up?"
- "What would we do differently next time?"

### Conventions Established
- "Did we establish any new conventions?"
- "Should these be added to foundation?"

### Tools & Techniques
- "What tools/commands were useful?"
- "Any workflows worth documenting?"

---

## Phase 2: Decide Where to Document

| Learning Type | Location |
|--------------|----------|
| Project convention | `context/foundation/<topic>.md` |
| Solution/pattern | `docs/solutions/YYYY-MM-DD-<topic>.md` |
| Gotcha/warning | `context/foundation/gotchas.md` |
| Useful command | `context/foundation/workflows.md` |

---

## Phase 3: Write It Down

### For Solutions (`docs/solutions/`)

```markdown
---
title: [What we solved]
date: YYYY-MM-DD
tags: [relevant, tags]
---

# [Problem Title]

## Problem
[What issue we faced]

## Solution
[How we solved it]

## Code Example
```<lang>
// Key code snippet
```

## Why This Works
[Explanation]

## Gotchas
- [Thing to watch out for]

## References
- [Link to PR/commit]
- [External docs]
```

### For Foundation Updates

```markdown
## [New Section] (append to relevant foundation file)

[Convention or rule]

Example:
```<lang>
// How to do it
```
```

---

## Phase 4: Verify Compounding

Quick check that the learning is useful:

- [ ] Someone unfamiliar could understand it
- [ ] Includes concrete example
- [ ] Searchable (good title, tags)
- [ ] Links to actual code

---

## Auto-Compound Prompts

After completing work, consider:

1. **"What took longer than expected?"** → Document the gotcha
2. **"What pattern will we reuse?"** → Document the pattern  
3. **"What would break if someone didn't know X?"** → Add to foundation
4. **"What external resource was helpful?"** → Save the link

---

## Examples

### Good Learning Entry

```markdown
# Stripe Webhook Signature Verification

## Problem
Webhooks were failing in production but working locally.

## Solution
Must use raw body for signature verification, not parsed JSON.

```ruby
# ❌ Wrong - body already parsed
post '/webhooks/stripe' do
  Stripe::Webhook.construct_event(request.body.read, ...)
end

# ✅ Right - use raw body before parsing
post '/webhooks/stripe' do
  payload = request.env['rack.input'].read
  Stripe::Webhook.construct_event(payload, ...)
end
```

## Gotcha
Express.js and Rails both parse JSON by default before your handler runs.
```

---

## Phase 4: Rate Spec

After capturing learnings, rate the spec that drove this work.

### Rating Guide

| Rating | Meaning |
|--------|---------|
| 5 | Perfect — no issues during implementation |
| 4 | Good — minor friction |
| 3 | Acceptable — notable issues |
| 2 | Poor — needs improvement |
| 1 | Failed — major rework needed |

### Process

1. Ask user to rate (or auto-rate from heuristics in `--auto` mode)
2. Update spec's `## Feedback` section:
   ```markdown
   ## Feedback
   Rating: X/5
   Issue: [what could be better — blank if rating > 3]
   ```

3. **When rating <= 3 with an issue:**
   - Auto-create `context/specs/YYYY-MM-DD-improve-<issue-slug>.md`
   - Link back to source spec for context
   - Example: `improve-too-verbose` creates a spec to make outputs more concise

### Auto-Rating Heuristics (--auto mode)

- 0 fix iterations in review + all criteria met → 5
- 1 fix iteration + all criteria met → 4
- 2 fix iterations or missing criteria → 3
- Must Fix issues persisted → 2

---

## Team Integration

When called from `lets-ship`, compound updates the Phase 5 task:

```javascript
TaskUpdate({
  taskId: phase5_id,
  description: append "## Learnings\n- ...\n\n## Spec Rating: X/5"
})
```

Learnings and ratings persist in the team trace.

---

## Compound Ritual

Make it a habit:
1. Finish feature → spend 5 min on `/compound`
2. Weekly: review `docs/solutions/`, clean up or consolidate
3. Monthly: review `context/foundation/`, update outdated info
