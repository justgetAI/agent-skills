---
name: review
description: Multi-agent code review — spawns reviewers as team members for full traceability
argument-hint: "[spec path or empty for current branch changes]"
---

# review — Multi-Agent Code Review

Get feedback from multiple perspectives before shipping. Reviewers are spawned as team members so findings persist.

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

## Phase 2: Spawn Reviewers as Team Members

### Team Setup (if not already in a team)

```javascript
// Create review team if running standalone
if (!current_team) {
  TeamCreate({ team_name: `review-${Date.now()}` })
}
```

### Create Review Tasks

```javascript
TaskCreate({
  subject: "Review: simplicity",
  description: "Check for over-engineering, unnecessary complexity, simpler alternatives"
})

TaskCreate({
  subject: "Review: spec compliance",
  description: "Verify all acceptance criteria met, no scope creep, matches technical approach"
})

TaskCreate({
  subject: "Review: bug hunting",
  description: "Hunt for edge cases, error handling gaps, race conditions, security issues"
})
```

### Spawn Team Members (Parallel)

```javascript
Task({
  team_name: current_team,
  name: "simplicity-reviewer",
  subagent_type: "context-engineering:simplicity-reviewer",
  description: "Simplicity review",
  prompt: `Review these changes for unnecessary complexity:

Changed files: ${changed_files}

Focus on:
- Over-engineering / premature abstraction
- Simpler alternatives that would work
- Code that could be deleted
- Unnecessary dependencies added

Be direct and specific. Reference line numbers.
Update your task with ## Findings when done. SendMessage to lead with summary.`,
  model: "sonnet"
})

Task({
  team_name: current_team,
  name: "spec-reviewer",
  subagent_type: "context-engineering:spec-reviewer",
  description: "Spec compliance review",
  prompt: `Compare implementation against spec:

Spec: <spec_content>
Changed files: ${changed_files}

Check:
- All acceptance criteria implemented
- No scope creep (extra stuff not in spec)
- Technical approach matches spec
- Nothing missing

Be specific about gaps.
Update your task with ## Findings when done. SendMessage to lead with summary.`,
  model: "sonnet"
})

Task({
  team_name: current_team,
  name: "bug-hunter",
  subagent_type: "context-engineering:bug-hunter",
  description: "Bug hunting review",
  prompt: `Hunt for bugs in these changes:

Changed files: ${changed_files}

Look for:
- Edge cases not handled
- Error handling gaps
- Race conditions
- Security issues (OWASP top 10)
- Null/undefined risks
- Resource leaks

Be paranoid. Reference specific code.
Update your task with ## Findings when done. SendMessage to lead with summary.`,
  model: "sonnet"
})
```

---

## Phase 3: Consolidate Feedback

Wait for all reviewers to report back via SendMessage. Then present:

```markdown
## Review Summary

### Simplicity Reviewer
[Findings or "Looks good — no unnecessary complexity"]

### Spec Compliance
[Findings or "All criteria met"]

### Bug Hunter
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
2. **Ship as-is** — Proceed to compound
3. **Discuss** — Clarify specific feedback
4. **Get more eyes** — Add another reviewer perspective

---

## Shutdown Reviewers

After decision:

```javascript
// Shutdown reviewer team members
SendMessage({ type: "shutdown_request", recipient: "simplicity-reviewer" })
SendMessage({ type: "shutdown_request", recipient: "spec-reviewer" })
SendMessage({ type: "shutdown_request", recipient: "bug-hunter" })
```

Review tasks with ## Findings persist as trace.

---

## Quick Review (Single Agent — No Team)

For a fast check without team overhead:

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

Add domain-specific reviewers as team members:

```javascript
// Security reviewer
Task({
  team_name: current_team,
  name: "security-reviewer",
  subagent_type: "general-purpose",
  description: "Security review",
  prompt: "Review for security: auth, injection, data exposure..."
})

// Performance reviewer
Task({
  team_name: current_team,
  name: "perf-reviewer",
  subagent_type: "general-purpose",
  description: "Performance review",
  prompt: "Review for performance: N+1 queries, unnecessary loads, caching..."
})
```
