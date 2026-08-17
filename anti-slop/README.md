# anti-slop

Opinionated Oxlint rules that reject low-evidence and low-signal TypeScript/JavaScript patterns — the kinds of shortcuts LLMs reach for when they can't prove a type: `unknown` params, chained casts, `Record<string, unknown>` bags, module mocking, `Reflect.get`.

Vendored from [dmmulroy/anti-slop](https://github.com/dmmulroy/anti-slop) (MIT, © Dillon Mulroy). Upstream's own guidance is that the plugin is **vendored, not depended on** — copy the rules in, read them, change them to match your standards.

## Install

```
/install-anti-slop
```

Or ask the agent to "install anti-slop in this repo". The skill copies the plugin to `tools/oxlint/anti-slop/`, installs current `oxlint` + `@oxlint/plugins`, merges the plugin into the existing lint config, enables all rules at `error`, and validates.

## Rules

| Rule | Rejects |
|---|---|
| `no-chained-type-assertions` | nested assertions that fabricate evidence (`x as object as User`) |
| `no-conditional-empty-object-spread` | `...(cond ? { a } : {})` field omission |
| `no-known-value-widening` | broad target types that discard known keys |
| `no-module-mocking` | `vi.mock` / `jest.mock` instead of real seams |
| `no-object-parameters` | the broad `object` type on inputs |
| `no-reflect-apply` | `Reflect.apply` over typed calls |
| `no-reflect-get` | `Reflect.get` over typed access / boundary parsing |
| `no-runtime-typeof` | ad hoc `typeof` narrowing instead of boundary parsing |
| `no-shape-in-symbol-names` | `Shape` in symbol names |
| `no-unknown-parameters` | `unknown` inputs (except the `cause` convention) |
| `no-unknown-returns` | `unknown` / `Promise<unknown>` return contracts |
| `no-unknown-type-aliases` | aliases that conceal `unknown` |
| `no-unsafe-dictionary-type` | `Record<string, unknown \| any \| object \| {}>` |
| `no-widen-then-assert` | widen a known value, assert it back later |
| `require-safety-comment-for-type-assertion` | assertions without a documented invariant |

Full violation examples: [upstream README](https://github.com/dmmulroy/anti-slop#violation-examples).

## Code review integration

The `context-engineering` plugin spawns an `anti-slop-reviewer` in Phase 4 of `/lets-ship` and in `/review`. It runs `oxlint` on the diff when anti-slop is installed, and falls back to reviewing changed TS/JS against the same rules as heuristics when it isn't. Findings are **advisory** — they never block the ship gate.

## Updating from upstream

```bash
git clone --depth 1 https://github.com/dmmulroy/anti-slop /tmp/anti-slop
rsync -a --delete /tmp/anti-slop/skills/install-anti-slop/ anti-slop/skills/install-anti-slop/
```

Re-check the rule list in this README and in `context-engineering/agents/anti-slop-reviewer.md` if upstream adds or renames rules.
