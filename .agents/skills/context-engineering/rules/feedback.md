# Self-Improvement Loop

Rate completed specs to drive system improvement.

## Feedback Command

```bash
ctx feedback <spec> <rating> [issue-slug]
```

## Rating Scale

| Rating | Meaning | Action |
|--------|---------|--------|
| 5 | Perfect | None needed |
| 4 | Good, minor friction | Note for future |
| 3 | Acceptable, notable issues | Review and improve |
| 2 | Poor, needs improvement | Create improve spec |
| 1 | Failed | Create improve spec + postmortem |

## Auto-Improvement

When rating ≤ 3 with an issue slug:

1. Updates spec's `## Feedback` section
2. Auto-creates `improve{###}-{issue}.md`
3. Links back to source spec

## Common Issue Slugs

| Slug | Meaning | Fix |
|------|---------|-----|
| `too-verbose` | Context too wordy | Sacrifice grammar for conciseness |
| `wrong-format` | Templates mismatch | Adjust templates |
| `missed-context` | Important info not loaded | Fix loading protocol |
| `unclear-instructions` | Agent confused | Clarify SKILL.md |
| `wrong-scope` | Task too big/small | Adjust task granularity |

## Example

```bash
# Rate feat001 as 2/5 with "too-verbose" issue
ctx feedback feat001 2 too-verbose

# Creates:
# - Updates specs/feat001-payments.md ## Feedback
# - Creates specs/improve004-too-verbose.md
```

## Feedback Section Format

```markdown
## Feedback

**Rating:** 2/5
**Issue:** too-verbose
**Linked improvement:** improve004-too-verbose
**Notes:** Task descriptions were too long, agent spent tokens on boilerplate.
```
