# prompt-engineering

One operational guideline distilled from the five most-recommended prompt
engineering references: DAIR.AI's Prompt Engineering Guide, Anthropic's Claude
prompting best practices, OpenAI's prompt engineering guide, Learn Prompting,
and Google's Vertex AI prompt design strategies.

It keeps what all five agree on, marks what only one of them teaches, and turns
the result into things you can actually check: a prompt skeleton, seven rules,
a technique-selection table, a symptom→fix table, and a pre-ship checklist.

## Install

```bash
claude plugin marketplace add justgetAI/agent-skills
claude plugin install prompt-engineering@justgetai-tools
```

Or copy `SKILL.md` into any agent's instruction path — it stands alone.

## Use it when

Drafting a system prompt, debugging output that is wrong or inconsistent,
choosing between few-shot / chain-of-thought / RAG / chaining, structuring
long-context inputs, or reviewing someone else's prompt.
