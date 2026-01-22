---
name: linear-sync
description: Bidirectional sync between local spec/task files and Linear issues. Uses linearis CLI.
compatibility: Claude Code, Cursor, OpenCode, or any agent with shell access
requires:
  - linearis (npm install -g linearis)
  - LINEAR_API_TOKEN env var
---

# Linear Sync

Bidirectional sync between filesystem-based specs/tasks and Linear issues.

## Overview

```
┌─────────────────┐         ┌─────────────────┐
│   Local Specs   │ ◄─────► │  Linear Issues  │
│   & Tasks       │  sync   │                 │
└─────────────────┘         └─────────────────┘
```

**Source of truth:** Whichever was modified last (timestamp-based conflict resolution).

---

## Setup

### 1. Install linearis
```bash
npm install -g linearis
```

### 2. Set API token
```bash
export LINEAR_API_TOKEN="lin_api_..."
```

### 3. Configure team mapping
Create `.linear-sync.json` in your project root:
```json
{
  "team": "GET",
  "specDir": "context/specs",
  "taskDir": "context/tasks",
  "labelPrefix": "spec:",
  "syncTasks": true
}
```

---

## Spec Frontmatter

Add Linear metadata to specs:

```markdown
---
type: feat
number: 001
title: User Authentication
linear:
  issue: GET-42
  team: GetAI
  state: In Progress
  synced_at: 2026-01-22T02:00:00Z
---

# feat001 - User Authentication

## Goal
...
```

---

## Commands

### Push local → Linear
```bash
./scripts/linear-sync.sh push [spec-file]
```
- Creates issue if `linear.issue` is empty
- Updates issue if it exists
- Sets `linear.issue` and `linear.synced_at` in frontmatter

### Pull Linear → local
```bash
./scripts/linear-sync.sh pull [issue-id]
```
- Updates local task statuses from Linear
- Pulls new comments as task notes
- Updates `linear.state` in frontmatter

### Full bidirectional sync
```bash
./scripts/linear-sync.sh sync
```
- Compares timestamps
- Pushes local changes newer than `synced_at`
- Pulls Linear changes newer than `synced_at`
- Warns on conflicts (both modified)

### Link existing spec to issue
```bash
./scripts/linear-sync.sh link <spec-file> <issue-id>
```

### Status check
```bash
./scripts/linear-sync.sh status
```
Shows sync state of all specs.

---

## Sync Rules

### What syncs Local → Linear
| Local | Linear |
|-------|--------|
| Spec title | Issue title |
| Spec body (## Goal, ## Requirements) | Issue description |
| Task files | Sub-issues or checklist |
| Task status (todo/in-progress/done) | Issue state |

### What syncs Linear → Local
| Linear | Local |
|--------|-------|
| Issue state | Task status in frontmatter |
| Issue assignee | `assignee` in frontmatter |
| Comments | Appended to `## Notes` section |
| Labels | `labels` in frontmatter |

### What doesn't sync
- Foundation docs (never synced, human-only)
- Linear project/cycle (managed in Linear UI)
- Attachments

---

## Conflict Resolution

When both local and Linear modified since last sync:

1. **Default:** Warn and skip
2. **--force-local:** Local wins
3. **--force-remote:** Linear wins
4. **--merge:** Attempt merge (appends Linear comments, keeps local structure)

```bash
./scripts/linear-sync.sh sync --force-local
```

---

## Task Mapping

Tasks can map to Linear in two ways:

### Option A: Sub-issues (default)
Each task file becomes a sub-issue:
```
feat001-payments.md      → GET-42
feat001-task001.md       → GET-43 (parent: GET-42)
feat001-task002.md       → GET-44 (parent: GET-42)
```

### Option B: Checklist
Tasks become checklist items in the parent issue description:
```
feat001-payments.md      → GET-42
  - [ ] task001: Stripe integration
  - [x] task002: Webhook handling
```

Configure in `.linear-sync.json`:
```json
{
  "taskMapping": "sub-issues" | "checklist"
}
```

---

## Workflow Example

### Starting a new feature

```bash
# 1. Create spec locally
cat > context/specs/feat005-notifications.md << 'EOF'
---
type: feat
number: 005
title: Push Notifications
linear:
  team: GetAI
---

# feat005 - Push Notifications

## Goal
Add push notification support for mobile apps.

## Requirements
- [ ] Firebase Cloud Messaging integration
- [ ] Notification preferences per user
- [ ] Silent vs alert notifications
EOF

# 2. Push to Linear
./scripts/linear-sync.sh push context/specs/feat005-notifications.md
# Creates GET-50, updates frontmatter with issue ID

# 3. Work happens, Linear state changes...

# 4. Pull updates
./scripts/linear-sync.sh pull
# Updates local task statuses
```

### Linking existing work

```bash
# Link existing spec to existing Linear issue
./scripts/linear-sync.sh link context/specs/feat003-auth.md GET-28
```

---

## Integration with context-engineering

This skill complements `context-engineering`:

```
context-engineering     →  Defines spec/task structure
linear-sync            →  Syncs that structure to Linear
```

Use together:
```bash
# Load context (from context-engineering)
ctx load feat001

# Sync with Linear (from linear-sync)
./scripts/linear-sync.sh sync
```

---

## Troubleshooting

### "Issue not found"
- Check `LINEAR_API_TOKEN` is set
- Verify team key matches (`GET`, `LOAD`, `FLEXPAY`)

### "State mismatch"
- Linear states: Backlog, Todo, In Progress, Done, Canceled
- Local states: todo, in-progress, done, blocked
- Mapping is automatic but custom states need config

### "Sync conflict"
- Both local and Linear modified
- Use `--force-local` or `--force-remote`
- Or manually resolve and run sync again
