# Agent Instructions

This repo holds the `context-engineering` plugin, a few smaller skills, and the marketplace metadata that ships them to Claude Code, Codex and OpenCode.

## Layout

```
.claude-plugin/marketplace.json     Claude Code marketplace (justgetai-tools)
.agents/plugins/marketplace.json    Codex marketplace (justgetai-tools)
package.json + index.js             OpenCode package entry
.opencode/plugins/context-engineering.js   OpenCode loader: skills + /commands
context-engineering/                the plugin root
  .claude-plugin/plugin.json        Claude manifest
  .codex-plugin/plugin.json         Codex manifest ("skills": "./skills/")
  SKILL.md                          top-level skill (npx skills, any agent)
  skills/<name>/SKILL.md            one skill per workflow: lets-ship, pr-loop, review, ...
  agents/                           named subagents (reviewers, researchers, verifier)
  references/                       shared docs, incl. ship-modes.md and harness-tools.md
  rules/ scripts/ assets/ integrations/
.agents/skills/context-engineering/ byte-identical mirror for npx skills / Skills CLI
.agent/ .cursor/ .factory/ .windsurf/ skills/   symlinks into .agents/skills
```

## Working Agreement

- **Branch, PR, merge commit.** Never push to main. Merge with `gh pr merge --merge`, never squash.
- **No AI attribution** in commits or PR bodies. Agent-posted PR comments end with `— <model> via <harness> (agent comment)`.
- **Keep the mirror in sync.** After editing `context-engineering/`, run:
  ```bash
  rsync -a --delete context-engineering/ .agents/skills/context-engineering/
  diff -rq context-engineering .agents/skills/context-engineering   # must print nothing
  ```
- **Bump versions together** when a release changes behavior: `context-engineering/.claude-plugin/plugin.json`, `context-engineering/.codex-plugin/plugin.json`, both entries in `.claude-plugin/marketplace.json`, and `package.json`. Add a `CHANGELOG.md` entry.
- **Skills, not commands.** New workflows go in `context-engineering/skills/<name>/SKILL.md` with `name` and `description` frontmatter. Codex and OpenCode only load skills.
- **Write for every host.** Use Claude tool names in skills, and keep [`references/harness-tools.md`](context-engineering/references/harness-tools.md) current when you add a tool. Paths are relative to the plugin root; `${CLAUDE_PLUGIN_ROOT}` is Claude-only.
- **Ship modes live in one place:** [`references/ship-modes.md`](context-engineering/references/ship-modes.md). `lets-ship` and `pr-loop` link to it rather than restating it.

## Validate

```bash
claude plugin validate --strict .claude-plugin/marketplace.json
claude plugin validate --strict context-engineering/.claude-plugin/plugin.json

# OpenCode loader registers every skill
node -e 'import("./index.js").then(async m=>{const s=await m.default.server();const c={};await s.config(c);console.log(Object.keys(c.command))})'

# Codex installs from this checkout (scratch home, nothing touched)
export CODEX_HOME=$(mktemp -d); cp ~/.codex/auth.json "$CODEX_HOME"/
codex plugin marketplace add "$PWD" && codex plugin add context-engineering@justgetai-tools
```

## Local Testing per Host

| Host | Point it at this checkout |
|---|---|
| Claude Code | `claude --plugin-dir ./context-engineering` |
| Codex | `codex plugin marketplace add "$PWD"` (snapshot: re-add after edits) |
| OpenCode | `"plugins": ["/path/to/agent-skills"]` (1.x: `"plugin"`) in `opencode.json`, or open this repo as the project |
