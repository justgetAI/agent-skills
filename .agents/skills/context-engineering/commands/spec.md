---
name: spec
description: Create a new spec with automatic research and planning
argument-hint: "[type] [name] or just describe what you want to build"
---

# spec — Create New Spec

Intelligent spec creation with automatic research.

## Input

<input>$ARGUMENTS</input>

**Parse input:**
- `"feat payments"` → type=feat, topic=payments
- `"fix login bug"` → type=fix, topic=login bug  
- `"add stripe integration"` → type=feat, topic=stripe integration (inferred)

**If unclear:** Ask "What are we building? (feature/fix/improvement)"

---

## Phase 1: Quick Research (Parallel)

Before writing anything, gather context:

```javascript
// Spawn in parallel
Task({
  subagent_type: "Explore",
  description: "Find related code",
  prompt: "Search codebase for existing code related to: <topic>. Find: similar implementations, relevant files, patterns to follow.",
  model: "haiku"
})

Task({
  subagent_type: "Explore",
  description: "Check foundation",
  prompt: "Read context/foundation/*.md. Find any relevant: conventions, constraints, prior decisions for: <topic>",
  model: "haiku"
})
```

**Wait for research to complete** (usually <30s with haiku).

---

## Phase 2: Draft Spec

Create `context/specs/YYYY-MM-DD-<type>-<name>.md`:

```markdown
---
title: [Title based on topic]
type: [feat|fix|improve]
status: draft
created: YYYY-MM-DD
---

# [Title]

## Problem
[Infer from topic + research findings]

## Solution  
[High-level approach based on codebase patterns found]

## Acceptance Criteria
- [ ] [Criterion based on topic]
- [ ] [Criterion based on topic]
- [ ] Tests pass

## Technical Approach
[Based on patterns found in research]

## References
[Links to relevant files from research]

## Open Questions
- [Any ambiguities to resolve]
```

---

## Phase 3: Present Options

After creating spec, ask:

**"Spec created at `context/specs/<filename>`. What next?"**

1. **Refine** — I'll ask clarifying questions to improve it
2. **Deepen** — Run parallel research on best practices, edge cases
3. **Start work** — Begin implementation with `/work`
4. **Full workflow** — Run complete `/lets-ship` from here
5. **Edit manually** — Open in editor, I'll wait

---

## Quick Create (Skip Research)

If user says "quick" or "just create":

```bash
# Use ctx CLI for fast creation
${CLAUDE_PLUGIN_ROOT}/scripts/ctx new spec <type> <name>
```

Skip research, create minimal template, let user fill in.

---

## Spec Types

| Type | Use For | Example |
|------|---------|---------|
| `feat` | New features | `feat add-payments` |
| `fix` | Bug fixes | `fix login-timeout` |
| `improve` | Enhancements | `improve search-perf` |
| `refactor` | Code quality | `refactor auth-module` |
