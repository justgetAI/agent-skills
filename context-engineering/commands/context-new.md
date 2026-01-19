Create a new spec or task in the context system.

Usage patterns:
- "new spec feat payments" → create feat spec for payments
- "new task feat001 stripe-setup" → create task for feat001

Use the ctx CLI: `${CLAUDE_PLUGIN_ROOT}/scripts/ctx new spec|task <args>`

Spec types: feat (features), fix (bugs), improve (enhancements)

Task naming: {spec}-task{###}-{name}.md (e.g., feat001-task001-setup.md)

After creation, show the file path and suggest filling in the template.
