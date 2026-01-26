---
name: linear-sync
description: Bidirectional sync between context-engineering specs/tasks and Linear issues
requires:
  - linearis CLI (npm install -g linearis)
  - LINEAR_API_TOKEN env var
---

# Linear Integration

Sync your specs and tasks with Linear issues. Bidirectional — changes flow both ways.

## Setup

### 1. Install linearis
```bash
npm install -g linearis
```

### 2. Set API token
```bash
export LINEAR_API_TOKEN="lin_api_..."
```

### 3. Configure (optional — auto-detects from directory)

The script auto-detects team from directory name:
- `loadhealth-*` or `load-*` → **Load**
- `flexpay-*` → **FlexPay**
- `pelian-*` → **Pelian**

Or set explicitly via config:
```bash
cp integrations/linear/.linear-sync.example.json .linear-sync.json
# Edit with your team key
```

## Spec Frontmatter

Add Linear metadata to specs:

```yaml
---
type: feat
number: 001
title: User Authentication
linear:
  issue: GET-42        # Auto-set on push
  team: GetAI
  state: In Progress   # Updated on pull
  synced_at: 2026-01-22T02:00:00Z
---
```

## Commands

| Command | Description |
|---------|-------------|
| `./scripts/linear-sync.sh push [spec]` | Push spec(s) to Linear |
| `./scripts/linear-sync.sh pull [issue]` | Pull issue(s) to local |
| `./scripts/linear-sync.sh sync` | Bidirectional sync |
| `./scripts/linear-sync.sh link <spec> <issue>` | Link existing |
| `./scripts/linear-sync.sh status` | Show sync state |

## Sync Rules

### Local → Linear
| Local | Linear |
|-------|--------|
| Spec title | Issue title |
| Spec body | Issue description |
| Task files | Sub-issues |
| Task status | Issue state |

### Linear → Local
| Linear | Local |
|--------|-------|
| Issue state | Task status |
| Comments | `## Notes` section |
| Labels | Frontmatter labels |

## Conflict Resolution

When both sides modified since last sync:

```bash
./scripts/linear-sync.sh sync --force-local   # Local wins
./scripts/linear-sync.sh sync --force-remote  # Linear wins
```

## Workflow Example

```bash
# Create spec locally
vim context/specs/feat005-notifications.md

# Push to Linear (creates issue)
./integrations/linear/scripts/linear-sync.sh push feat005

# Work happens, Linear state changes...

# Pull updates
./integrations/linear/scripts/linear-sync.sh pull
```
