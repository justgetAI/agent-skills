# Contributing

## Adding a New Skill

1. Create a directory: `skill-name/`
2. Add required file: `SKILL.md` with valid frontmatter
3. Add optional: `scripts/`, `references/`, `assets/`, `README.md`
4. Open a PR

### SKILL.md Frontmatter

Required fields:
```yaml
---
name: skill-name
description: What the skill does and when to use it. Max 1024 chars.
---
```

Optional fields:
```yaml
---
name: skill-name
description: ...
compatibility: Claude Code, Cursor, etc.
license: MIT
metadata:
  author: your-org
  version: "1.0"
---
```

### Naming Rules

- Lowercase letters, numbers, hyphens only
- No consecutive hyphens
- Must not start/end with hyphen
- Directory name must match `name` field

### Best Practices

- Keep SKILL.md under 500 lines
- Move detailed docs to `references/`
- Include working examples in `assets/`
- Test with multiple agent environments if possible

## Bug Reports / Feature Requests

Open an issue with:
- What you expected
- What happened
- Steps to reproduce (if bug)

## Code of Conduct

Be kind. Keep it professional.
