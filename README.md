# Agent Skills

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

Follows the [Agent Skills](https://agentskills.io/) open format.

## Available Skills

| Skill | Description |
|-------|-------------|
| [context-engineering](./context-engineering/) | Human-readable context management for specs, tasks, and foundations |
| [linear-sync](./linear-sync/) | Bidirectional sync between local specs/tasks and Linear issues |
| [logging-standards](./logging-standards/) | Our standard approach to logging — one event per request with full context |
| [marketing-copy](./marketing-copy/) | Write compelling marketing copy with Jason Fried clarity + Made to Stick principles |

## Installation

### Claude Code Marketplace (Recommended)
```bash
claude plugin install context-engineering
claude plugin install linear-sync
claude plugin install marketing-copy
```

### Manual (global)
```bash
git clone https://github.com/justgetAI/agent-skills.git /tmp/agent-skills
mkdir -p ~/.claude/skills
cp -r /tmp/agent-skills/<skill-name> ~/.claude/skills/
```

### Manual (per-project)
```bash
git clone https://github.com/justgetAI/agent-skills.git /tmp/agent-skills
mkdir -p .claude/skills
cp -r /tmp/agent-skills/<skill-name> .claude/skills/
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
