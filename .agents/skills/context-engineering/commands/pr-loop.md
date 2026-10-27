---
name: pr-loop
description: Ship a finished branch through PR → bot review → dev merge → live verify → gated main merge. Phases 6–8 of /lets-ship; runs standalone on any built branch.
argument-hint: "[--auto]"
---

# pr-loop — PR to Main, Gated

Ship the current branch: **PR → babysit bots → fix → merge dev → live verify → gated main merge.** Never skip a stage. Never merge main without the report + explicit user approval.

`/lets-ship` runs this as Phases 6–8. Run `/pr-loop` directly when the branch is already built.

## Modes

- **Default (full-stop)** — stop for the user before the dev merge and before the main merge.
- **`--auto` (full-send)** — runs unattended through the dev merge and live verify. **Never merges main**; Phase 8 always waits for the user.
- **Money repos** — if `context/foundation/conventions.md` contains `ship-mode: full-stop`, `--auto` is ignored for Phases 6–8.

## Base Branch

Resolve `base` and `default` with [review-base.md](../references/review-base.md), then strip the `origin/` prefix. Feature branches target `dev` when it exists, otherwise the default branch. Never run bare `gh pr create` — it targets the default branch and skips dev. Never hardcode `main` — use `$default`.

Two paths, fixed by `base`:

| `base` | Phase 7 merges? | SHA under test (`verified_sha`) | Phase 8 merges |
|---|---|---|---|
| `dev` | yes, into dev | `git rev-parse origin/dev` after the merge | a new `dev → $default` PR |
| `$default` (no dev, or running on `dev` itself) | **no** — the PR targets the default branch, so merging it is Phase 8 | `gh pr view <n> --json headRefOid -q .headRefOid` | this PR |

---

## Phase 6: PR + Bot Loop

### 6.1 Open PR

```bash
git push -u origin HEAD
gh pr create --base "$base" --title "<type>(<scope>): <summary>" --body-file <body>
```

Body, problem-first: **Problem** (what is broken or missing, why it matters) → **Change** (what this PR does) → **Env / migration steps** (or "none"). No AI attribution in commits or the PR body.

### 6.2 Wait for Bots

Review bots post comments, not checks — wait for both.

```bash
gh pr checks <n> --watch                                   # CI
gh pr view <n> --json comments,reviews                     # top-level + review bodies
gh api repos/{owner}/{repo}/pulls/<n>/comments             # inline comments (top-level misses these)
```

Done = all checks concluded AND each review bot the repo uses has posted on the current head (or the repo has none — verify, don't assume). Not done by 15 min: check once more, then tell the user what is still pending instead of looping.

### 6.3 Triage Findings

- **Work queue = findings newer than the last push.** Every older finding must already have a disposition (fixed, or a written dismissal) — never drop one silently.
- **Verify before acting or dismissing.** Bots are often wrong. For Must-Fix-tier claims, spawn `context-engineering:finding-verifier` with the claim only (file + one sentence), as in `/lets-ship` 4.4.
- **Push back on wrong findings.** Reply on the thread with evidence (`file:line`, test output). Decline nits that don't change behavior.
- **Written dismissals.** Every declined finding gets a one-line reply: why, with evidence.
- **Fight scope creep.** Out-of-scope findings → separate task or PR, noted on the thread. Not this branch.

Agent-posted PR comments (dismissals, verdicts) end with a callout footer:

```
— <model> via <harness> (agent comment)
```

### 6.4 Fix Loop

Push real fixes to the SAME branch, then return to 6.2.

**Budget: 3 bot rounds** (5 if the PR touches auth, payments, secrets, or carries a security label). Budget spent with real findings open → stop and ask the user. This is separate from `/lets-ship`'s 2 internal review iterations.

**Gate (default mode):** "PR green, findings dispositioned. Merge to `<base>`?"

---

## Phase 7: Merge Dev + Live Verify

### 7.1 Merge

**Only when `base` is `dev`.** A PR targeting `$default` is never merged here — skip to 7.2 and verify the PR head (or its preview env); merging it is Phase 8.

```bash
gh pr view <n> --json mergeStateStatus   # must not be BEHIND or DIRTY — rebase/update first
gh pr merge <n> --merge                  # merge commits, never squash
```

### 7.2 Fresh Verifier

Live-test by a **fresh agent that did not write the code**. Spawn one general-purpose subagent with only: PR number, SHA under test (`verified_sha`, see Base Branch), the changed behavior in one line, and the project run/QA skill if one exists. It exercises real behavior (deployed dev env, simulator, real endpoint) — not just unit tests — and returns `PASS`, `PASS+NOTES`, or `FAIL` with every test run and its raw output.

Empty or "should work" report = `FAIL`. Redispatch once, then surface to the user.

### 7.3 Record Verdict

`gh pr comment <n>` with: verdict, exact SHA tested, tests + results, verdict footer (6.3). The record outlives the chat.

`FAIL` → fix on a new branch, restart at Phase 6. Author self-verification, CI green, and bot approval are not verdicts.

---

## Phase 8: Gated Main Merge

**HARD GATE — `--auto` never passes it. Merge main only with all three:**

1. **Report posted to the user:**
   - **Tests carried out** — every test from all phases, with real results
   - **Summary of changes** — brief
   - **Files touched** — each file + one-line purpose
2. **Explicit user approval** after the report.
3. **SHA still matches.** Re-derive `verified_sha` the same way (`git fetch && git rev-parse origin/dev`, or the PR's `headRefOid`); it must equal the SHA in the 7.3 verdict. Different → verdict is void; back to 7.2 on the new head.

Then, `base` = `dev`:

```bash
gh pr create --base "$default" --head dev --title "release: <summary>" --body-file <report>
gh pr view <m> --json mergeStateStatus   # not BEHIND or DIRTY
gh pr merge <m> --merge
git checkout dev && git pull --ff-only   # repo ends on dev
```

`base` = `$default`: check `mergeStateStatus` on the PR itself, then `gh pr merge <n> --merge`, and end on `dev` if it exists, otherwise `$default`.

---

## Red Flags — Stop

- "Checks are green so bots must be done" → bots post comments, not checks. Confirm both.
- "Unit tests passed, that's the live test" → it isn't. Phase 7 means real behavior.
- "I tested it myself" → author verdicts don't count.
- "Verdict was PASS an hour ago" → only if a re-derived `verified_sha` still matches the verdict SHA.
- "`--auto` is on, I'll merge main too" → Phase 8 is always the user's call.
- "The bot said so" → verify against the source first.
- Merged main and moved on → repo must end on dev (or the default branch when there is no dev).
