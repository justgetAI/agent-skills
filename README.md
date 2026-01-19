# Agent Skills

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

Follows the [Agent Skills](https://agentskills.io/) format.

## Available Skills

| Skill | Description |
|-------|-------------|
| [context-engineering](./context-engineering/) | Human-readable context management system for specs, tasks, and foundations |

## Installation

```bash
npx add-skill justgetAI/agent-skills
```

Or copy the skill directory into your project and reference it in your agent config.

## Skill Structure

Each skill contains:

- `SKILL.md` — Instructions for the agent
- `scripts/` — Helper scripts for automation (optional)
- `references/` — Supporting documentation (optional)
- `assets/` — Templates and examples (optional)

## License

MIT
