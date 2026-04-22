# Review Checklist for AI-Generated Code

> Detailed reference for reviewing AI-generated code.
> For the quick version, see the parent [SKILL.md](../SKILL.md).

## Review Philosophy

> Humans review for **judgment**. Machines review for **compliance**.
> Focus your review time on areas where AI models are weakest:
> system-level reasoning, security assumptions, and edge cases.

## Complete Checklist

### 🔴 Critical (Always Review)

These areas have the highest risk if AI gets them wrong.

- [ ] **Security & Authentication**
  - Are credentials, tokens, or API keys handled correctly?
  - Are permissions checked at every entry point?
  - Is sensitive data logged or exposed in error messages?
  - Are inputs sanitized before use (SQL injection, XSS, path traversal)?

- [ ] **Error Boundaries & Failure Handling**
  - Are all failure paths handled explicitly?
  - Are errors propagated correctly or silently swallowed?
  - Are resources cleaned up in error paths (connections, file handles, locks)?
  - Are error messages informative without leaking internals?

- [ ] **Data Integrity**
  - Are database operations atomic where needed?
  - Are race conditions possible in concurrent paths?
  - Is data validated at trust boundaries?
  - Are nullable fields handled correctly?

### 🟡 Important (Usually Review)

These areas are frequently incorrect in AI-generated code.

- [ ] **Invariants & Edge Cases**
  - Are boundary conditions covered (empty input, max values, nil)?
  - Are loop conditions correct (off-by-one)?
  - Are type conversions safe (overflow, precision loss)?
  - Are assumptions about input format documented?

- [ ] **Hidden Coupling & Dependencies**
  - Does this change affect other modules in non-obvious ways?
  - Are there implicit ordering dependencies?
  - Are shared resources (caches, queues, databases) used correctly?
  - Will this change break callers or downstream consumers?

- [ ] **Rollout Risk**
  - Can this be deployed incrementally (feature flag, canary)?
  - Is there a rollback path?
  - Are database migrations reversible?
  - Will this change affect existing data in production?

- [ ] **Performance**
  - Are there N+1 query patterns?
  - Are expensive operations in hot paths?
  - Is caching appropriate and invalidated correctly?
  - Are expensive objects created unnecessarily?

### 🟢 Nice to Have (Review When Time Permits)

- [ ] **Test Coverage**
  - Are the new code paths covered by tests?
  - Are edge cases tested?
  - Are error paths tested?
  - Are tests testing behavior (not implementation)?

- [ ] **Code Clarity**
  - Is the code self-documenting?
  - Are variable/function names descriptive?
  - Is the abstraction level consistent within each function?
  - Are complex algorithms commented with "why"?

- [ ] **API Design**
  - Are function signatures clean and intuitive?
  - Are return types consistent?
  - Is the API backward compatible?
  - Are default values sensible?

## What NOT to Review

> ⚠️ Do NOT waste review cycles on these — automate them instead.

| Category | Automate With |
|---|---|
| Code formatting | Prettier, SwiftFormat, Black |
| Import ordering | isort, organize-imports |
| Naming conventions (casing) | ESLint, SwiftLint |
| Unused variables/imports | Compiler warnings, linters |
| Line length | Editor/linter config |

## Common AI Code Review Traps

| Trap | Description | How to Spot |
|---|---|---|
| **Plausible but wrong** | Code looks reasonable but has subtle logic errors | Trace execution manually with edge-case inputs |
| **Happy-path only** | Error and edge paths are missing or incorrect | Ask "what happens when X is nil/empty/negative?" |
| **Over-engineering** | Unnecessary abstractions, patterns, or future-proofing | Check if the added complexity is justified by requirements |
| **Hallucinated APIs** | Uses methods or parameters that don't exist | Verify against actual documentation/types |
| **Copy-paste drift** | Similar blocks with subtle inconsistencies | Compare repeated patterns side-by-side |
| **Missing cleanup** | Resources opened but never closed in error paths | Trace every `.open()` / `init` for corresponding cleanup |

## Review Session Template

For each review, note:

| Field | Value |
|---|---|
| File(s) reviewed | _list_ |
| Model that generated | _Haiku / Sonnet / Opus_ |
| Critical issues found | _count and description_ |
| Important issues found | _count and description_ |
| Time spent reviewing | _minutes_ |
| Verdict | ✅ Approve / 🔄 Request changes / ❌ Reject |
