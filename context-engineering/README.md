# Context Engineering

Human-readable context management for AI coding agents.

## What is it?

A filesystem-based system for managing specs, tasks, and foundation docs. Works across Claude Code, Cursor, OpenCode, and any markdown-instruction agent.

## Installation

### Claude Code
```bash
# Option A: npx
npx add-skill justgetAI/agent-skills --skill context-engineering

# Option B: Manual
git clone https://github.com/justgetAI/agent-skills.git /tmp/agent-skills
mkdir -p ~/.claude/skills
cp -r /tmp/agent-skills/context-engineering ~/.claude/skills/
```

### Cursor
Copy contents of `references/integrations/cursor-rules.md` into `.cursorrules`

### Other agents
See `references/integrations/generic.md`

## Quick Start (after installation)

```bash
# 1. Initialize context/ in your project
~/.claude/skills/context-engineering/scripts/init.sh
# or with examples:
~/.claude/skills/context-engineering/scripts/init.sh --with-examples

# 2. Create specs and tasks
~/.claude/skills/context-engineering/scripts/ctx new spec feat payments
~/.claude/skills/context-engineering/scripts/ctx new task feat001 stripe-integration
```

Or just ask your agent to "set up context engineering" — it will read SKILL.md and know what to do.

## Directory Structure

```
context/
├── foundation/    # Human-authored source of truth (read-only for agents)
├── specs/         # Feature/fix/improve definitions
└── tasks/         # Atomic implementation units
```

## Philosophy

- **Human-readable** — `cat` any file, instantly know state
- **Foundation-first** — reference foundation before doing work
- **Gated writes** — agents read foundation, never write directly
- **No archiving** — done tasks stay in place, history is a feature

## CLI Reference

```bash
ctx new spec <type> <name>    # Create spec (feat|fix|improve)
ctx new task <spec> <name>    # Create task for spec
ctx list specs                # List all specs with task counts
ctx list tasks [spec]         # List tasks (optionally filtered)
```

## Integration Snippets

- [Claude Code](references/integrations/claude-md.md)
- [Cursor](references/integrations/cursor-rules.md)
- [Generic](references/integrations/generic.md)

## Full Documentation

See [SKILL.md](SKILL.md) for complete workflow instructions.
