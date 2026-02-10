Rate a completed spec and optionally trigger self-improvement.

Usage: /context-feedback <spec> <rating 1-5> [issue-slug]

Examples:
- "/context-feedback feat001 5" → great work, no improvement needed
- "/context-feedback feat001 2 too-verbose" → creates improve spec

Use the ctx CLI: `${CLAUDE_PLUGIN_ROOT}/scripts/ctx feedback <spec> <rating> [issue]`

Rating guide:
- 5: perfect, no issues
- 4: good, minor friction
- 3: acceptable, notable issues
- 2: poor, needs improvement
- 1: failed, major rework needed

When rating ≤ 3 with an issue:
- Updates spec's ## Feedback section
- Auto-creates improve{###}-{issue}.md spec
- Links back to source spec for context

Issue examples: too-verbose, wrong-format, missed-context, slow, unclear-instructions
