# Eval-First Guide

> Detailed reference for the eval-first execution loop.
> For the quick version, see the parent [SKILL.md](../SKILL.md).

## Why Eval-First?

Traditional development writes code first and tests later. In agentic engineering, this is inverted:

1. **Evals define "done"** — without them, you cannot know if the agent succeeded.
2. **Baselines reveal gaps** — running evals before implementation shows exactly what's missing.
3. **Deltas prove value** — comparing before/after eval results quantifies the implementation's impact.

## The Full Loop

```
┌─────────────────────────────────────────┐
│  1. Define capability eval              │
│     "What new behavior must pass?"      │
├─────────────────────────────────────────┤
│  2. Define regression eval              │
│     "What existing behavior must NOT    │
│      break?"                            │
├─────────────────────────────────────────┤
│  3. Run baseline                        │
│     Record: which evals pass/fail       │
│     Capture failure signatures          │
├─────────────────────────────────────────┤
│  4. Execute implementation              │
│     Write minimum code to pass          │
│     capability eval                     │
├─────────────────────────────────────────┤
│  5. Re-run all evals                    │
│     Compare deltas                      │
│     Capability: ❌→✅ (expected)         │
│     Regression: ✅→✅ (required)         │
└─────────────────────────────────────────┘
```

## Types of Evals

### Capability Eval
Tests the **new behavior** you are implementing.

- Should fail before implementation (Red state).
- Should pass after implementation (Green state).
- Must be specific and deterministic.

**Examples:**
- Unit test for a new function
- Integration test for a new endpoint
- Assertion that a new UI element renders correctly

### Regression Eval
Tests **existing behavior** that must remain unchanged.

- Should pass before AND after implementation.
- If it fails after, you introduced a regression.
- Cover all domains touched by the change.

**Examples:**
- Existing test suite for the modified module
- Smoke tests for adjacent features
- Performance benchmarks for hot paths

## Failure Signatures

Before implementing, capture the **failure signature** of your capability eval:

```
Test: parse("[[a]]") should return Node(Node("a"))
Failure: TypeError — parse() does not support nested input
Stack: parser.js:42 → tokenize() → unexpected token '['
```

This signature helps you:
1. Confirm the eval is testing the right thing.
2. Know exactly where to focus implementation.
3. Verify the fix addresses the root cause (not a superficial workaround).

## Detailed Example: Adding Search to a Notes App

### Step 1 — Capability Eval

```swift
@Test func search_byTitle_returnsMatchingNotes() {
    let store = NoteStore(notes: [
        Note(title: "Swift Tips", body: "..."),
        Note(title: "Recipe Ideas", body: "..."),
        Note(title: "Swift Patterns", body: "...")
    ])
    let results = store.search(query: "Swift")
    #expect(results.count == 2)
    #expect(results.allSatisfy { $0.title.contains("Swift") })
}
```

### Step 2 — Regression Eval

```swift
@Test func allNotes_returnsAllNotes() {
    let store = NoteStore(notes: [
        Note(title: "A", body: "..."),
        Note(title: "B", body: "...")
    ])
    #expect(store.allNotes.count == 2)
}
```

### Step 3 — Baseline

| Eval | Result |
|---|---|
| `search_byTitle_returnsMatchingNotes` | ❌ — `search()` method does not exist |
| `allNotes_returnsAllNotes` | ✅ |

### Step 4 — Implementation

```swift
extension NoteStore {
    func search(query: String) -> [Note] {
        notes.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
```

### Step 5 — Re-run

| Eval | Before | After | Delta |
|---|---|---|---|
| `search_byTitle_returnsMatchingNotes` | ❌ | ✅ | ✅ New capability |
| `allNotes_returnsAllNotes` | ✅ | ✅ | — No regression |

## Common Mistakes

| Mistake | Impact | Fix |
|---|---|---|
| Skipping regression eval | Silent breakage of existing features | Always define regression suite before starting |
| Capability eval too broad | Hard to pinpoint what's failing | One specific behavior per eval |
| Not recording baseline | Cannot prove delta | Always run and record before implementation |
| Eval passes before implementation | Test is not adding value | Re-examine the test — it should fail first |
