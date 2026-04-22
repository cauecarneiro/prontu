# Model Routing Matrix

> Detailed reference for cost-aware model routing.
> For the quick version, see the parent [SKILL.md](../SKILL.md).

## Core Principle

> Route every task to the **cheapest model tier** that can reliably complete it.
> This is not about saving money — it's about **building a cost signal** that
> helps you understand your workflow's complexity profile.

## Full Decision Matrix

### Haiku — Fast, Cheap, Narrow

**Use when:** The task has a well-defined input/output, narrow scope, and doesn't require multi-step reasoning.

| Task Type | Examples |
|---|---|
| Classification | Categorize error messages, label data, triage issues |
| Boilerplate transforms | Generate repetitive code from patterns, rename variables |
| Narrow edits | Fix a typo, update a string, change a constant |
| Formatting | Reformat code, convert between data formats |
| Simple extraction | Pull values from structured text, parse logs |
| Doc generation | Generate docstrings, comments, simple README sections |

**Token budget:** Typically < 2K input, < 1K output.

### Sonnet — Balanced, Capable, Versatile

**Use when:** The task requires multi-step reasoning within a single domain or moderate scope.

| Task Type | Examples |
|---|---|
| Feature implementation | Build a new view, add an endpoint, create a model |
| Refactors | Extract method, redesign a class, simplify logic |
| Test writing | Generate comprehensive test cases with edge cases |
| Bug debugging | Analyze stack traces, trace data flow, fix logic errors |
| Code review | Review a PR diff for logic issues, suggest improvements |
| Documentation | Write detailed technical docs with code examples |

**Token budget:** Typically < 8K input, < 4K output.

### Opus — Powerful, Expensive, Strategic

**Use when:** The task spans multiple files/systems, has ambiguous scope, or requires architectural judgment.

| Task Type | Examples |
|---|---|
| Architecture design | Design system boundaries, define API contracts |
| Root-cause analysis | Trace complex bugs across multiple modules |
| Multi-file invariants | Ensure consistency across a codebase |
| Security review | Audit auth flows, identify vulnerability patterns |
| Complex planning | Break down large features, design migration strategies |
| Ambiguous problems | Tasks where the approach itself is unclear |

**Token budget:** Typically < 32K input, < 8K output.

## Escalation Decision Flow

```
┌──────────────────────────────────┐
│ New Task                         │
└──────────┬───────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ Is this a simple transform,     │
│ classification, or narrow edit? │
├──────── YES ─────────────────────┤──→ Use HAIKU
│         NO                       │
└──────────┬───────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ Does this require multi-step    │
│ reasoning in a single domain?   │
├──────── YES ─────────────────────┤──→ Use SONNET
│         NO                       │
└──────────┬───────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ Does this span multiple systems │
│ or require architectural        │
│ judgment?                        │
├──────── YES ─────────────────────┤──→ Use OPUS
│         NO                       │
└──────────┬───────────────────────┘
           │
           ▼
      Start with SONNET
      (safe default)
```

## Escalation Rules

### When to Escalate

Escalate to the next tier **only** when the current tier fails with a **clear reasoning gap**.

**What is a reasoning gap?**
- The model produces structurally wrong output (not just a minor error).
- The model cannot hold the full context needed to solve the problem.
- The model makes incorrect assumptions about system behavior.
- The model fails to connect information across distant parts of the input.

### What is NOT a reasoning gap?

- A typo or syntax error → retry at the same tier.
- An off-by-one error → add a clarifying constraint and retry.
- A hallucinated API → provide the correct API reference and retry.

### Escalation Log

When you escalate, record it:

| Field | Value |
|---|---|
| Task | _description_ |
| Original tier | _e.g., Haiku_ |
| Escalated to | _e.g., Sonnet_ |
| Reason | _specific reasoning gap observed_ |
| Retries before escalation | _count_ |

## Cost Comparison Reference

| Tier | Relative Cost | Speed | Best For |
|---|---|---|---|
| Haiku | 1x (baseline) | ⚡ Fastest | Volume tasks, boilerplate |
| Sonnet | ~5x | ⚡ Fast | Core implementation |
| Opus | ~25x | 🐢 Slower | Strategic decisions |

> **Rule of thumb:** If 80% of your tasks use Opus, you're either working on
> very complex problems or you're not decomposing enough.
