Load and summarize the active context for the current project.

Steps:
1. Read all files in context/foundation/ to understand project ground truth
2. Identify active spec from git branch name or ask user
3. Read the active spec file from context/specs/
4. Read related tasks from context/tasks/{spec}-task*
5. Return a condensed summary:
   - Key foundation facts relevant to current work
   - Spec goal and problem statement
   - Task statuses (todo/in-progress/done/blocked)
   - Any blockers

Be concise. Focus on what's actionable for the current session.

Foundation rules:
- Foundation is read-only for agents
- Note discoveries in task's ## Discoveries section
- Human reviews and updates foundation
