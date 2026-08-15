---
name: prompt-engineering
description: Write and improve prompts for any LLM. Use when drafting a system prompt, debugging a prompt that returns wrong or inconsistent output, choosing between few-shot / chain-of-thought / RAG / chaining, structuring long-context inputs, or reviewing someone else's prompt. Distilled from the five reference guides (DAIR.AI, Anthropic, OpenAI, Learn Prompting, Google Vertex AI) down to what all of them agree on.
compatibility: Claude Code, Cursor, Gemini CLI, or any markdown-instruction agent
license: MIT
metadata:
  author: justgetAI
  version: "1.0"
---

# Prompt Engineering

Five major guides, one set of agreements. This skill is that intersection —
the practices every source teaches — plus the few high-value techniques only
one source teaches, marked with who says so.

## The rule that outranks the rest

**A prompt is not better because it reads better. It is better because it
scored better.**

Anthropic puts this before any technique: you need a definition of success and
a way to test against it *before* you start tuning wording. Google frames the
same thing as "compare prompts" and iterate. DAIR.AI frames it as "start
simple, iterate."

So the loop is always:

1. Write down what a good output looks like — concretely enough to grade.
2. Collect 10+ real inputs, including the ones that currently fail.
3. Change **one thing**, re-run, compare. A win you can't attribute is noise.
4. Keep a log of what you tried and what it scored.

If you skip this, you are not doing prompt engineering, you are doing
superstition. Everything below is how to spend your attempts well.

---

## The skeleton

All five sources describe the same anatomy under different names. DAIR.AI
calls the pieces *instruction, context, input data, output indicator*; OpenAI
orders a developer message as *identity, instructions, examples, context*;
Anthropic wraps each piece in its own XML tag. Write in this order:

```xml
<role>
You are a <specific role>. <One sentence on purpose and tone.>
</role>

<instructions>
1. <Imperative step. Numbered when order or completeness matters.>
2. <...>
</instructions>

<context>
<Why this matters, who reads the output, constraints, domain background.>
</context>

<examples>
  <example>
    <input>...</input>
    <output>...</output>
  </example>
  <!-- 3-5 of these -->
</examples>

<output_format>
<Exactly what shape to return. Schema, length, sections, tone.>
</output_format>

<input>
{{THE_ACTUAL_TASK}}
</input>
```

Not every prompt needs every block. Drop what doesn't earn its tokens — DAIR.AI
warns explicitly against detail that doesn't serve the task.

**One exception to the order, and it is important.** When the input is large
(Anthropic says 20k+ tokens), the long data goes at the **top** and the query
at the **bottom**. See *Long context* below.

---

## The seven agreements

Every one of the five sources teaches these. If you do nothing else, do these.

### 1. Lead with the instruction, and make it a verb

Start with the command — *Write, Classify, Summarize, Extract, Rank* — not with
throat-clearing. DAIR.AI: put the instruction at the beginning and separate it
from the context with a delimiter.

### 2. Be specific; adjectives are not specifications

"Short" and "simple" are not instructions. "Three sentences, for a reader who
has never used the product" is. DAIR.AI names this *avoid impreciseness*;
Anthropic's golden rule is the same test from the other side:

> Show your prompt to a colleague with minimal context and ask them to follow
> it. If they'd be confused, the model will be too.

### 3. Say what to do, not what not to do

Universal across sources. `Do not use markdown` steers worse than
`Write in flowing prose paragraphs`. Negation gives the model a thing to
attend to but no target to move toward. When you catch yourself writing
"don't", rewrite it as the positive behaviour you actually want.

### 4. Delimit every kind of content

Instructions, context, examples and the user's raw input must be visually and
structurally separable. Anthropic prefers XML tags (`<instructions>`,
`<document>`) and recommends consistent, descriptive names and nesting for
hierarchy. OpenAI recommends Markdown headers for hierarchy plus XML tags for
boundaries and metadata. DAIR.AI uses `###`. Any of these work; **using none
of them is the failure mode.** It is also your only defence when untrusted
text is interpolated into the prompt.

### 5. Show 3–5 examples, relevant and diverse

Few-shot is the most reliable lever on format, tone and structure. Anthropic's
criteria for a good example set:

- **Relevant** — mirrors the real use case.
- **Diverse** — covers edge cases, and varies enough that the model doesn't
  latch onto an accidental pattern (all your examples starting with "The").
- **Structured** — wrapped in `<example>` tags so they can't be mistaken for
  instructions.

Three to five is the sweet spot. You can ask the model to critique your example
set for relevance and diversity, or to generate more from your seeds.

### 6. Give the reason, not just the rule

The one Anthropic emphasises hardest and the cheapest upgrade available:

> `NEVER use ellipses`
> → `Your response will be read aloud by a text-to-speech engine, so never use
> ellipses since the engine will not know how to pronounce them.`

The model generalises from the explanation to cases your rule didn't cover.
Google's "add contextual information" is the same instinct. Whenever you write
a constraint, ask whether one clause of *why* would let it generalise.

### 7. Name the output shape

Say the format, length, and structure. If it's machine-read, give the schema
and say "return only that". If it's human-read, say the sections and the tone.
Unspecified format is the single most common cause of "it works but I can't
parse it".

---

## Choosing a technique

Reach past a plain instruction only when the plain instruction fails, and reach
for the cheapest thing that fixes it. Techniques are catalogued by DAIR.AI;
the *when* column is the practical filter.

| Technique | Use it when |
|---|---|
| **Zero-shot** | The task is common and well-named. Always try this first. |
| **Few-shot** | Output format, tone or edge-case handling is inconsistent. |
| **Chain-of-thought** | Multi-step reasoning, arithmetic, or the model jumps to a wrong answer confidently. Ask for the steps before the answer. |
| **Self-consistency** | High-stakes reasoning where one sample is unreliable. Sample several paths, take the majority. |
| **Generate-knowledge** | Factual accuracy is the failure, not reasoning. Have the model state what it knows first. |
| **Prompt chaining** | The task has genuinely separate stages, or you need to inspect/log/branch on intermediate output. |
| **Tree of thoughts** | The solution space needs exploring, not just walking. Expensive; last resort. |
| **RAG** | The answer depends on facts outside the model — private data, anything recent. The main anti-hallucination lever. |
| **ReAct / tool use** | The task needs to act on the world (search, run code, call an API), not just reason. |
| **Reflexion / self-correction** | Quality lifts on a second pass. Draft → critique against explicit criteria → revise. Anthropic notes this is the most common chaining pattern. |

**Decompose before you escalate.** Every source says it — Google "break down
complex tasks", DAIR.AI "break into simpler subtasks", Anthropic chains for
pipeline structure. A prompt that fails is often two prompts that would each
succeed.

**One note on modern reasoning models:** Anthropic points out that with
adaptive thinking, much multi-step reasoning now happens internally, so
explicit chaining earns its keep mainly when you need to *inspect* or *enforce*
the pipeline, not to unlock the reasoning itself.

---

## Long context

For large or multi-document inputs, structure beats wording.

- **Long data at the top, query at the bottom.** Anthropic measures up to a
  **30% quality improvement** from putting the query last on complex
  multi-document inputs. This is the highest-leverage single edit on the page.
- **Wrap each document in tags with metadata:**

  ```xml
  <documents>
    <document index="1">
      <source>annual_report_2023.pdf</source>
      <document_content>{{ANNUAL_REPORT}}</document_content>
    </document>
  </documents>
  ```

- **Make it quote first.** Ask the model to pull the relevant passages into
  `<quotes>` tags *before* doing the task. It focuses attention on the relevant
  span and gives you a citation trail to audit.

---

## Controlling output format

Ordered by how well they work (Anthropic):

1. **Tell it what to do instead of what not to do** — the positive-framing rule
   again, and it bites hardest here.
2. **Use an XML format indicator** — "write the prose in
   `<smoothly_flowing_prose_paragraphs>` tags".
3. **Match your prompt's style to the output you want** — a prompt written in
   heavy markdown produces heavy markdown. Strip the formatting from your
   prompt and you strip it from the response.
4. **Be explicit and detailed for strong preferences** — a dedicated
   `<formatting>` block spelling out exactly when lists are and aren't allowed.

---

## Prompts are code

From OpenAI's guidance, and it's the part teams skip:

- **Store prompts in version control**, with typed inputs and tests, deployed
  through the normal pipeline. Not as loose strings in a UI.
- **Pin the model version** in production. An unpinned model means your prompt
  silently changes behaviour underneath you.
- **Know your context budget** and structure for it.

---

## Prompting agents that write code

The failure modes are different once the model has tools. These are Anthropic's
recommended counter-prompts; each addresses a measured behaviour.

**Scope creep / over-engineering** — the model adds abstractions, config and
error handling nobody asked for:

> Avoid over-engineering. Only make changes that are directly requested or
> clearly necessary. Don't add features, refactor, or make "improvements"
> beyond what was asked. Don't add error handling or validation for scenarios
> that can't happen. Don't create abstractions for one-time operations. The
> right amount of complexity is the minimum needed for the current task.

**Gaming the tests** — passing the suite instead of solving the problem:

> Implement a solution that works correctly for all valid inputs, not just the
> test cases. Do not hard-code values. Tests verify correctness, they do not
> define the solution. If the task is infeasible or a test is wrong, tell me
> rather than working around it.

**Speculating about code it hasn't read:**

> Never speculate about code you have not opened. If the user references a
> specific file, read it before answering. Investigate before making any claim
> about the codebase.

**Scratch files left behind:**

> If you create temporary files or scripts for iteration, remove them at the
> end of the task.

---

## Debugging a prompt

| Symptom | First thing to change |
|---|---|
| Output format keeps drifting | Add 3–5 examples; state the schema; use an XML format indicator |
| Right format, wrong content | Add context and the *why*; tighten the role |
| Confidently wrong on multi-step work | Ask for reasoning before the answer; decompose into a chain |
| Makes facts up | Ground it — RAG, or quote-from-source-first, or "say you don't know" |
| Ignores a rule you wrote | You probably wrote it as a negation. Rewrite as the positive behaviour |
| Ignores instructions in a long prompt | Move the long data to the top and the query to the bottom |
| Inconsistent across runs | Few-shot for format; self-consistency for reasoning; lower temperature |
| Too verbose | Ask for the length explicitly; strip markdown from your own prompt |
| Untrusted input changes behaviour | Delimit it in tags and say the tagged content is data, not instructions |

---

## Review checklist

Before shipping a prompt:

- [ ] Success criteria written down, and a test set that can grade against them
- [ ] Instruction leads, and it starts with a verb
- [ ] Every constraint is specific — no "short", "good", "professional" alone
- [ ] Every rule is phrased as what to do
- [ ] At least one rule carries its *why*
- [ ] Instructions, context, examples and input are separately delimited
- [ ] 3–5 examples, relevant and diverse, if format matters
- [ ] Output shape stated exactly
- [ ] Long inputs at the top, query at the bottom
- [ ] Untrusted interpolated text is tagged as data
- [ ] Model version pinned; prompt in version control
- [ ] One change per iteration, scored against the last

---

## Sources

Cross-referenced 2026. Where only one guide makes a claim, it's attributed
inline above.

- **DAIR.AI Prompt Engineering Guide** — <https://www.promptingguide.ai/> —
  broadest technique catalogue; best starting point.
- **Anthropic** — <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices>
  — strongest on XML structuring, long context, evals-first, agentic failure modes.
- **OpenAI** — <https://developers.openai.com/api/docs/guides/prompt-engineering>
  — message roles, developer-message ordering, prompts-as-code.
- **Learn Prompting** — <https://learnprompting.org/> — structured
  beginner-to-advanced course.
- **Google Vertex AI** — <https://docs.cloud.google.com/vertex-ai/generative-ai/docs/learn/prompt-best-practices>
  — prompt design strategies, decomposition, parameter tuning, multimodal.
