---
name: let-it-rip
description: Full autonomous engineering workflow — plan, work, review, compound
argument-hint: "[feature description or problem to solve]"
---

# Let It Rip — Autonomous Engineering Workflow

End-to-end workflow: understand → plan → work → review → compound.

Human stays in the loop at gates. Agents handle research and execution.

## Feature Description

<feature_description>$ARGUMENTS</feature_description>

**If empty:** Ask "What are we building? Describe the feature, fix, or improvement."

---

## Phase 1: Understand

**Goal:** Gather context before planning.

### 1.1 Load Foundation

```
Read context/foundation/*.md to understand:
- Project architecture
- Key conventions
- Existing patterns
```

### 1.2 Parallel Research

Spawn these agents in parallel:

```javascript
Task({
  subagent_type: "Explore",
  description: "Repo research",
  prompt: "Find existing code patterns relevant to: <feature_description>. Look for similar implementations, conventions, related files.",
  model: "haiku"
})

Task({
  subagent_type: "Explore", 
  description: "Learnings research",
  prompt: "Search context/foundation/ and docs/solutions/ for any documented learnings, gotchas, or patterns relevant to: <feature_description>",
  model: "haiku"
})
```

### 1.3 Gate: Confirm Understanding

Present findings and ask:
- "Here's what I found. Does this align with your expectations?"
- "Any additional context I should know?"
- "Ready to proceed with planning?"

Wait for user confirmation before continuing.

---

## Phase 2: Plan

**Goal:** Create actionable spec with acceptance criteria.

### 2.1 Create Spec

Write spec to `context/specs/YYYY-MM-DD-<name>.md`:

```markdown
---
title: [Feature Title]
status: draft
created: YYYY-MM-DD
---

# [Feature Title]

## Problem
[What problem are we solving?]

## Solution
[High-level approach]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Approach
[Key implementation details]

## References
- [Related file](path/to/file.ts)
- [Similar pattern](path/to/example.ts)
```

### 2.2 Gate: Plan Approval

Present the plan and offer options:

1. **Approve** — proceed to work
2. **Deepen** — run `/deepen-plan` for more research
3. **Refine** — ask clarifying questions
4. **Simplify** — reduce scope

If user selects "Deepen":

```javascript
// Spawn parallel research agents
Task({
  subagent_type: "Plan",
  description: "Best practices research",
  prompt: "Research best practices for: <feature_description>. Focus on edge cases, security, performance.",
})

Task({
  subagent_type: "Plan",
  description: "Options analysis", 
  prompt: "What are alternative approaches to: <feature_description>? Pros/cons of each.",
})
```

Update spec with findings, then return to gate.

---

## Phase 3: Work

**Goal:** Execute the plan systematically.

### 3.1 Setup

```bash
# Check current branch
current_branch=$(git branch --show-current)
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

# If on default branch, create feature branch
if [ "$current_branch" = "$default_branch" ]; then
  git checkout -b feat/<feature-name>
fi
```

### 3.2 Create Tasks

Break spec into tasks using TodoWrite:

```javascript
TodoWrite({
  todos: [
    { id: "1", content: "Task 1 from acceptance criteria", status: "pending" },
    { id: "2", content: "Task 2 from acceptance criteria", status: "pending" },
    { id: "3", content: "Write tests", status: "pending" },
  ]
})
```

### 3.3 Execute Loop

```
for each task:
  1. Mark in_progress via TodoWrite
  2. Implement following existing patterns
  3. Run tests
  4. Mark completed via TodoWrite
  5. Update checkbox in spec file ([ ] → [x])
  6. Commit if logical unit complete:
     git add <relevant files>
     git commit -m "feat(<scope>): <description>"
```

### 3.4 Gate: Work Complete

"Implementation complete. All tests passing. Ready for review?"

---

## Phase 4: Review

**Goal:** Multi-perspective code review before shipping.

### 4.1 Spawn Reviewers

```javascript
Task({
  subagent_type: "Plan",
  name: "simplicity-reviewer",
  description: "Simplicity review",
  prompt: "Review the changes for: <feature_description>. Focus on: unnecessary complexity, over-engineering, simpler alternatives. Be direct.",
})

Task({
  subagent_type: "Plan", 
  name: "spec-reviewer",
  description: "Spec compliance review",
  prompt: "Compare implementation against spec. Check: all acceptance criteria met, no scope creep, matches technical approach.",
})
```

### 4.2 Consolidate Feedback

Collect findings from reviewers. Present as:

```markdown
## Review Summary

### Simplicity Reviewer
- [Issue 1]
- [Issue 2]

### Spec Reviewer  
- [Issue 1]
- [Issue 2]

### Recommended Actions
1. [Action 1]
2. [Action 2]
```

### 4.3 Gate: Review Decision

Options:
1. **Fix issues** — address feedback, return to work phase
2. **Ship as-is** — proceed to compound
3. **Discuss** — clarify specific feedback

---

## Phase 5: Compound

**Goal:** Capture learnings so future work is easier.

### 5.1 Extract Learnings

Ask:
- "What patterns did we discover?"
- "What gotchas should we document?"
- "Any conventions worth adding to foundation?"

### 5.2 Document

Write learnings to `docs/solutions/YYYY-MM-DD-<topic>.md` or update `context/foundation/` if it's a project convention.

### 5.3 Final Gate

"Learnings captured. Feature complete! 🚀"

Options:
1. **Create PR** — `gh pr create`
2. **Continue** — start another feature
3. **Done** — end session

---

## Quick Reference

| Phase | Auto-Agents | Gate |
|-------|-------------|------|
| Understand | repo-researcher, learnings-researcher | Confirm context |
| Plan | (optional) best-practices, options | Approve plan |
| Work | — | Ready for review |
| Review | simplicity-reviewer, spec-reviewer | Fix / ship |
| Compound | — | Done |

---

*Based on compound-engineering patterns, adapted for context-engineering workflow.*
