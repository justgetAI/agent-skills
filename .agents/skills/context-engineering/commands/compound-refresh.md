---
name: compound-refresh
description: Audit docs/solutions/ for stale, overlapping, or superseded learnings (design stub)
argument-hint: "[optional path, defaults to docs/solutions]"
---

# compound-refresh — Audit Captured Solutions

> **Status: design stub.** Behavior is specified here so agents and humans share intent.
> A full port of EveryInc's `/ce-compound-refresh` is **not** implemented yet.
> Prefer running this manually (or completing the port) once `docs/solutions/` has grown
> enough that overlap is a real cost — see PR notes for ship-now vs later.

## Goal

Keep `/compound` from becoming an append-only junk drawer. Review existing solution docs and recommend: **Keep / Update / Consolidate / Replace / Delete**.

## Scope (in)

- `docs/solutions/**/*.md` (primary)
- Cross-check claims against current code when a doc cites paths or APIs
- Optional: related snippets in `context/foundation/gotchas.md` / `workflows.md` that duplicate a solution

## Scope (out)

- **No product-code edits** — docs and foundation prose only
- Do not invent writers into `context/learnings/` or `context/anti-patterns/`
- Do not auto-delete without an explicit human confirmation gate
- Do not rewrite specs under `context/specs/`

## Input

<solutions_root>$ARGUMENTS</solutions_root>

**Default:** `docs/solutions`

If the directory is missing or empty: report "Nothing to refresh" and stop.

---

## Process (intended)

### 1. Inventory

```bash
ls -1 docs/solutions/*.md 2>/dev/null
```

Collect title, date, tags, and a one-line summary per file.

### 2. Worth audit (steal from Every CE)

For each doc, ask the durable-bar counterfactual:

> Would an agent recover this lesson from code, tests, or existing foundation docs alone?

If yes → candidate for **Delete** or fold a one-liner into foundation, then remove the dossier.
If no → keep in the refresh set.

### 3. Overlap & supersession

Cluster by topic/tags. For each cluster, classify pairs:

| Verdict | When |
|---------|------|
| **Keep** | Unique, still true, cited or clearly useful |
| **Update** | Core lesson holds; paths/APIs/examples drifted |
| **Consolidate** | Two+ docs teach the same lesson → merge into one |
| **Replace** | Newer doc fully supersedes an older one |
| **Delete** | Wrong, obsolete, or recoverable from the tree |

### 4. Grounding check (lightweight)

For docs that name files or APIs: spot-check the tree. Mark **Update** when examples no longer compile or paths moved.

### 5. Report + gate

Present a table to the human:

```markdown
## Compound Refresh Report

| Doc | Verdict | Reason |
|-----|---------|--------|
| 2026-01-10-stripe-webhooks.md | Keep | Still unique; matches current webhook handler |
| 2026-02-01-idempotency.md | Consolidate | Overlaps 2026-01-10-… |
| 2026-03-15-old-sdk.md | Delete | SDK removed; recoverable from code |

**Proposed actions:** …
Proceed? (yes / edit / abort)
```

Only after confirmation: apply doc edits (merge, update frontmatter, delete files). Commit message should list verdicts.

---

## What to steal from EveryInc `/ce-compound-refresh`

- Keep / Update / Consolidate / Replace / Delete taxonomy
- Durable-bar / worth filter before spending tokens on refresh
- Grounding against the live tree
- Human confirmation before destructive doc changes

## What to leave out (for now)

- Product-code patches or refactors triggered by stale docs
- Auto-install of Compound Packs / plugin config YAML
- Mandatory run after every `/compound` (too noisy until volume hurts)
- Full schema/`schema.yaml` validation machinery — optional later if frontmatter drifts

## Relationship to `/compound`

| Command | Role |
|---------|------|
| `/compound` | **Write** one learning after a feature |
| `/compound-refresh` | **Curate** the store so retrieval stays cheap |

`rules/learnings.md` and `/compound`'s weekly ritual should point here once this stub is implemented end-to-end.

---

## Done when (for a future full implementation)

- [ ] Inventory + clustering implemented as an agent procedure (this file is enough to run by hand today)
- [ ] Worth-audit gate documented and enforced
- [ ] No code edits outside docs/foundation
- [ ] Explicit confirm before Delete / Consolidate
- [ ] Optional: link from `/compound` Compound Ritual step 2
