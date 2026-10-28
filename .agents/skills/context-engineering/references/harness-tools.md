# Harness Tools

The skills are written with Claude Code tool names. On other harnesses, map each one to the closest tool below. When there's no equivalent, use the fallback and keep going. Never skip a gate or a review because a tool is missing.

| Skill says | Claude Code | Codex | OpenCode | Fallback |
|---|---|---|---|---|
| Ask the user (gates, mode pick) | `AskUserQuestion` | `request_user_input` | `question` | Ask in chat with numbered options; wait |
| Track phases / tasks | `TaskCreate` / `TaskUpdate` | `update_plan` | `todowrite` | Checklist in the spec file |
| Team for the trace | `TeamCreate` | — | — | Skip; the spec, PR comments and `docs/solutions/` are the trace |
| Spawn a named agent (`context-engineering:bug-hunter`, …) | `Task` with `subagent_type` | `spawn_agent` | `task` | Run it yourself, using the agent file as instructions |
| Message a teammate / shutdown | `SendMessage` | `send_input` / `close_agent` | — | Skip |
| Load another skill (`/pr-loop`, `/review`) | `Skill` | Open its `SKILL.md` | `skill` | Read `skills/<name>/SKILL.md` and follow it |

## Named Agents Off Claude

Agent definitions live in [`agents/`](../agents/). If the harness can't spawn a named type, spawn a general subagent. Its prompt is the body of `agents/<name>.md` followed by the task-specific prompt from the skill. Blind verification (`finding-verifier`) still gets the claim only, never the reviewer's reasoning.

## Paths

`${CLAUDE_PLUGIN_ROOT}` is Claude-only. Elsewhere, resolve paths from this plugin's root: the directory holding `skills/`, `agents/`, `references/` and `scripts/`.
