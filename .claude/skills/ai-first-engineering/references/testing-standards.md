# Testing Standards for AI-First Engineering

> Detailed reference for testing standards in codebases with high AI-generated output.
> For the quick version, see the parent [SKILL.md](../SKILL.md).

## Core Principle

> AI-generated code requires a **higher** testing bar, not lower.
> The agent doesn't understand your system's invariants, edge cases, or business rules
> the way a human engineer does. Tests are how you verify correctness.

## The Testing Pyramid for AI-First Teams

```
         ╱╲
        ╱  ╲
       ╱ E2E╲         Few, slow, high-confidence
      ╱ Tests ╲        (human-defined scenarios)
     ╱──────────╲
    ╱ Integration╲     Moderate, at boundaries
   ╱   Tests      ╲    (contract + interface tests)
  ╱────────────────╲
 ╱   Unit Tests      ╲  Many, fast, focused
╱  (agent + human)    ╲  (agent generates, human reviews)
╱──────────────────────╲
```

### Key Difference from Traditional Pyramid

| Layer | Traditional | AI-First |
|---|---|---|
| Unit tests | Written by developer | **Agent generates**, human reviews for correctness |
| Integration tests | Written by developer | **Human defines contracts**, agent generates implementation |
| E2E tests | Written by QA team | **Human defines scenarios**, agent may assist with automation |

## Testing Requirements by Change Type

### New Feature / Module

| Requirement | Details |
|---|---|
| Capability tests | Tests that verify the new behavior works as specified |
| Edge-case tests | Nil, empty, max, negative, unicode, concurrent access |
| Regression baseline | Existing tests for adjacent modules must still pass |
| Integration tests | Verify interaction with other modules at boundaries |

```swift
// Example: New search feature for notes
@Test func search_byTitle_returnsMatches() {
    let store = NoteStore(notes: sampleNotes)
    let results = store.search("Swift")
    #expect(results.count == 2)
}

@Test func search_emptyQuery_returnsAll() {
    let store = NoteStore(notes: sampleNotes)
    let results = store.search("")
    #expect(results.count == sampleNotes.count)
}

@Test func search_noMatches_returnsEmpty() {
    let store = NoteStore(notes: sampleNotes)
    let results = store.search("nonexistent")
    #expect(results.isEmpty)
}

@Test func search_specialCharacters_doesNotCrash() {
    let store = NoteStore(notes: sampleNotes)
    let results = store.search("(.*)")
    #expect(results.isEmpty) // No crash, just no results
}
```

### Bug Fix

| Requirement | Details |
|---|---|
| Reproduction test | A test that **fails before** the fix and **passes after** |
| Root cause test | Verifies the root cause, not just the symptom |
| Regression check | Full test suite for the affected module must pass |

```swift
// Example: Bug — notes with nil title crash the list view
// Step 1: Write reproduction test (must fail)
@Test func noteList_nilTitle_displaysPlaceholder() {
    let note = Note(title: nil, body: "content")
    let viewModel = NoteListViewModel(notes: [note])
    #expect(viewModel.displayTitle(for: note) == "Untitled")
}

// Step 2: Fix the bug (now test passes)
// Step 3: Verify no regressions
```

### Refactor

| Requirement | Details |
|---|---|
| Existing tests pass | All tests for the refactored module must pass **before AND after** |
| No test modifications | If you need to change tests, the refactor changed behavior |
| Coverage maintained | Code coverage must not decrease |

### API / Contract Change

| Requirement | Details |
|---|---|
| Contract tests | Verify the new contract is honored |
| Consumer tests | All consumers of the API must be tested with the new contract |
| Migration tests | If data migration is needed, test the migration path |
| Backward compatibility | If applicable, verify old clients still work |

## Edge Cases Every AI-Generated Feature Must Test

AI models frequently miss these edge cases. Require them explicitly:

| Edge Case | Examples | Test Pattern |
|---|---|---|
| **Nil / Optional** | Nil title, nil user, missing field | `#expect(fn(nil) == defaultValue)` |
| **Empty** | Empty string, empty array, empty dict | `#expect(fn("").isEmpty)` |
| **Boundary** | 0, 1, -1, Int.max, Int.min | `#expect(fn(Int.max) doesn't overflow)` |
| **Unicode** | Emoji, RTL text, combining characters | `#expect(fn("🎉") works correctly)` |
| **Concurrent** | Simultaneous read/write, race conditions | Test with actors or async expectations |
| **Large input** | 10K items, 1MB string | `#expect(fn(largeInput) completes in <1s)` |
| **Malformed input** | Invalid JSON, corrupt data, wrong type | `#expect(fn(badInput) throws gracefully)` |

## Test Quality Checklist

Run this checklist before considering tests complete:

- [ ] **Deterministic** — Every test produces the same result on every run.
- [ ] **Independent** — Tests don't depend on execution order or shared state.
- [ ] **Fast** — Unit tests run in < 1s each. Mock I/O, network, and persistence.
- [ ] **Behavior-focused** — Tests assert on outputs and behavior, not internal implementation.
- [ ] **Edge cases covered** — Nil, empty, boundary, unicode, concurrent, large, malformed.
- [ ] **Error paths tested** — Verify what happens when things go wrong.
- [ ] **Readable** — Test name describes the behavior: `test_what_when_then`.
- [ ] **No flakes** — Zero tolerance for intermittent failures.

## Test Naming Convention

Use the `test_<what>_<when>_<then>` pattern for maximum readability:

```swift
// ✅ Good — clear behavior description
@Test func formattedPrice_whenCentsAreZero_returnsWholeNumber()
@Test func search_emptyQuery_returnsAllNotes()
@Test func delete_lastNote_showsEmptyState()

// ❌ Bad — vague or implementation-focused
@Test func testSearch()
@Test func testViewModel()
@Test func testArrayNotEmpty()
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|---|---|---|
| **Happy-path only** | Misses edge cases, errors, failures | Add edge-case matrix (see above) |
| **Testing implementation** | Tests break on refactor | Test behavior and outputs |
| **AI-generated tests, unreviewed** | May assert wrong behavior | Review tests with same rigor as production code |
| **Shared mutable state** | Tests interfere, causing flakes | Fresh state per test |
| **Slow unit tests** | Breaks fast feedback loop | Mock all external dependencies |
| **Tests that mirror code** | No value — just restates the implementation | Test from the user/caller's perspective |
| **Commented-out tests** | Hidden technical debt | Delete or fix immediately |

## Metrics to Track

| Metric | Target | Why |
|---|---|---|
| Test pass rate | 100% (no flakes) | Flakes erode trust in the test suite |
| Code coverage | >80% for business logic | Ensures critical paths are tested |
| Test execution time | < 30s for unit suite | Fast feedback enables rapid iteration |
| Edge case coverage | Every feature has edge-case tests | AI's weakest area requires explicit coverage |
| Test-to-code ratio | ~1:1 for new features | Ensures adequate coverage density |
