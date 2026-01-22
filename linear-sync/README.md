# Linear Sync

Bidirectional sync between local spec/task files and Linear issues.

## Quick Start

```bash
# 1. Install linearis
npm install -g linearis

# 2. Set API token
export LINEAR_API_TOKEN="lin_api_..."

# 3. Create config
cp .linear-sync.example.json .linear-sync.json
# Edit with your team

# 4. Sync!
./scripts/linear-sync.sh status  # Check current state
./scripts/linear-sync.sh push    # Push local → Linear
./scripts/linear-sync.sh pull    # Pull Linear → local
./scripts/linear-sync.sh sync    # Bidirectional
```

## Commands

| Command | Description |
|---------|-------------|
| `push [file]` | Push spec(s) to Linear |
| `pull [issue]` | Pull issue(s) to local |
| `sync` | Bidirectional sync |
| `link <spec> <issue>` | Link existing spec to issue |
| `status` | Show sync status |

## Spec Frontmatter

```yaml
---
type: feat
number: 001
title: My Feature
linear:
  issue: GET-42        # Auto-set on push
  team: GetAI
  state: In Progress   # Updated on pull
  synced_at: ...       # Auto-set
---
```

## Conflict Resolution

When both local and Linear modified:

```bash
./scripts/linear-sync.sh sync --force-local   # Local wins
./scripts/linear-sync.sh sync --force-remote  # Linear wins
```

## Works with context-engineering

This skill complements the `context-engineering` skill:

- `context-engineering` defines the spec/task file structure
- `linear-sync` syncs that structure to Linear

See [SKILL.md](SKILL.md) for full documentation.
