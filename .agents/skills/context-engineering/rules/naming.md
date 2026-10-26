# Naming Conventions

## Spec Types
| Type | Purpose | Example |
|------|---------|---------|
| `feat` | New functionality | `2026-01-26-feat-payments.md` |
| `fix` | Bug fixes | `2026-01-26-fix-login-redirect.md` |
| `improve` | Enhancements | `2026-01-26-improve-dashboard-perf.md` |

## Format Patterns

**Specs (canonical):**
```
YYYY-MM-DD-<type>-<name>.md
```

**Tasks (belong to a date-named spec):**
```
YYYY-MM-DD-<type>-<name>-task{###}-<task-name>.md
```

**Edge cases (no parent spec):**
```
misc-task{###}-{name}.md
```

## Examples

```bash
# Specs
context/specs/2026-01-26-feat-payments.md
context/specs/2026-01-26-fix-login-redirect.md
context/specs/2026-01-26-improve-dashboard-perf.md

# Tasks (belong to specs — prefix is the full spec stem)
context/tasks/2026-01-26-feat-payments-task001-stripe-integration.md
context/tasks/2026-01-26-feat-payments-task002-webhook-handling.md

# Standalone tasks
context/tasks/misc-task001-bump-deps.md
```

## Numbering Rules

| Scope | Rule |
|-------|------|
| Spec identity | Date + type + slug (unique per day/type/name) |
| Task numbers | Per-spec (`…-task001`, `…-task002`) |

**Agents and `scripts/ctx` create date-named specs.** Humans may still open older numbered files.

## Legacy (read-only compatibility)

Older repos may still have numbered specs:

```
{type}{###}-{name}.md          # e.g. feat001-payments.md, improve001-log-taxonomy.md
{type}{###}-task{###}-{name}.md
```

`scripts/ctx` (`list`, `feedback`, `new task`) still resolves these. **Do not create new numbered specs** — writers (`/lets-ship`, `/spec`, `/compound` improve specs, `ctx new spec`) use the date form only.
