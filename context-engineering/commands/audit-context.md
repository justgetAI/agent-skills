---
name: audit-context
description: Audit codebase documentation using hierarchical swarm — discover features, extract context, generate specs
argument-hint: "[path to codebase, defaults to current directory]"
---

# Audit Context — Hierarchical Swarm Documentation

Audit and generate documentation for a codebase using a hierarchical agent swarm.

**Architecture:**
```
┌─────────────────────────────────────────────────────────────┐
│  HAIKU SCOUT — Discovery                                    │
│  Fast, cheap exploration of codebase structure              │
└─────────────────────┬───────────────────────────────────────┘
                      │ identifies feature domains
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  OPUS MANAGERS — One per feature domain                     │
│  auth-manager, payments-manager, notifications-manager...   │
│  Oversee extraction, review worker output, consolidate      │
└─────────────────────┬───────────────────────────────────────┘
                      │ spawn workers
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  SONNET WORKERS — Bulk extraction                           │
│  Analyze files, summarize, draft specs                      │
│  Report back to their manager                               │
└─────────────────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  HUMAN GATE — Review CLAUDE.md / foundation changes         │
│  Specs auto-generated, foundation requires approval         │
└─────────────────────────────────────────────────────────────┘
```

---

## Input

<codebase_path>$ARGUMENTS</codebase_path>

**Default:** Current directory

---

## Phase 1: Discovery (Haiku Scout)

Spawn a single Haiku agent to explore:

```javascript
Task({
  subagent_type: "Explore",
  description: "Codebase discovery",
  prompt: `Explore the codebase at <codebase_path>:

1. List top-level directories with file counts
2. Find all documentation files (README.md, CLAUDE.md, docs/*.md)
3. Read package.json/Cargo.toml/pyproject.toml for dependencies
4. Identify feature domains from:
   - Folder names (app/payments, services/auth, etc.)
   - Route files
   - README sections
   
Output as JSON:
{
  "structure": { "dir": "file_count" },
  "docs": ["path/to/doc.md"],
  "dependencies": ["dep1", "dep2"],
  "domains": [
    { "name": "auth", "path": "app/auth", "indicators": ["login", "jwt"] },
    { "name": "payments", "path": "app/payments", "indicators": ["stripe", "checkout"] }
  ]
}

Be thorough but fast. Focus on structure, not content.`,
  model: "haiku"
})
```

**Output:** `discovery.json` with identified domains

---

## Phase 2: Spawn Managers (Opus)

For each discovered domain, spawn an Opus manager:

```javascript
// Create team for this audit
Teammate({ operation: "spawnTeam", team_name: "doc-audit-<timestamp>" })

// Spawn a manager per domain
for (const domain of discovery.domains) {
  Task({
    team_name: "doc-audit-<timestamp>",
    name: `${domain.name}-manager`,
    subagent_type: "general-purpose",
    prompt: `You are the MANAGER for the "${domain.name}" feature domain.

Your job:
1. Spawn Sonnet WORKERS to analyze files in ${domain.path}
2. Review their output for accuracy and completeness
3. Consolidate into a single spec document
4. Report back when complete

Files to analyze: ${domain.path}
Indicators found: ${domain.indicators.join(", ")}

Spawn workers like this:
Task({
  subagent_type: "Explore",
  description: "Analyze ${filename}",
  prompt: "Analyze this file and extract: purpose, key functions, dependencies, how it connects to other parts",
  model: "sonnet"
})

When workers complete, consolidate their findings into:
context/specs/${domain.name}.md

Use this format:
---
title: ${domain.name}
type: feature
status: draft
generated: <date>
---

# ${domain.name}

## Overview
[What this feature does]

## Key Components
[Files and their purposes]

## Dependencies
[External services, packages]

## How It Works
[Flow description]

## Connections
[How it relates to other features]

Send your final spec to team-lead when done.`,
    model: "opus",
    run_in_background: true
  })
}
```

---

## Phase 3: Workers Execute (Sonnet)

Each manager spawns Sonnet workers as needed:

```javascript
// Manager spawns workers for each key file
Task({
  subagent_type: "Explore",
  description: `Analyze ${filepath}`,
  prompt: `Analyze this file and extract:
  
1. **Purpose:** What does this file do?
2. **Key Functions/Classes:** List main exports with one-line descriptions
3. **Dependencies:** What does it import/require?
4. **Connections:** How does it connect to other parts of the codebase?
5. **Notable Patterns:** Any interesting patterns or conventions?

Be concise. Max 200 words total.

File: ${filepath}`,
  model: "sonnet"
})
```

Workers report back to their manager. Manager consolidates.

---

## Phase 4: Consolidation

As managers complete, they send specs to team-lead.

Collect all specs and generate:

1. **Feature specs** → `context/specs/<domain>.md` (auto-generated)
2. **CLAUDE.md diff** → Show what's missing/outdated (HUMAN REVIEW REQUIRED)
3. **Foundation suggestions** → Proposed updates (HUMAN REVIEW REQUIRED)

---

## Phase 5: Human Gate

Present to user:

```markdown
## Doc Audit Complete

### Auto-Generated (no approval needed)
- context/specs/auth.md ✅
- context/specs/payments.md ✅
- context/specs/notifications.md ✅

### Requires Your Approval
#### CLAUDE.md Changes
[Show diff of proposed changes]

#### Foundation Updates  
[Show proposed foundation/ files]

**Options:**
1. Approve all
2. Review individually
3. Reject and regenerate
```

**NEVER update CLAUDE.md without explicit human approval.**

---

## Usage Examples

```bash
# Audit current directory
/doc-audit

# Audit specific codebase
/doc-audit ~/projects/my-app

# Audit with specific focus
/doc-audit ~/projects/my-app --focus auth,payments
```

---

## Cost Estimate

| Phase | Model | Calls | Est. Cost |
|-------|-------|-------|-----------|
| Discovery | Haiku | 1 | ~$0.01 |
| Managers | Opus | N domains | ~$0.50/domain |
| Workers | Sonnet | ~5/domain | ~$0.10/domain |

For a 5-domain codebase: ~$3-5 total

---

## Tools Integration

**mcp-graph** (if available):
```javascript
// Use for understanding code relationships
mcp_graph.analyze(codebase_path, { depth: 2 })
```

**TodoWrite** (for tracking):
```javascript
TodoWrite({
  todos: domains.map(d => ({
    id: d.name,
    content: `Extract ${d.name} feature docs`,
    status: "pending"
  }))
})
```

---

## Output Structure

```
context/
├── specs/
│   ├── auth.md           # Generated
│   ├── payments.md       # Generated
│   └── notifications.md  # Generated
└── foundation/
    └── [proposed changes] # Requires approval

CLAUDE.md.proposed         # Diff for review
```

---

*Human stays in control of CLAUDE.md. Specs are auto-generated. Managers ensure quality.*
