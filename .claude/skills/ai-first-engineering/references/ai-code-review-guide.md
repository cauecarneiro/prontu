# AI Code Review Guide

> Detailed reference for reviewing AI-generated code in AI-first teams.
> For the quick version, see the parent [SKILL.md](../SKILL.md).

## Review Philosophy

In AI-first teams, code review shifts fundamentally:

| Traditional Review | AI-First Review |
|---|---|
| Checks syntax, style, naming | **Style is automated** — focus on behavior |
| Trusts the author understands the system | **AI may not understand** the broader system |
| Reviews for developer intent | **Reviews for system correctness** |
| Collaborative learning tool | **Quality gate for AI output** |

## The 3-Layer Review Framework

### Layer 1: Automated (No Human Effort)

These checks should run automatically in CI — do not review them manually.

| Check | Tool Examples |
|---|---|
| Code formatting | SwiftFormat, Prettier, Black |
| Linting rules | SwiftLint, ESLint, Pylint |
| Import ordering | isort, organize-imports |
| Type checking | Swift compiler, TypeScript, mypy |
| Unused code detection | Compiler warnings, dead-code analysis |

### Layer 2: Eval-Based (Low Human Effort)

These checks are automated but require human-defined evals.

| Check | Implementation |
|---|---|
| Regression tests pass | Run existing test suite |
| Capability tests pass | Run evals defined for the current task |
| Performance benchmarks | Run benchmarks, compare against thresholds |
| Security scanning | Static analysis tools (e.g., Semgrep, CodeQL) |
| API contract validation | Schema validation, contract tests |

### Layer 3: Human Judgment (Focused Effort)

These checks **require** human reasoning and should be the focus of manual review.

#### 🔴 Critical — Always Review

**Behavior Regressions:**
- Does this change break existing functionality?
- Are there implicit dependencies on the changed behavior?
- Would existing users notice a difference?

**Security Assumptions:**
- Are credentials or tokens handled correctly?
- Are permissions checked at every entry point?
- Is sensitive data in logs or error messages?
- Are inputs validated at trust boundaries?

**Data Integrity:**
- Are database operations atomic where needed?
- Are race conditions possible?
- Are nullable fields handled correctly?
- Is data validated before persistence?

#### 🟡 Important — Usually Review

**Failure Handling:**
- Are all failure paths handled explicitly?
- Are errors propagated correctly or silently swallowed?
- Are resources cleaned up in error paths?
- Are retries appropriate (with backoff, limits)?

**Rollout Safety:**
- Can this be deployed incrementally?
- Is there a rollback path?
- Are database migrations reversible?
- Feature flags for risky changes?

**Hidden Coupling:**
- Does this change affect other modules unexpectedly?
- Are there implicit ordering dependencies?
- Are shared resources used correctly?

## Common AI Code Failure Modes

Understanding how AI code typically fails helps focus review effort:

### 1. Plausible but Wrong
The code looks correct at first glance but has subtle logic errors.

**How to spot:** Trace execution with edge-case inputs mentally or with a debugger.

```swift
// AI-generated — looks right but has a bug
func isValidAge(_ age: Int) -> Bool {
    return age > 0 && age < 150 // ❌ Excludes exactly 150
}

// Correct
func isValidAge(_ age: Int) -> Bool {
    return age > 0 && age <= 150 // ✅ Includes 150
}
```

### 2. Happy-Path Only
Error paths, edge cases, and failure modes are missing or incorrect.

**How to spot:** Ask "what happens when..." for every input parameter.

```swift
// AI-generated — no error handling
func fetchUser(id: String) -> User {
    let data = try! network.get("/users/\(id)") // ❌ Crashes on failure
    return try! JSONDecoder().decode(User.self, from: data) // ❌ Crashes on bad data
}
```

### 3. Hallucinated APIs
Uses methods, parameters, or return types that don't exist.

**How to spot:** Verify every API call against actual documentation and types.

```swift
// AI-generated — this API doesn't exist in SwiftUI
Text("Hello")
    .truncatingAt(.end, maxLines: 2) // ❌ Not a real modifier
    
// Correct
Text("Hello")
    .lineLimit(2)
    .truncationMode(.tail) // ✅ Real SwiftUI modifiers
```

### 4. Over-Engineering
Adds unnecessary abstractions, patterns, or future-proofing.

**How to spot:** For every abstraction, ask "is this needed NOW?"

### 5. Copy-Paste Drift
Similar code blocks with subtle, unintended differences.

**How to spot:** Compare repeated patterns side by side.

## Review Session Workflow

```
1. Scan the full diff (2 min)
   └── Get a mental model of what changed

2. Check automated results (1 min)
   └── CI passing? Lints clean? Tests green?

3. Review 🔴 Critical areas (focused time)
   └── Security, regressions, data integrity

4. Review 🟡 Important areas (remaining time)
   └── Failure handling, rollout safety, coupling

5. Record findings
   └── Use the review template below
```

## Review Template

| Field | Value |
|---|---|
| PR / Change | _title or link_ |
| Files reviewed | _list_ |
| Model that generated | _Haiku / Sonnet / Opus_ |
| 🔴 Critical issues | _count + descriptions_ |
| 🟡 Important issues | _count + descriptions_ |
| Automated checks | ✅ All passing / ❌ Failures noted |
| Time spent | _minutes_ |
| Verdict | ✅ Approve / 🔄 Request changes / ❌ Reject |

## Review Effort Calibration

| Scenario | Effort Level | Reasoning |
|---|---|---|
| Haiku-generated boilerplate | 🟢 Light scan | Low complexity, narrow scope |
| Sonnet-generated feature | 🟡 Standard review | Check boundaries and edge cases |
| Opus-generated architecture | 🔴 Deep review | High impact, verify design decisions |
| Changes to auth/security | 🔴 Deep review | Always, regardless of generating model |
| Changes to data models | 🔴 Deep review | Schema changes cascade broadly |
| Changes to tests only | 🟢 Light scan | Verify tests test the right thing |
