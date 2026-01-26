---
name: orchestrating-swarms
description: Master multi-agent orchestration using Claude Code's TeammateTool and Task system. Use when coordinating multiple agents, running parallel code reviews, creating pipeline workflows with dependencies, building self-organizing task queues, or any task benefiting from divide-and-conquer patterns.
---

# Claude Code Swarm Orchestration

Master multi-agent orchestration using Claude Code's TeammateTool and Task system.

---

## Primitives

| Primitive | What It Is | File Location |
|-----------|-----------|---------------|
| **Agent** | A Claude instance that can use tools. You are an agent. Subagents are agents you spawn. | N/A (process) |
| **Team** | A named group of agents working together. One leader, multiple teammates. | `~/.claude/teams/{name}/config.json` |
| **Teammate** | An agent that joined a team. Has a name, color, inbox. Spawned via Task with `team_name` + `name`. | Listed in team config |
| **Leader** | The agent that created the team. Receives teammate messages, approves plans/shutdowns. | First member in config |
| **Task** | A work item with subject, description, status, owner, and dependencies. | `~/.claude/tasks/{team}/N.json` |
| **Inbox** | JSON file where an agent receives messages from teammates. | `~/.claude/teams/{name}/inboxes/{agent}.json` |
| **Message** | A JSON object sent between agents. Can be text or structured (shutdown_request, idle_notification, etc). | Stored in inbox files |
| **Backend** | How teammates run. Auto-detected: `in-process` (same Node.js, invisible), `tmux` (separate panes, visible), `iterm2` (split panes in iTerm2). See [Spawn Backends](#spawn-backends). | Auto-detected based on environment |

### How They Connect

```
┌─────────────────────────────────────────┐
│              TEAM                       │
│  ┌─────────┐                            │
│  │ Leader  │◄──────┐                    │
│  │  (you)  │       │ messages via inbox │
│  └────┬────┘       │                    │
│       │            │                    │
│  ┌────▼────┐  ┌────▼────┐               │
│  │Teammate1│◄─►Teammate2│               │
│  └─────────┘  └─────────┘               │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│           TASK LIST                     │
│  #1 completed: Research (owner: tm1)    │
│  #2 in_progress: Implement (owner: tm2) │
│  #3 pending: Test (blocked by #2)       │
└─────────────────────────────────────────┘
```

### Lifecycle

```
1. Create Team → 2. Create Tasks → 3. Spawn Teammates → 4. Work → 5. Coordinate → 6. Shutdown → 7. Cleanup
```

---

## Two Ways to Spawn Agents

### Method 1: Task Tool (Subagents)

Use Task for **short-lived, focused work** that returns a result:

```javascript
Task({
  subagent_type: "Explore",
  description: "Find auth files",
  prompt: "Find all authentication-related files in this codebase",
  model: "haiku"  // Optional: haiku, sonnet, opus
})
```

**Characteristics:**
- Runs synchronously (blocks until complete) or async with `run_in_background: true`
- Returns result directly to you
- No team membership required
- Best for: searches, analysis, focused research

### Method 2: Task Tool + team_name + name (Teammates)

Use Task with `team_name` and `name` to **spawn persistent teammates**:

```javascript
// First create a team
Teammate({ operation: "spawnTeam", team_name: "my-project" })

// Then spawn a teammate into that team
Task({
  team_name: "my-project",        // Required: which team to join
  name: "security-reviewer",      // Required: teammate's name
  subagent_type: "security-sentinel",
  prompt: "Review all authentication code for vulnerabilities. Send findings to team-lead via Teammate write.",
  run_in_background: true         // Teammates usually run in background
})
```

**Characteristics:**
- Joins team, appears in `config.json`
- Communicates via inbox messages
- Can claim tasks from shared task list
- Persists until shutdown
- Best for: parallel work, ongoing collaboration, pipeline stages

### Key Difference

| Aspect | Task (subagent) | Task + team_name + name (teammate) |
|--------|-----------------|-----------------------------------|
| Lifespan | Until task complete | Until shutdown requested |
| Communication | Return value | Inbox messages |
| Task access | None | Shared task list |
| Team membership | No | Yes |
| Coordination | One-off | Ongoing |

---

## Built-in Agent Types

### Bash
```javascript
Task({
  subagent_type: "Bash",
  description: "Run git commands",
  prompt: "Check git status and show recent commits"
})
```
- **Tools:** Bash only
- **Best for:** Git operations, command execution, system tasks

### Explore
```javascript
Task({
  subagent_type: "Explore",
  description: "Find API endpoints",
  prompt: "Find all API endpoints in this codebase. Be very thorough.",
  model: "haiku"
})
```
- **Tools:** All read-only tools (no Edit, Write, NotebookEdit, Task)
- **Model:** Haiku (optimized for speed)
- **Best for:** Codebase exploration, file searches, code understanding

### Plan
```javascript
Task({
  subagent_type: "Plan",
  description: "Design auth system",
  prompt: "Create an implementation plan for adding OAuth2 authentication"
})
```
- **Tools:** All read-only tools
- **Best for:** Architecture planning, implementation strategies

### general-purpose
```javascript
Task({
  subagent_type: "general-purpose",
  description: "Research and implement",
  prompt: "Research React Query best practices and implement caching for the user API"
})
```
- **Tools:** All tools (*)
- **Best for:** Multi-step tasks, research + action combinations

---

## TeammateTool Operations

### 1. spawnTeam - Create a Team
```javascript
Teammate({
  operation: "spawnTeam",
  team_name: "feature-auth",
  description: "Implementing OAuth2 authentication"
})
```

### 2. write - Message One Teammate
```javascript
Teammate({
  operation: "write",
  target_agent_id: "security-reviewer",
  value: "Please prioritize the authentication module."
})
```

### 3. broadcast - Message ALL Teammates
```javascript
Teammate({
  operation: "broadcast",
  name: "team-lead",
  value: "Status check: Please report your progress"
})
```
**WARNING:** Expensive - sends N messages for N teammates. Prefer `write`.

### 4. requestShutdown - Ask Teammate to Exit (Leader Only)
```javascript
Teammate({
  operation: "requestShutdown",
  target_agent_id: "security-reviewer",
  reason: "All tasks complete"
})
```

### 5. approveShutdown - Accept Shutdown (Teammate Only)
```javascript
Teammate({
  operation: "approveShutdown",
  request_id: "shutdown-123"
})
```

### 6. cleanup - Remove Team Resources
```javascript
Teammate({ operation: "cleanup" })
```
**IMPORTANT:** Will fail if teammates are still active. Use `requestShutdown` first.

---

## Task System Integration

### TaskCreate - Create Work Items
```javascript
TaskCreate({
  subject: "Review authentication module",
  description: "Review all files in app/services/auth/ for security vulnerabilities",
  activeForm: "Reviewing auth module..."
})
```

### TaskList - See All Tasks
```javascript
TaskList()
```

### TaskUpdate - Update Task Status
```javascript
// Claim a task
TaskUpdate({ taskId: "2", owner: "security-reviewer" })

// Start working
TaskUpdate({ taskId: "2", status: "in_progress" })

// Mark complete
TaskUpdate({ taskId: "2", status: "completed" })

// Set up dependencies
TaskUpdate({ taskId: "3", addBlockedBy: ["1", "2"] })
```

### Task Dependencies

When a blocking task is completed, blocked tasks are automatically unblocked:

```javascript
// Create pipeline
TaskCreate({ subject: "Step 1: Research" })        // #1
TaskCreate({ subject: "Step 2: Implement" })       // #2
TaskCreate({ subject: "Step 3: Test" })            // #3

// Set up dependencies
TaskUpdate({ taskId: "2", addBlockedBy: ["1"] })   // #2 waits for #1
TaskUpdate({ taskId: "3", addBlockedBy: ["2"] })   // #3 waits for #2
```

---

## Orchestration Patterns

### Pattern 1: Parallel Specialists (Leader Pattern)

Multiple specialists review code simultaneously:

```javascript
// 1. Create team
Teammate({ operation: "spawnTeam", team_name: "code-review" })

// 2. Spawn specialists in parallel
Task({
  team_name: "code-review",
  name: "security",
  subagent_type: "security-sentinel",
  prompt: "Review the PR for security vulnerabilities. Send findings to team-lead.",
  run_in_background: true
})

Task({
  team_name: "code-review",
  name: "performance",
  subagent_type: "performance-oracle",
  prompt: "Review the PR for performance issues. Send findings to team-lead.",
  run_in_background: true
})

// 3. Wait for results, synthesize, cleanup
```

### Pattern 2: Pipeline (Sequential Dependencies)

Each stage depends on the previous:

```javascript
// 1. Create team and task pipeline
Teammate({ operation: "spawnTeam", team_name: "feature-pipeline" })

TaskCreate({ subject: "Research" })
TaskCreate({ subject: "Plan" })
TaskCreate({ subject: "Implement" })
TaskCreate({ subject: "Test" })

// Set up sequential dependencies
TaskUpdate({ taskId: "2", addBlockedBy: ["1"] })
TaskUpdate({ taskId: "3", addBlockedBy: ["2"] })
TaskUpdate({ taskId: "4", addBlockedBy: ["3"] })

// 2. Spawn workers - tasks auto-unblock as dependencies complete
```

### Pattern 3: Swarm (Self-Organizing)

Workers grab available tasks from a pool:

```javascript
// 1. Create team and task pool (no dependencies)
Teammate({ operation: "spawnTeam", team_name: "file-review-swarm" })

for (const file of ["auth.rb", "user.rb", "api_controller.rb"]) {
  TaskCreate({ subject: `Review ${file}`, description: `Review ${file} for issues` })
}

// 2. Spawn worker swarm with self-organizing prompt
const swarmPrompt = `
  You are a swarm worker. Your job:
  1. Call TaskList to see available tasks
  2. Find a task with status 'pending' and no owner
  3. Claim it, do the work, mark it completed
  4. Send findings to team-lead
  5. Repeat until no tasks remain
`

Task({ team_name: "file-review-swarm", name: "worker-1", subagent_type: "general-purpose", prompt: swarmPrompt, run_in_background: true })
Task({ team_name: "file-review-swarm", name: "worker-2", subagent_type: "general-purpose", prompt: swarmPrompt, run_in_background: true })
```

---

## Spawn Backends

| Backend | How It Works | Visibility | Speed |
|---------|-------------|------------|-------|
| **in-process** | Same Node.js process | Hidden | Fastest |
| **tmux** | Separate tmux panes | Visible | Medium |
| **iterm2** | iTerm2 split panes | Visible | Medium |

Auto-detected based on environment. Force with:
```bash
export CLAUDE_CODE_SPAWN_BACKEND=tmux
```

---

## Graceful Shutdown Sequence

**Always follow this sequence:**

```javascript
// 1. Request shutdown for all teammates
Teammate({ operation: "requestShutdown", target_agent_id: "worker-1" })
Teammate({ operation: "requestShutdown", target_agent_id: "worker-2" })

// 2. Wait for shutdown approvals

// 3. Only then cleanup
Teammate({ operation: "cleanup" })
```

---

## Quick Reference

### Spawn Subagent (No Team)
```javascript
Task({ subagent_type: "Explore", description: "Find files", prompt: "..." })
```

### Spawn Teammate (With Team)
```javascript
Teammate({ operation: "spawnTeam", team_name: "my-team" })
Task({ team_name: "my-team", name: "worker", subagent_type: "general-purpose", prompt: "...", run_in_background: true })
```

### Message Teammate
```javascript
Teammate({ operation: "write", target_agent_id: "worker-1", value: "..." })
```

### Create Task Pipeline
```javascript
TaskCreate({ subject: "Step 1", description: "..." })
TaskCreate({ subject: "Step 2", description: "..." })
TaskUpdate({ taskId: "2", addBlockedBy: ["1"] })
```

### Shutdown Team
```javascript
Teammate({ operation: "requestShutdown", target_agent_id: "worker-1" })
// Wait for approval...
Teammate({ operation: "cleanup" })
```

---

*Based on Claude Code v2.1.19 - Tested and verified 2026-01-25*
