---
name: review
description: Multi-agent code review before shipping
argument-hint: "[spec path or empty for current branch changes]"
---

# Review — Multi-Agent Code Review

Get feedback from multiple perspectives before shipping.

## Determine Scope

<spec_path>$ARGUMENTS</spec_path>

**If spec provided:** Review against spec acceptance criteria

**If empty:** Review current branch changes:
```bash
git diff $(git merge-base HEAD main)..HEAD --name-only
```

---

## Phase 1: Gather Changes

```bash
# Get list of changed files
changed_files=$(git diff --name-only main...HEAD)

# Get the actual diff
git diff main...HEAD
```

Read the spec if available for context.

---

## Phase 2: Spawn Reviewers (Parallel)

```javascript
// Simplicity reviewer - catches over-engineering
Task({
  subagent_type: "Plan",
  description: "Simplicity review",
  prompt: `Review these changes for unnecessary complexity:

Changed files: ${changed_files}

Focus on:
- Over-engineering / premature abstraction
- Simpler alternatives that would work
- Code that could be deleted
- Unnecessary dependencies added

Be direct and specific. Reference line numbers.`,
  model: "sonnet"
})

// Spec compliance reviewer
Task({
  subagent_type: "Plan",
  description: "Spec compliance review", 
  prompt: `Compare implementation against spec:

Spec: <spec_content>
Changed files: ${changed_files}

Check:
- All acceptance criteria implemented
- No scope creep (extra stuff not in spec)
- Technical approach matches spec
- Nothing missing

Be specific about gaps.`,
  model: "sonnet"
})

// Bug hunter
Task({
  subagent_type: "Plan",
  description: "Bug review",
  prompt: `Hunt for bugs in these changes:

Changed files: ${changed_files}

Look for:
- Edge cases not handled
- Error handling gaps
- Race conditions
- Security issues
- Null/undefined risks

Be paranoid. Reference specific code.`,
  model: "sonnet"
})
```

---

## Phase 3: Consolidate Feedback

Wait for all reviewers, then present:

```markdown
## 📋 Review Summary

### 🎯 Simplicity Reviewer
[Findings or "Looks good - no unnecessary complexity"]

### 📐 Spec Compliance  
[Findings or "All criteria met"]

### 🐛 Bug Hunter
[Findings or "No issues found"]

---

## Recommended Actions

### Must Fix (blocking)
1. [Critical issue]

### Should Fix (recommended)  
1. [Important improvement]

### Consider (optional)
1. [Nice to have]
```

---

## Phase 4: Decision Gate

**"Review complete. What would you like to do?"**

1. **Fix issues** — Address feedback, re-run review
2. **Ship anyway** — Create PR with known issues noted
3. **Discuss** — Clarify specific feedback
4. **Get more eyes** — Add another reviewer perspective

---

## Quick Review (Single Agent)

If you just want a quick check:

```javascript
Task({
  subagent_type: "Plan",
  description: "Quick review",
  prompt: "Quick review of changes. Top 3 concerns only. Be brief.",
  model: "haiku"
})
```

---

## Custom Reviewers

Add domain-specific reviewers:

```javascript
// Security reviewer
Task({
  subagent_type: "Plan",
  description: "Security review",
  prompt: "Review for security: auth, injection, data exposure...",
})

// Performance reviewer  
Task({
  subagent_type: "Plan", 
  description: "Performance review",
  prompt: "Review for performance: N+1 queries, unnecessary loads, caching...",
})
```
