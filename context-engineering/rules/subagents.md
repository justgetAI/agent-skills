# Sub-Agent Patterns

Maximize parallelization. Don't wait when you can spawn.

## Core Principle

```
Sequential (slow):          Parallel (fast):
                           
Task A ──► Task B ──► C    Task A ──┐
     10s      10s     10s  Task B ──┼──► Merge
           Total: 30s      Task C ──┘
                              Total: 10s + merge
```

## When to Spawn Sub-Agents

| Scenario | Action |
|----------|--------|
| Independent research tasks | Spawn parallel |
| Multiple reviewers | Spawn parallel |
| Section-by-section analysis | Spawn parallel |
| Sequential dependencies | Run sequentially |
| Needs previous output | Run sequentially |

## Spawn Patterns

### Pattern 1: Parallel Research

```
Spawn sub-agent 1: "Research [topic A]. Return summary."
Spawn sub-agent 2: "Research [topic B]. Return summary."
Spawn sub-agent 3: "Research [topic C]. Return summary."

[All spawn immediately, don't wait]

Wait for all.
Merge results.
```

### Pattern 2: Parallel Review

```
Spawn sub-agent: "Run spec-reviewer on [file]"
Spawn sub-agent: "Run simplicity-reviewer on [file]"

Wait for all.
Both must pass.
```

### Pattern 3: Parallel Deep-Dive (per section)

```
For each section in spec:
  Spawn sub-agent: "Deep research on [section topic]"

Wait for all.
Merge into enhanced spec.
```

### Pattern 4: Parallel Options

```
Spawn sub-agent: "Research enterprise approaches to [problem]"
Spawn sub-agent: "Research OSS approaches to [problem]"

Wait for all.
Synthesize into options matrix.
```

## Sub-Agent Prompt Template

```
You are a focused research sub-agent.

TASK: [specific task]

CONTEXT:
[relevant context from parent]

OUTPUT FORMAT:
[expected format]

Be concise. Return only findings, no preamble.
```

## Where We Use Sub-Agents

| Phase | Sub-Agents | Parallel? |
|-------|------------|-----------|
| Research | repo-researcher, learnings-researcher | ✅ Yes |
| Options | enterprise-researcher, oss-researcher | ✅ Yes |
| Review | spec-reviewer, simplicity-reviewer | ✅ Yes |
| Deepen | one per spec section | ✅ Yes |
| Context Load | context-loader | No (single) |

## Anti-Patterns

❌ **Don't spawn for trivial tasks**
```
Bad: Spawn sub-agent to read one file
Good: Just read the file
```

❌ **Don't spawn with dependencies**
```
Bad: Spawn A, Spawn B (needs A's output)
Good: Run A, then spawn B with A's output
```

❌ **Don't over-parallelize**
```
Bad: 20 sub-agents for tiny tasks
Good: 2-5 sub-agents for meaningful work
```

## Token Efficiency

Sub-agents save tokens by:
1. Returning summaries, not raw data
2. Focused context (only what they need)
3. Parallel = fewer round-trips
4. Specialized = less confusion

```
Main agent context: 50k tokens
Sub-agent context:  10k tokens each
                    ─────────────
                    Faster, cheaper
```
