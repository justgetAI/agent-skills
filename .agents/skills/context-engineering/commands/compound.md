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

## Compound Ritual

Make it a habit:
1. Finish feature → spend 5 min on `/compound`
2. Weekly: review `docs/solutions/`, clean up or consolidate
3. Monthly: review `context/foundation/`, update outdated info
