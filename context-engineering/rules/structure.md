# Directory Structure

```
context/
├── foundation/      # Human-authored source of truth (+ compound appends gotchas/workflows)
├── specs/           # Feature/fix/improve definitions (YYYY-MM-DD-<type>-<name>.md)
└── tasks/           # Atomic implementation units

docs/
└── solutions/       # Captured learnings from /compound
```

## Foundation
- Human-authored docs that define project context
- Agents read; `/compound` may append to gotchas/workflows/conventions
- Examples: architecture decisions, API contracts, business rules

## Specs
- Define what needs to be built
- One spec = one feature/fix/improvement
- Contains requirements, acceptance criteria, technical notes
- Canonical name: `YYYY-MM-DD-<type>-<name>.md` (see [naming.md](naming.md))

## Tasks
- Atomic implementation units
- Derived from specs
- Agent-manageable with status tracking

## Solutions
- Written by `/compound` after features ship
- Primary retrieval target for `learnings-researcher`

## Legacy (unused)

These directories appear in older diagrams but **nothing in this pack writes to them**. Prefer `docs/solutions/` and `context/foundation/`. If they exist in a repo, treat as optional read-only leftovers:

```
context/learnings/       # legacy — do not create new files here
context/anti-patterns/   # legacy — do not create new files here
```

Run `scripts/init.sh` to scaffold the current structure (includes `docs/solutions/`).
