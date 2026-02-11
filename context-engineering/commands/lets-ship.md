---
name: lets-ship
description: Full engineering workflow with native Teams traceability — understand, plan, work, review, compound
argument-hint: "[feature description] [--auto]"
---

# lets-ship — Ship Features with Full Traceability

End-to-end workflow: understand > plan > work > review > compound.

Every phase creates tasks and spawns team members. After completion, the team persists as a queryable trace of **what** was built, **why**, and **how**.

## Input

<feature_description>$ARGUMENTS</feature_description>

**Parse flags:**
- `--auto` → autonomous mode (skip all human gates, max 2 fix iterations)
- Everything else → feature description

**If empty:** Ask "What are we shipping? Describe the feature, fix, or improvement."

---

## Phase 0: Bootstrap

### Cold Start (no context/ directory)

If `context/` does not exist:

1. **Create structure:**
   ```bash
   mkdir -p context/foundation context/specs context/tasks
   mkdir -p docs/solutions
   ```

2. **Interactive Q&A** (skipped with `--auto` if description is sufficient):
   - "What's the tech stack?" (languages, frameworks, DB)
   - "What's the architecture?" (monolith, microservices, monorepo)
   - "Any critical conventions?" (naming, patterns, testing approach)

3. **Generate foundation:**
   ```
   Write answers to:
   - context/foundation/architecture.md
   - context/foundation/conventions.md
   ```

4. Announce: "Context bootstrapped. Proceeding with feature."

### Resume Logic

When `lets-ship` runs with existing `context/`:

1. Check for active team: `ls ~/.claude/teams/ship-*` matching current project
2. If team found → read task list → identify last completed phase → resume from next
3. If no team → check for in-progress spec (status: in-progress or git branch hint)
4. If spec found → create new team, infer progress from spec checkboxes
5. If nothing → start fresh from Phase 1

---

## Team Setup

```javascript
// Derive slug from feature description
slug = feature_description.toLowerCase().replace(/[^a-z0-9]+/g, '-').slice(0, 30)
date = new Date().toISOString().slice(0, 10).replace(/-/g, '')

TeamCreate({
  team_name: `ship-${slug}-${date}`,
  description: feature_description
})
```

Create phase tasks with dependencies:

```javascript
TaskCreate({ subject: "Phase 1: Understand", description: "Load foundation, research codebase and learnings" })
TaskCreate({ subject: "Phase 2: Plan", description: "Create spec with acceptance criteria" })
TaskCreate({ subject: "Phase 3: Work", description: "Execute spec task-by-task" })
TaskCreate({ subject: "Phase 4: Review", description: "Multi-agent code review" })
TaskCreate({ subject: "Phase 5: Compound", description: "Capture learnings, rate spec, create PR" })

// Set dependencies: each phase blocked by the previous
TaskUpdate({ taskId: "2", addBlockedBy: ["1"] })
TaskUpdate({ taskId: "3", addBlockedBy: ["2"] })
TaskUpdate({ taskId: "4", addBlockedBy: ["3"] })
TaskUpdate({ taskId: "5", addBlockedBy: ["4"] })
```

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

### 1.2 Spawn Research Team Members

```javascript
TaskCreate({
  subject: "Research: codebase patterns",
  description: "Find existing code patterns relevant to: <feature_description>"
})

TaskCreate({
  subject: "Research: past learnings",
  description: "Search docs/solutions/ and context/foundation/ for relevant learnings"
})

// Spawn as team members (traced)
Task({
  team_name: current_team,
  name: "repo-researcher",
  subagent_type: "context-engineering:repo-researcher",
  description: "Research codebase patterns",
  prompt: "Find existing code patterns relevant to: <feature_description>. Update your task with ## Findings when done. SendMessage to lead with summary."
})

Task({
  team_name: current_team,
  name: "learnings-researcher",
  subagent_type: "context-engineering:learnings-researcher",
  description: "Research past learnings",
  prompt: "Search docs/solutions/ and context/foundation/ for relevant learnings. Update your task with ## Findings when done. SendMessage to lead with summary."
})
```

### 1.3 Gate: Confirm Understanding

**Wait for researchers to report back.** Then present findings.

Ask (skipped with `--auto`):
- "Here's what I found. Does this align?"
- "Any additional context?"
- "Ready to plan?"

Mark Phase 1 task complete. Unblocks Phase 2.

---

## Phase 2: Plan

**Goal:** Create actionable spec with acceptance criteria.

### 2.1 Create Spec

Write spec to `context/specs/YYYY-MM-DD-<type>-<name>.md`:

```markdown
---
title: [Feature Title]
type: [feat|fix|improve]
status: in-progress
created: YYYY-MM-DD
---

# [Feature Title]

## Problem
[From feature description + research findings]

## Solution
[High-level approach based on codebase patterns found]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Tests pass

## Technical Approach
[Based on patterns found in research]

## References
[Links to relevant files from research]
```

### 2.2 Root Cause Validation

Before presenting the plan, think step by step:

1. **What is the fundamental problem?** Not the symptom — the root cause.
2. **Does this spec address the root cause?** Or is the proposed solution a bandaid?
3. **Apply CLEAN framework:** Is the approach Clear, Logical, Efficient, Appropriate, Necessary?
4. **Would this fix survive codebase evolution?** Or is it fragile patchwork?

If the spec targets symptoms rather than root cause, revise it before presenting.

### 2.3 Gate: Plan Approval

Present spec and offer options (with `--auto`: auto-approve):

1. **Approve** — proceed to work
2. **Deepen** — run `/deepen` for more research
3. **Refine** — ask clarifying questions
4. **Simplify** — spawn simplicity-reviewer to reduce scope

Mark Phase 2 task complete. Unblocks Phase 3.

---

## Phase 3: Work

**Goal:** Execute the plan systematically.

### 3.1 Branch Setup

```bash
current=$(git branch --show-current)
default=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

if [ "$current" = "$default" ]; then
  git checkout -b feat/<feature-slug>
fi
```

### 3.2 Create Implementation Tasks

One task per acceptance criterion:

```javascript
// For each acceptance criterion in spec:
TaskCreate({
  subject: "Implement: <criterion>",
  description: "From spec: <criterion details>. Update task with ## Changes when done.",
  activeForm: "Implementing <criterion>"
})
```

### 3.3 Execute Loop

```
for each implementation task:
  1. TaskUpdate({ taskId, status: "in_progress" })
  2. Read referenced files from spec
  3. Find similar patterns in codebase
  4. Implement following conventions
  5. Run tests
  6. TaskUpdate({ taskId, status: "completed", description: append "## Changes\n- ..." })
  7. Update spec checkbox: [ ] → [x]
  8. Commit if logical unit complete:
     git add <files>
     git commit -m "<type>(<scope>): <description>"
```

### 3.4 Gate: Work Complete

"All tasks complete. Tests passing. Ready for review?" (with `--auto`: auto-proceed)

Mark Phase 3 task complete. Unblocks Phase 4.

---

## Phase 4: Review

**Goal:** Multi-perspective code review before shipping.

### 4.1 Gather Changes

```bash
changed_files=$(git diff --name-only main...HEAD)
diff_content=$(git diff main...HEAD)
```

### 4.2 Spawn Reviewer Team Members

```javascript
TaskCreate({
  subject: "Review: simplicity",
  description: "Check for over-engineering, unnecessary complexity"
})

TaskCreate({
  subject: "Review: spec compliance",
  description: "Verify all acceptance criteria met, no scope creep"
})

TaskCreate({
  subject: "Review: bug hunting",
  description: "Hunt for edge cases, error handling gaps, security issues"
})

// Spawn as team members (traced)
Task({
  team_name: current_team,
  name: "simplicity-reviewer",
  subagent_type: "context-engineering:simplicity-reviewer",
  description: "Simplicity review",
  prompt: "Review changes for unnecessary complexity. Update your task with findings. SendMessage to lead."
})

Task({
  team_name: current_team,
  name: "spec-reviewer",
  subagent_type: "context-engineering:spec-reviewer",
  description: "Spec compliance review",
  prompt: "Compare implementation against spec. Update your task with findings. SendMessage to lead."
})

Task({
  team_name: current_team,
  name: "bug-hunter",
  subagent_type: "context-engineering:bug-hunter",
  description: "Bug hunting review",
  prompt: "Hunt for bugs, edge cases, security issues. Update your task with findings. SendMessage to lead."
})
```

### 4.3 Consolidate & Present

Wait for all reviewers. Present consolidated feedback:

```markdown
## Review Summary

### Must Fix (blocking)
1. [Critical issue]

### Should Fix (recommended)
1. [Important improvement]

### Consider (optional)
1. [Nice to have]
```

### 4.4 Gate: Review Decision

Options (with `--auto`: auto-fix Must Fix items, max 2 iterations):

1. **Fix issues** — address feedback, re-run review
2. **Ship as-is** — proceed to compound
3. **Discuss** — clarify specific feedback

**--auto safety valve:** If "Must Fix" issues persist after 2 fix iterations, stop and ask user.

Mark Phase 4 task complete. Unblocks Phase 5.

---

## Phase 5: Compound

**Goal:** Capture learnings and ship.

### 5.1 Extract Learnings

Ask (with `--auto`: auto-extract from code changes):
- "What patterns did we discover?"
- "What gotchas should we document?"
- "Any conventions worth adding to foundation?"

Write to `docs/solutions/YYYY-MM-DD-<topic>.md`.

### 5.2 Rate Spec

Rate the spec quality (absorbs context-feedback):

```
Rating guide:
- 5: perfect, no issues during implementation
- 4: good, minor friction
- 3: acceptable, notable issues
- 2: poor, needs improvement
- 1: failed, major rework needed
```

With `--auto`: heuristic rating based on:
- Number of fix iterations needed
- Review severity of findings
- Spec checkbox completion rate

Update spec's `## Feedback` section:
```markdown
## Feedback
Rating: X/5
Issue: [what could be better — blank if rating > 3]
```

When rating <= 3 with an issue, auto-create improvement spec.

### 5.3 Gate: Ship

Options (with `--auto`: auto-create PR):

1. **Create PR** — `gh pr create`
2. **Continue** — start another feature
3. **Done** — end session

### 5.4 Shutdown

```javascript
// Shutdown all team members (team + tasks persist as trace)
SendMessage({ type: "shutdown_request", recipient: "repo-researcher" })
SendMessage({ type: "shutdown_request", recipient: "learnings-researcher" })
SendMessage({ type: "shutdown_request", recipient: "simplicity-reviewer" })
SendMessage({ type: "shutdown_request", recipient: "spec-reviewer" })
SendMessage({ type: "shutdown_request", recipient: "bug-hunter" })
// Only shutdown active members — skip already-exited ones
```

Mark Phase 5 task complete.

"Feature shipped. Team trace preserved at `~/.claude/tasks/ship-<slug>-<date>/`"

---

## Quick Reference

| Phase | Team Members | Gate |
|-------|-------------|------|
| Understand | repo-researcher, learnings-researcher | Confirm context |
| Plan | (optional) options-researcher | Approve plan |
| Work | — | Ready for review |
| Review | simplicity-reviewer, spec-reviewer, bug-hunter | Fix / ship |
| Compound | — | Create PR / done |

## Flags

| Flag | Effect |
|------|--------|
| `--auto` | Skip all human gates, auto-fix (max 2 iterations), auto-create PR |

---

*Every agent update is a task. Every task persists. The team is the trace.*
