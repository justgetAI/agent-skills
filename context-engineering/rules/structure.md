# Directory Structure

```
context/
├── foundation/      # Human-authored source of truth
├── specs/           # Feature/fix/improve definitions
├── tasks/           # Atomic implementation units
├── learnings/       # Solved problems, patterns discovered
└── anti-patterns/   # What NOT to do
```

## Foundation
- Human-authored docs that define project context
- Agents read, never write directly
- Examples: architecture decisions, API contracts, business rules

## Specs
- Define what needs to be built
- One spec = one feature/fix/improvement
- Contains requirements, acceptance criteria, technical notes

## Tasks
- Atomic implementation units
- Derived from specs
- Agent-manageable with status tracking

Run `scripts/init.sh` to scaffold this structure.
