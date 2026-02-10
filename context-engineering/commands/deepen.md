---
name: deepen
description: Enhance a spec with parallel research agents for each section
argument-hint: "[path to spec file]"
---

# deepen — Enhance Spec with Research

Enhance an existing spec with parallel research. Each section gets its own research sub-agent.

## Usage

```
/deepen-plan context/specs/feat001-payments.md
```

## How It Works

```
┌─────────────────────────────────────────────────────────┐
│                    Input Spec                           │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│              Parse into sections                        │
│  • Architecture  • Implementation  • Security  • UI     │
└─────────────────────────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         ▼               ▼               ▼
    ┌─────────┐    ┌─────────┐    ┌─────────┐
    │Research │    │Research │    │Research │  ← PARALLEL
    │Agent 1  │    │Agent 2  │    │Agent 3  │
    └────┬────┘    └────┬────┘    └────┬────┘
         │               │               │
         └───────────────┼───────────────┘
                         ▼
┌─────────────────────────────────────────────────────────┐
│              Merge Enhanced Sections                    │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                 Deepened Spec                           │
│  + Best practices    + Edge cases    + Examples         │
└─────────────────────────────────────────────────────────┘
```

## Process

### 1. Parse Spec Structure

Read the spec and identify sections:
- [ ] Goal / Problem Statement
- [ ] Requirements
- [ ] Technical Approach
- [ ] Tasks
- [ ] Security considerations
- [ ] Performance considerations
- [ ] UI/UX (if applicable)

### 2. Spawn Parallel Research Agents

For each section, spawn a sub-agent:

```
Task: "Research best practices for [section topic].

Context from spec:
[section content]

Find:
1. Industry best practices (2024-2026)
2. Common pitfalls to avoid
3. Performance optimizations
4. Security considerations
5. Real-world examples

Return concise, actionable enhancements."
```

**Spawn ALL agents in parallel** — don't wait for one to finish before starting another.

### 3. Merge Results

For each section, append:

```markdown
### Enhanced: [Section Name]

**Best Practices:**
- [Practice 1]
- [Practice 2]

**Pitfalls to Avoid:**
- [Pitfall 1]

**Examples:**
- [Company/Project] does [approach]
```

### 4. Update Spec

Add a `## Deep Research` section with:
- Research timestamp
- Sources consulted
- Confidence level per section

## Example

**Before:**
```markdown
## Technical Approach
Use Stripe for payments.
```

**After:**
```markdown
## Technical Approach
Use Stripe for payments.

### Enhanced: Technical Approach

**Best Practices:**
- Use Payment Intents API (not Charges)
- Implement idempotency keys for all requests
- Use webhooks for async state updates
- Store Stripe IDs, not card details

**Pitfalls to Avoid:**
- Don't poll for status — use webhooks
- Don't store raw API responses (PII)
- Don't retry without idempotency keys

**Examples:**
- Shopify: Payment Intents + webhook-driven state machine
- Linear: Stripe Billing with usage-based metering

**Sources:**
- Stripe docs (2026)
- "Scaling Payments at Shopify" (2025 blog post)
```

## Team Integration

When called from `lets-ship`, research agents are spawned as **team members** (traced) rather than subagents:

```javascript
// Each research agent gets a task and reports findings
TaskCreate({ subject: "Deepen: <section>", description: "Research best practices for <section>" })

Task({
  team_name: current_team,
  name: "options-researcher",
  subagent_type: "context-engineering:options-researcher",
  prompt: "Research best practices for <section>. Update your task with ## Findings. SendMessage to lead."
})
```

Findings persist in team task history for future reference.

---

## When to Use

| Scenario | Use Deepen? |
|----------|------------|
| Quick internal feature | No — overkill |
| Complex new system | Yes |
| Unfamiliar domain | Yes |
| High-risk/security feature | Yes |
| Spec rated ≤3 in review | Yes — before retry |
