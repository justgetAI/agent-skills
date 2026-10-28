<div align="center">

# Agent Skills

**Ship features with coding agents: spec to verified main merge, with learnings that make the next change easier.**

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](LICENSE)
[![Version](https://img.shields.io/badge/context--engineering-3.4.0-black.svg)](CHANGELOG.md)
[![Hosts](https://img.shields.io/badge/hosts-Claude%20Code%20%C2%B7%20Codex%20%C2%B7%20OpenCode-black.svg)](#install)

</div>

The flagship is **context-engineering**, a plugin of 10 skills that runs the whole loop. It researches the codebase and past learnings, writes a spec, builds it, reviews it with several adversarially verified reviewers, and captures what it learned. Then it ships: it opens the PR, babysits the review bots, merges to dev, live-tests in a real environment and gates the main merge.

It runs on Claude Code, Codex and OpenCode from one set of skill files, and on any agent that reads [Agent Skills](https://agentskills.io/).

## Install

### Claude Code

```text
/plugin marketplace add justgetAI/agent-skills
/plugin install context-engineering@justgetai-tools
```

### Codex CLI

```bash
codex plugin marketplace add justgetAI/agent-skills
codex plugin add context-engineering@justgetai-tools
```

In the Codex app, open **Plugins**, select **Add marketplace**, enter `justgetAI/agent-skills` (git ref `main`), then install **context-engineering**. Restart Codex after installing.

### OpenCode

Add the plugin to your global (`~/.config/opencode/opencode.json`) or project `opencode.json`:

```json
{
  "plugin": ["context-engineering@git+https://github.com/justgetAI/agent-skills.git"]
}
```

Restart OpenCode. The plugin registers every skill as both an OpenCode skill and a `/command`, so `/lets-ship` and `/pr-loop` work directly.

### Any other agent

```bash
npx skills add justgetAI/agent-skills --skill context-engineering
```

This works with the [Skills CLI](https://github.com/vercel-labs/skills) on Cursor, Gemini CLI, Factory, Windsurf and others.

## Quick Start

```text
/lets-ship "add rate limiting to the login endpoint"
```

With no mode flag, it asks which mode you want first:

| Mode | Flag | What happens |
|---|---|---|
| **full-stop** | `--full-stop` | You stay in the loop: it asks before each phase and before each merge. |
| **auto** | `--auto` | Ships to dev, verifies in a real environment (browser, simulator, live API), fixes PR findings, then stops **ready for main** with a report. |
| **yolo** | `--yolo` | Same as auto, then merges to main without asking, but only if the verdict, SHA, merge state and findings all check out. |

Already have a built branch? Run `/pr-loop` to go from PR to main.

## The Loop

| Phase | Skill | What it does |
|---|---|---|
| 1. Understand | `lets-ship` | Loads foundation docs; repo and learnings researchers report back |
| 2. Plan | `spec`, `deepen` | Date-named spec with acceptance criteria and a root-cause check |
| 3. Work | `work` | One task per criterion, tests, incremental commits |
| 4. Review | `review` | Simplicity, spec, bug and anti-slop reviewers; every blocking finding is blind-verified |
| 5. Compound | `compound` | Writes learnings to `docs/solutions/`, rates the spec |
| 6. PR loop | `pr-loop` | PR to the right base; waits for CI and review bots; verifies, fixes or dismisses each finding (3 rounds, 5 for security) |
| 7. Live verify | `pr-loop` | Merges to dev; a fresh agent tests the real behavior and posts a verdict with the SHA |
| 8. Main merge | `pr-loop` | Report, approval (unless yolo), SHA re-check, merge commit |

Around the loop: `status` (where things stand), `audit` (document an existing codebase), `compound-refresh` (prune stale learnings).

## Other Skills

| Skill | What it covers |
|---|---|
| [anti-slop](./anti-slop/) | Oxlint rules that reject low-evidence TypeScript/JavaScript patterns; feeds the review phase |
| [prompt-engineering](./prompt-engineering/) | One checklist distilled from the five major prompt-engineering guides |
| [marketing-copy](./marketing-copy/) | Marketing copy with Jason Fried clarity and Made to Stick principles |
| [orchestrating-swarms](./orchestrating-swarms/) | Multi-agent orchestration with Claude Code teams and tasks |

Install any of them with `npx skills add justgetAI/agent-skills --skill <name>`, or on Claude Code with `claude plugin install <name>@justgetai-tools`.

## Upgrading

| Host | Command |
|---|---|
| Claude Code | `claude plugin marketplace update justgetai-tools && claude plugin update context-engineering@justgetai-tools` |
| Codex | `codex plugin marketplace upgrade justgetai-tools`, then restart Codex |
| OpenCode | Restart OpenCode; pin a ref with `...agent-skills.git#<tag>` |
| Skills CLI | Re-run `npx skills add justgetAI/agent-skills --skill context-engineering` |

Refresh the marketplace before updating. Updating the plugin alone keeps the old version.

## FAQ

**Does auto ever merge to main?** No. auto stops ready for main, with the report posted. Only yolo merges main, and only when every check passes. Otherwise it stops and says why.

**What counts as live verification?** Real behavior in a realistic environment: a browser against the deployed dev env for web, a simulator or device for mobile, real requests for APIs. Unit tests, CI and bot approval don't count, and the verifier is never the agent that wrote the code.

**Codex and OpenCode don't have Claude's Teams or `AskUserQuestion`. Does it still work?** Yes. [`references/harness-tools.md`](context-engineering/references/harness-tools.md) maps every Claude tool to its Codex and OpenCode equivalent, with a fallback when there isn't one.

**Repos without a `dev` branch?** The PR targets the default branch, verification runs on the PR head, and the merge happens at the Phase 8 gate.

## Contributing

See [AGENTS.md](AGENTS.md) for the repo layout and how to test changes on each host, and [CONTRIBUTING.md](CONTRIBUTING.md) for adding a skill.

## License

MIT
