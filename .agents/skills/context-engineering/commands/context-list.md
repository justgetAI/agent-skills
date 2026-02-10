List specs and tasks in the context system.

Usage patterns:
- "list specs" → show all specs with task counts
- "list tasks" → show all tasks with status
- "list tasks feat001" → show tasks for specific spec

Use the ctx CLI: `${CLAUDE_PLUGIN_ROOT}/scripts/ctx list specs|tasks [filter]`

Present results in a clean, scannable format showing:
- Spec name and task completion status
- Task name and current status (todo/in-progress/done/blocked)
