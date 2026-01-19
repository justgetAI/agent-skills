# Context Engineering

Human-readable context management for AI coding agents.

## What is it?

A filesystem-based system for managing specs, tasks, and foundation docs. Works across Claude Code, Cursor, OpenCode, and any markdown-instruction agent.

## Quick Start

```bash
# 1. Clone or copy the skill
git clone https://github.com/justgetAI/agent-skills.git
cd agent-skills/context-engineering

# 2. Initialize in your project
./scripts/init.sh              # minimal
./scripts/init.sh --with-examples  # with examples

# 3. Create specs and tasks
./scripts/ctx new spec feat payments
./scripts/ctx new task feat001 stripe-integration
```

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

## Integration

See `references/integrations/` for copy-paste snippets:
- [Claude Code](references/integrations/claude-md.md)
- [Cursor](references/integrations/cursor-rules.md)
- [Generic](references/integrations/generic.md)

## Full Documentation

See [SKILL.md](SKILL.md) for complete workflow instructions.
