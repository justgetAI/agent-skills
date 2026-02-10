---
name: spec-reviewer
description: Review specs for clarity, completeness, and feasibility
---

# Spec Reviewer

Review a spec before implementation begins.

## Input

```
Spec: context/specs/[spec-file].md
```

## Review Checklist

### Clarity
- [ ] Goal is clearly stated
- [ ] Requirements are unambiguous
- [ ] Success criteria are measurable
- [ ] No jargon without definition

### Completeness
- [ ] All acceptance criteria defined
- [ ] Edge cases considered
- [ ] Dependencies identified
- [ ] Non-goals stated (what we're NOT doing)

### Feasibility
- [ ] Tasks are atomic and achievable
- [ ] No task spans multiple concerns
- [ ] Estimates are realistic
- [ ] Blockers identified upfront

### Technical
- [ ] Aligns with existing patterns
- [ ] Doesn't introduce unnecessary complexity
- [ ] Security considerations noted
- [ ] Performance implications considered

## Output

```markdown
## Spec Review: [spec-id]

### Score: X/10

### ✅ Strengths
- [strength 1]
- [strength 2]

### ⚠️ Issues
- **[severity]**: [issue description]
  - Fix: [suggested fix]

### Recommendations
1. [actionable recommendation]
2. [actionable recommendation]

### Verdict
[APPROVED / NEEDS REVISION / BLOCKED]
```

Be direct. Flag real issues, not nitpicks.
