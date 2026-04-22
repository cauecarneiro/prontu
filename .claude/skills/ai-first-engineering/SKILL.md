---
name: ai-first-engineering
version: 1.0.0
description: >-
  Engineering operating model for teams where AI agents generate most
  implementation output. Covers process shifts, agent-friendly architecture,
  code review strategy, hiring signals, and testing standards.
  Use this skill when designing team processes, reviewing AI-generated code,
  defining architecture for agent workflows, or evaluating engineering talent.
  Keywords: AI-first, engineering culture, code review, architecture,
  agent-friendly, testing standards, hiring, process design.
---

# AI-First Engineering

Use this skill when designing process, reviews, and architecture for teams shipping with AI-assisted code generation.

## When to Apply

Use this AI-first engineering skill for **any** of the following:

- Designing or evolving team processes for AI-assisted development.
- Defining architecture requirements that enable agent workflows.
- Establishing code review standards for AI-generated code.
- Evaluating or hiring engineers for AI-first teams.
- Setting testing standards for codebases with high agent-generated output.
- Transitioning a team from traditional to AI-first workflows.

## Process Shifts

> In AI-first teams, the engineer's value shifts from **writing code** to
> **defining intent, evaluating output, and enforcing quality**.

### The Three Shifts

| # | Traditional | AI-First | Implication |
|---|---|---|---|
| 1 | Typing speed matters | **Planning quality** matters | Invest time in clear specs, decomposition, and evals before execution |
| 2 | Anecdotal confidence | **Eval coverage** matters | Replace "it works on my machine" with measurable, repeatable evals |
| 3 | Review syntax & style | **Review system behavior** | Linters handle style; humans review invariants, security, and edge cases |

### Anti-Patterns

- ❌ "Let the AI figure it out" — vague prompts produce vague code.
- ✅ Write a clear spec with acceptance criteria, then delegate to agent.

- ❌ "I read through it and it looks fine" — anecdotal review of AI output.
- ✅ Run evals and regression checks; review only what automation can't catch.

- ❌ "We don't need tests, the AI generated it correctly" — blind trust.
- ✅ AI-generated code needs **more** testing, not less.

## Architecture Requirements

> Prefer architectures that are **agent-friendly** — easy for AI to understand,
> modify, and test in isolation.

For detailed patterns, see [references/agent-friendly-architecture.md](references/agent-friendly-architecture.md).

### Agent-Friendly Checklist

- [ ] **Explicit boundaries** — Clear module/layer separation with defined interfaces.
- [ ] **Stable contracts** — APIs and data contracts that change infrequently.
- [ ] **Typed interfaces** — Strong typing at boundaries to catch errors at compile time.
- [ ] **Deterministic tests** — Tests that produce the same result every run (no flakes).
- [ ] **Minimal implicit behavior** — No magic conventions, hidden side effects, or ambient state.

### Agent-Friendly vs. Agent-Hostile

| Agent-Friendly ✅ | Agent-Hostile ❌ | Why |
|---|---|---|
| Explicit dependency injection | Global singletons | Agent can't reason about hidden state |
| Protocol-based contracts | Convention-based dispatch | Agent needs to see the interface, not guess it |
| Pure functions with clear I/O | Functions with side effects | Agent can eval pure functions in isolation |
| Modular, single-responsibility files | God files with 1000+ lines | Agent context window overflows |
| Schema-validated configs | Free-form dictionaries | Agent can validate inputs programmatically |
| Typed enums for states | Magic strings | Agent gets compile-time feedback |

### Architecture Decision Template

When choosing between architectural approaches, evaluate:

| Criteria | Option A | Option B |
|---|---|---|
| Agent can modify in isolation? | _yes/no_ | _yes/no_ |
| Changes require touching >2 files? | _yes/no_ | _yes/no_ |
| Testable without full system? | _yes/no_ | _yes/no_ |
| Clear interface boundary? | _yes/no_ | _yes/no_ |

> Prefer the option that is more agent-modifiable, even if it adds slight verbosity.

## Code Review in AI-First Teams

> Focus review effort on what **only humans** can judge: system-level reasoning,
> security assumptions, and invariant correctness.

For the complete checklist, see [references/ai-code-review-guide.md](references/ai-code-review-guide.md).

### Review Priority Matrix

| Priority | Area | What to Look For |
|---|---|---|
| 🔴 Critical | **Behavior regressions** | Does this change break existing functionality? |
| 🔴 Critical | **Security assumptions** | Are auth, permissions, and secrets handled correctly? |
| 🔴 Critical | **Data integrity** | Are transactions atomic? Are race conditions possible? |
| 🟡 Important | **Failure handling** | Are all error paths explicit? Are resources cleaned up? |
| 🟡 Important | **Rollout safety** | Can this deploy incrementally? Is rollback possible? |
| 🟡 Important | **Hidden coupling** | Does this change affect other modules unexpectedly? |
| 🟢 Low | **Style consistency** | ⚠️ Automate this — do not review manually |

### Review Anti-Patterns

| Anti-Pattern | Problem | Fix |
|---|---|---|
| Reviewing every line equally | Wastes time on low-risk areas | Use priority matrix — focus on 🔴 first |
| Nitpicking style | Already covered by linters | Trust automation, review logic |
| Rubber-stamping AI output | "AI wrote it, must be fine" | AI is most likely wrong on edge cases and security |
| Rewriting instead of guiding | Reviewer rewrites the code themselves | Give specific feedback, let agent re-implement |
| Reviewing without running | Missing runtime behavior issues | Always run tests and evals before approving |

## Hiring and Evaluation Signals

> In AI-first teams, the best engineers are **orchestrators**, not just **implementers**.

For interview rubrics, see [references/hiring-rubric.md](references/hiring-rubric.md).

### Core Competencies

| Competency | What It Looks Like | How to Evaluate |
|---|---|---|
| **Decomposition** | Breaks ambiguous work into clear, agent-sized units | Give a vague feature request; assess the breakdown |
| **Acceptance criteria** | Defines measurable "done" conditions before starting | Ask "how would you know this feature is complete?" |
| **Prompt engineering** | Produces high-signal prompts that reduce retries | Review prompt quality and iteration count |
| **Eval design** | Creates meaningful evals, not just happy-path tests | Ask for evals that cover edge cases and regressions |
| **Risk judgment** | Enforces quality controls under delivery pressure | Present a "ship fast vs. ship safe" scenario |

### Red Flags in AI-First Engineers

- ❌ Cannot articulate acceptance criteria before starting.
- ❌ Trusts AI output without verification.
- ❌ Writes prompts that are vague or context-free.
- ❌ Cannot explain the "why" behind AI-generated code they submitted.
- ❌ Skips tests because "the AI got it right."

### Green Flags

- ✅ Writes eval before implementation.
- ✅ Decomposes large tasks without being asked.
- ✅ Questions AI output at system boundaries and edge cases.
- ✅ Can switch between model tiers based on task complexity.
- ✅ Maintains cost awareness across their work.

## Testing Standard

> AI-generated code requires a **higher** testing bar, not lower.
> The agent doesn't understand your system — tests are how you verify it didn't break anything.

For detailed testing patterns, see [references/testing-standards.md](references/testing-standards.md).

### Testing Requirements by Change Type

| Change Type | Required Coverage |
|---|---|
| New feature / module | Capability tests + regression tests for adjacent modules |
| Bug fix | Reproduction test (fails before fix, passes after) |
| Refactor | Full regression suite for refactored module must pass |
| API / contract change | Contract tests + integration tests for all consumers |
| Performance-sensitive change | Benchmark tests with acceptable thresholds |

### Testing Checklist

- [ ] **Regression coverage** for every touched domain.
- [ ] **Explicit edge-case assertions** (nil, empty, max, negative, unicode).
- [ ] **Integration checks** at interface boundaries.
- [ ] **Error path tests** — verify failure behavior, not just success.
- [ ] **No flaky tests** — every test must be deterministic.

### Testing Anti-Patterns

| Anti-Pattern | Problem | Fix |
|---|---|---|
| Happy-path only | Misses failures, edge cases, and error paths | Add explicit edge-case and error-path tests |
| Testing implementation | Tests break on refactor even when behavior is unchanged | Test behavior and outputs, not internal structure |
| AI-generated tests without review | Tests may assert wrong behavior or be too shallow | Review test logic with same rigor as production code |
| Shared mutable state | Tests interfere with each other, causing flakes | Fresh state per test; no shared mutables |
| Slow unit tests (>1s each) | Breaks fast feedback loop | Mock I/O, network, and persistence |

## Anti-Patterns Summary

Avoid these common mistakes in AI-first engineering:

| Anti-Pattern | Why It Fails | Fix |
|---|---|---|
| "The AI will figure it out" | Vague intent → vague output | Write clear specs with acceptance criteria |
| Blind trust in AI output | AI excels at plausible-but-wrong code | Verify with evals, review at boundaries |
| Same review process as before | AI code has different failure modes | Adapt review to focus on behavior and security |
| Hiring for typing speed | Irrelevant in AI-first teams | Hire for decomposition, eval design, and judgment |
| Architecture by convention | Agents can't read conventions | Make boundaries, types, and contracts explicit |
| Lower testing bar for AI code | AI code needs MORE testing | Raise the bar: edge cases, regressions, error paths |
