# Resolving the Review Base

Reviewers must diff against the branch the work actually merges into, not a hardcoded `main`.

Default flow assumed: `feature → dev → main`. A feature branch is reviewed against `dev`; `dev` itself is reviewed against the default branch.

## Snippet

Run this before gathering changes. Every reviewer in the same run must use the same `$base`.

```bash
current=$(git branch --show-current)
default=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
default=${default:-main}

if git rev-parse --verify -q origin/dev >/dev/null || git rev-parse --verify -q dev >/dev/null; then
  base=dev
else
  base=$default
fi

if [ "$base" = "$current" ]; then
  for candidate in "$default" main master; do
    [ "$candidate" = "$current" ] && continue
    if git rev-parse --verify -q "origin/$candidate" >/dev/null || git rev-parse --verify -q "$candidate" >/dev/null; then
      base=$candidate
      break
    fi
  done
fi

git rev-parse --verify -q "origin/$base" >/dev/null && base="origin/$base"
base=${CE_REVIEW_BASE:-$base}

merge_base=$(git merge-base HEAD "$base")
changed_files=$(git diff --name-only "$merge_base"..HEAD)
diff_content=$(git diff "$merge_base"..HEAD)
```

## Verified behaviour

| Repo state | On branch | Resolved base | Reviews |
|---|---|---|---|
| origin HEAD=main, `dev` exists | `feat/x` | `origin/dev` | only the feature's commits |
| origin HEAD=main, `dev` exists | `dev` | `origin/main` | everything queued for main |
| origin HEAD=dev, `dev` exists | `dev` | `origin/main` | everything queued for main |
| no `dev` branch | `feat/x` | `origin/main` | the feature's commits |
| `CE_REVIEW_BASE=origin/main` | `feat/x` | `origin/main` | override honoured |

## Rules

- **Always use the merge base**, never `git diff <base>..HEAD` against the branch tip — that reports changes made *on the base* as if they were yours.
- **Announce the resolved base** before spawning reviewers: `Reviewing <current> against <base> (N files)`. A wrong base is silent otherwise.
- **Empty `changed_files` is a stop condition**, not a clean review. Report it and ask; do not let reviewers return "clean" on nothing.
- **Pass `$base` and `$changed_files` into each reviewer's prompt.** Reviewers must not re-derive scope — that's how two reviewers end up reviewing different code.
- `CE_REVIEW_BASE` lets a repo with a different flow (e.g. `staging`, trunk-based) override without editing the commands.
