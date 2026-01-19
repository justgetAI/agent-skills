# Agent Skills

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

Follows the [Agent Skills](https://agentskills.io/) open format.

## Available Skills

| Skill | Description |
|-------|-------------|
| [context-engineering](./context-engineering/) | Human-readable context management for specs, tasks, and foundations |

## Installation

### Option 1: npx (if supported by your agent)
```bash
npx add-skill justgetAI/agent-skills/context-engineering
```

### Option 2: Clone and copy
```bash
git clone https://github.com/justgetAI/agent-skills.git
cp -r agent-skills/context-engineering /path/to/your/project/.skills/
```

### Option 3: Reference directly
Add skill path to your agent config (CLAUDE.md, .cursorrules, etc.)

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
