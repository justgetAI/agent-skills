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

**If empty:** Review current branch changes against the resolved review base (see Phase 1).

---

## Phase 1: Gather Changes

```bash
# Resolve the review base — see references/review-base.md
current=$(git branch --show-current)
default=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
default=${default:-main}

if git rev-parse --verify -q origin/dev >/dev/null || git rev-parse --verify -q dev >/dev/null; then
  base=dev
else
  base=$default
fi

if [ "$base" = "$current" ]; then
  for candidate in "$default" main master; do
    [ "$candidate" = "$current" ] && continue
    if git rev-parse --verify -q "origin/$candidate" >/dev/null || git rev-parse --verify -q "$candidate" >/dev/null; then
      base=$candidate
      break
    fi
  done
fi

git rev-parse --verify -q "origin/$base" >/dev/null && base="origin/$base"
base=${CE_REVIEW_BASE:-$base}

merge_base=$(git merge-base HEAD "$base")
changed_files=$(git diff --name-only "$merge_base"..HEAD)
diff_content=$(git diff "$merge_base"..HEAD)
```

Announce `Reviewing <current> against <base> (N files)` before spawning. If `changed_files` is empty, stop and ask — do not run reviewers on an empty diff.

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

TaskCreate({
  subject: "Review: anti-slop",
  description: "Check changed TS/JS for low-evidence type patterns (advisory only)"
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

// Only spawn when the diff touches .ts/.tsx/.js/.jsx/.mts/.cts/.mjs/.cjs
Task({
  team_name: current_team,
  name: "anti-slop-reviewer",
  subagent_type: "context-engineering:anti-slop-reviewer",
  description: "Anti-slop review",
  prompt: `Review changed TS/JS for low-evidence type patterns:

Changed files: ${changed_files}

Run oxlint if the repo has anti-slop installed; otherwise judge the diff heuristically against the anti-slop rules.

Findings are ADVISORY — they never block the ship gate. Never propose disabling a rule, downgrading severity, or casting to make lint pass.
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

### Anti-Slop (advisory)
[Mode: LINT/HEURISTIC/SKIPPED — findings or "Clean"]

---

## Recommended Actions

### Must Fix (blocking)
1. [Critical issue]

### Should Fix (recommended)
1. [Important improvement]

### Consider (optional)
1. [Nice to have]

### Anti-Slop (advisory — never blocking)
1. [file:line — rule — fix]
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
SendMessage({ type: "shutdown_request", recipient: "anti-slop-reviewer" })
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
