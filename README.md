# Agent Skills

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

Follows the [Agent Skills](https://agentskills.io/) open format.

## Available Skills

| Skill | Description |
|-------|-------------|
| [context-engineering](./context-engineering/) | Human-readable context management for specs, tasks, and foundations |
| [logging-standards](./logging-standards/) | Our standard approach to logging — one event per request with full context |

## Installation

### Option 1: npx add-skill
```bash
npx add-skill justgetAI/agent-skills --skill context-engineering
```

### Option 2: Manual (global)
```bash
git clone https://github.com/justgetAI/agent-skills.git /tmp/agent-skills
mkdir -p ~/.claude/skills
cp -r /tmp/agent-skills/context-engineering ~/.claude/skills/
```

### Option 3: Manual (per-project)
```bash
git clone https://github.com/justgetAI/agent-skills.git /tmp/agent-skills
mkdir -p .claude/skills
cp -r /tmp/agent-skills/context-engineering .claude/skills/
```

## Skill Structure

Each skill follows the Agent Skills format:

```
skill-name/
├── SKILL.md        # Instructions for the agent (required)
├── README.md       # Human documentation
├── scripts/        # Helper scripts
├── references/     # Supporting docs
└── assets/         # Templates, examples
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add skills.

## License

MIT
