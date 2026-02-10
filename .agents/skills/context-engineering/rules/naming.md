# Naming Conventions

## Spec Types
| Type | Purpose | Example |
|------|---------|---------|
| `feat` | New functionality | `feat001-payments.md` |
| `fix` | Bug fixes | `fix002-login-redirect.md` |
| `improve` | Enhancements | `improve003-dashboard-perf.md` |

## Format Patterns

**Specs:**
```
{type}{###}-{name}.md
```

**Tasks:**
```
{type}{###}-task{###}-{name}.md
```

**Edge cases (no parent spec):**
```
misc-task{###}-{name}.md
```

## Examples

```bash
# Specs
context/specs/feat001-payments.md
context/specs/fix002-login-redirect.md
context/specs/improve003-dashboard-perf.md

# Tasks (belong to specs)
context/tasks/feat001-task001-stripe-integration.md
context/tasks/feat001-task002-webhook-handling.md

# Standalone tasks
context/tasks/misc-task001-bump-deps.md
```

## Numbering Rules

| Scope | Rule |
|-------|------|
| Spec numbers | Global (feat001, feat002, fix001...) |
| Task numbers | Per-spec (feat001-task001, feat001-task002) |

**Humans assign spec numbers.** Agents only create tasks within assigned specs.
