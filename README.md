# Agent Skills

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

Follows the [Agent Skills](https://agentskills.io/) open format.

## Available Skills

| Skill | Description |
|-------|-------------|
| [context-engineering](./context-engineering/) | Human-readable context management with modular rules and Linear integration |
| [marketing-copy](./marketing-copy/) | Write compelling marketing copy with Jason Fried clarity + Made to Stick principles |
| [orchestrating-swarms](./orchestrating-swarms/) | Multi-agent orchestration using Claude Code's TeammateTool and Task system |

## Installation

### npx skills add (Recommended)

One command via the [Vercel Labs Skills CLI](https://github.com/vercel-labs/skills):

```bash
npx skills add justgetAI/agent-skills --skill "context-engineering"
npx skills add justgetAI/agent-skills --skill "marketing-copy"
npx skills add justgetAI/agent-skills --skill "orchestrating-swarms"
```

List all available skills:
```bash
npx skills add justgetAI/agent-skills --list
```

### Claude Code Marketplace
```bash
# Add marketplace
claude plugin marketplace add justgetAI/agent-skills

# Install skills
claude plugin install context-engineering@justgetai-tools
claude plugin install marketing-copy@justgetai-tools
claude plugin install orchestrating-swarms@justgetai-tools
```

### Other Tools (Cursor, Gemini CLI, etc.)

Skills follow the [Agent Skills](https://agentskills.io/) open format. Copy the skill directory into your tool's instruction path — each `SKILL.md` works as a standalone prompt.

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

Each skill follows the Agent Skills format with modular rules:

```
skill-name/
├── SKILL.md           # Main instructions (lean, links to rules)
├── README.md          # Human documentation
├── rules/             # Modular rule files
│   ├── naming.md
│   ├── lifecycle.md
│   └── ...
├── integrations/      # Optional integrations
│   └── linear/
├── scripts/           # Helper scripts
├── references/        # Supporting docs
└── assets/            # Templates, examples
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add skills.

## License

MIT
