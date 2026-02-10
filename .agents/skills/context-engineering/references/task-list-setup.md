# Claude Code Task List Setup

How to always enable `CLAUDE_CODE_TASK_LIST_ID` for persistent task sync.

## What It Does

- Tasks stored in `~/.claude/tasks/<task-list-id>.json`
- Cross-session sync — continue work in new sessions
- Multi-agent coordination — subagents see shared progress
- Live broadcasts — updates propagate to all sessions on same list

## Option 1: Always Use Same List (Simple)

Add to your shell profile (`~/.bashrc`, `~/.zshrc`):

```bash
export CLAUDE_CODE_TASK_LIST_ID="default"
```

**Pros:** Zero setup, always on
**Cons:** All projects share one list

## Option 2: Per-Directory Auto-Derive (Recommended)

Add to your shell profile:

```bash
# Auto-set task list from current directory
claude() {
  export CLAUDE_CODE_TASK_LIST_ID="$(basename $PWD)"
  command claude "$@"
}
```

Or use a shell hook (zsh example):

```zsh
# In ~/.zshrc
autoload -U add-zsh-hook

set_task_list() {
  export CLAUDE_CODE_TASK_LIST_ID="$(basename $PWD)"
}

add-zsh-hook chpwd set_task_list
set_task_list  # run once at shell start
```

**Pros:** Automatic, project-scoped
**Cons:** Needs shell restart after setup

## Option 3: Manual per Session

```bash
CLAUDE_CODE_TASK_LIST_ID=my-feature claude
```

**Pros:** Full control
**Cons:** Easy to forget

## Verify It's Working

Inside Claude Code:

```
> Check my task list ID

# Should show: CLAUDE_CODE_TASK_LIST_ID = <your-list>
```

Or check tasks file:

```bash
ls ~/.claude/tasks/
```

## In Context Engineering Workflows

The `/swarm-context-engineer`, `/work`, and `/audit-context` commands **automatically set the task list ID** based on the spec or feature name. No manual setup needed when using these commands.

```
/swarm-context-engineer add Stripe payments
# Auto-sets: CLAUDE_CODE_TASK_LIST_ID=add-stripe-payments-20260126

/work context/specs/payments.md
# Auto-sets: CLAUDE_CODE_TASK_LIST_ID=payments
```

## Reference

From Anthropic's announcement:
> Tasks are stored in `~/.claude/tasks`, you can use this to build additional utilities on top of tasks as well.
> 
> To make sessions collaborate on a single Task List, you can set the TaskList as an environment variable:
> ```
> CLAUDE_CODE_TASK_LIST_ID=groceries claude
> ```
> This also works for `claude -p` and the AgentSDK.
