# Agent Patterns

Two modes: **subagents** (fast, disposable) and **team members** (traced, persistent).

## Decision Matrix

| Output matters later? | Use | Why |
|----------------------|-----|-----|
| No — quick file read, one-off search | **Subagent** | Fast, cheap, no overhead |
| Yes — research, review, implementation | **Team member** | Findings persist in task history |

**Rule of thumb:** If you'd want to reference the output in a future session, use a team member.

---

## Subagents (No Trace)

Fast, disposable work. Output returned to caller, then gone.

### When to Use

- Quick file reads or searches
- One-off analysis
- Anything where the *result* matters but the *process* doesn't

### Pattern

```javascript
Task({
  subagent_type: "Explore",
  description: "Quick search",
  prompt: "Find files matching X. Return paths only.",
  model: "haiku"
})
```

### Parallelization

```
Sequential (slow):          Parallel (fast):

Task A -> Task B -> C       Task A -+
     10s      10s    10s    Task B -+-> Merge
           Total: 30s       Task C -+
                              Total: 10s + merge
```

Spawn ALL independent subagents in parallel. Don't wait for one before starting another.

---

## Team Members (Traced)

Persistent, traceable work. Findings stored in team task history.

### When to Use

- Research that informs decisions (repo-researcher, learnings-researcher)
- Reviews that produce actionable findings (simplicity-reviewer, spec-reviewer, bug-hunter)
- Implementation tasks during `/work`
- Any output you'd want to query later via `/status --teams`

### Pattern

```javascript
// 1. Create a task for the work
TaskCreate({
  subject: "Research: codebase patterns",
  description: "Find patterns relevant to: <feature>"
})

// 2. Spawn agent as team member
Task({
  team_name: current_team,
  name: "repo-researcher",
  subagent_type: "context-engineering:repo-researcher",
  description: "Research codebase patterns",
  prompt: "... Update your task with ## Findings. SendMessage to lead."
})

// 3. Agent updates task + messages lead when done
// 4. Task persists in ~/.claude/tasks/<team-name>/ as trace
```

### Team Member Protocol

Every team member agent MUST:

1. **Read** their assigned task for context
2. **Do** the work
3. **Update** their task with findings:
   ```javascript
   TaskUpdate({
     taskId: assigned_task_id,
     description: append "## Findings\n[output]"
   })
   ```
4. **Message** the lead with a summary:
   ```javascript
   SendMessage({
     type: "message",
     recipient: "team-lead",
     content: "[concise summary]",
     summary: "[5-word summary]"
   })
   ```

---

## Agent Roster

| Agent | Role | Mode |
|-------|------|------|
| repo-researcher | Find codebase patterns | Team member |
| learnings-researcher | Surface past learnings | Team member |
| options-researcher | Research approaches, present options | Team member |
| simplicity-reviewer | Challenge complexity | Team member |
| spec-reviewer | Check spec compliance | Team member |
| bug-hunter | Hunt for bugs and security issues | Team member |
| context-worker | Execute implementation tasks | Team member |

---

## Anti-Patterns

**Don't spawn for trivial tasks:**
```
Bad:  Spawn team member to read one file
Good: Just read the file
```

**Don't spawn with dependencies:**
```
Bad:  Spawn A and B (B needs A's output)
Good: Run A, then spawn B with A's output
```

**Don't over-parallelize:**
```
Bad:  20 agents for tiny tasks
Good: 2-5 agents for meaningful work
```

**Don't use team members for disposable work:**
```
Bad:  Team member to check if a file exists
Good: Subagent (or just do it directly)
```

---

## Token Efficiency

Both modes save tokens by:
1. Returning summaries, not raw data
2. Focused context (only what they need)
3. Parallel = fewer round-trips
4. Specialized = less confusion

Team members add overhead (task creation, messaging) but that overhead *is the trace*.
