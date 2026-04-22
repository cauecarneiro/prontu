# Decomposition Patterns

> Detailed reference for task decomposition in agentic engineering.
> For the quick version, see the parent [SKILL.md](../SKILL.md).

## The 15-Minute Unit Rule

Each decomposed unit should be completable by an agent in approximately 15 minutes. This constraint forces:

- **Clarity** — vague tasks expand; specific tasks stay bounded.
- **Testability** — small units are easy to eval.
- **Recoverability** — if a unit fails, you lose 15 minutes, not 2 hours.

## Decomposition Template

```
Parent task: [high-level feature or story]
│
├── Unit 1: [verb] [noun]
│   ├── Done when: [specific eval or condition]
│   ├── Risk: [what could go wrong]
│   └── Tier: [Haiku / Sonnet / Opus]
│
├── Unit 2: [verb] [noun]
│   ├── Done when: [specific eval or condition]
│   ├── Risk: [what could go wrong]
│   └── Tier: [Haiku / Sonnet / Opus]
│
└── Unit N: [verb] [noun]
    ├── Done when: [specific eval or condition]
    ├── Risk: [what could go wrong]
    └── Tier: [Haiku / Sonnet / Opus]
```

## Criteria Checklist

Before executing a decomposed unit, verify it passes all criteria:

- [ ] **Independently verifiable** — Can I write a test/eval for just this unit?
- [ ] **Single dominant risk** — Is there only one thing likely to go wrong?
- [ ] **Clear done condition** — Can I state "done when X passes" unambiguously?
- [ ] **Minimal coupling** — Can this unit complete without knowing internals of other units?
- [ ] **≈15 minutes** — Is this achievable by an agent in ~15 minutes?

## Example 1: User Authentication

```
Parent task: Add user authentication
│
├── Unit 1: Validate email format
│   ├── Done when: regex test suite passes (valid + invalid emails)
│   ├── Risk: Regex too permissive or too strict
│   └── Tier: Haiku
│
├── Unit 2: Hash password with bcrypt
│   ├── Done when: round-trip test passes (hash → verify)
│   ├── Risk: Wrong cost factor or salt handling
│   └── Tier: Haiku
│
├── Unit 3: Create /login endpoint
│   ├── Done when: integration test returns valid JWT
│   ├── Risk: Token payload or expiry misconfigured
│   └── Tier: Sonnet
│
├── Unit 4: Add rate limiting to /login
│   ├── Done when: 429 returned after 5 failed attempts in 1 minute
│   ├── Risk: Rate limit state not isolated per user
│   └── Tier: Sonnet
│
└── Unit 5: Write auth middleware
    ├── Done when: protected routes return 401 without valid token
    ├── Risk: Middleware bypass on edge routes
    └── Tier: Sonnet
```

## Example 2: SwiftUI Note-Taking Feature

```
Parent task: Add note editing with auto-save
│
├── Unit 1: Create NoteEditor view
│   ├── Done when: Preview renders with title + body TextFields
│   ├── Risk: Layout issues on different screen sizes
│   └── Tier: Sonnet
│
├── Unit 2: Bind NoteEditor to SwiftData model
│   ├── Done when: Changes in TextFields persist to model
│   ├── Risk: ModelContext not properly injected
│   └── Tier: Sonnet
│
├── Unit 3: Add debounced auto-save (2s delay)
│   ├── Done when: Unit test confirms save fires after 2s idle
│   ├── Risk: Timer not cancelled on rapid edits
│   └── Tier: Sonnet
│
└── Unit 4: Add "unsaved changes" indicator
    ├── Done when: Dot appears when dirty, disappears after save
    ├── Risk: State sync between indicator and save status
    └── Tier: Haiku
```

## Dependency Management

When units have dependencies, make them explicit:

```
Unit 1: Create data model          (no dependencies)
Unit 2: Create repository layer    (depends on: Unit 1)
Unit 3: Create API endpoint        (depends on: Unit 2)
Unit 4: Create UI view             (depends on: Unit 1, can parallel with Unit 2-3)
```

### Rules for Dependencies

1. **Minimize serial chains** — look for units that can run in parallel.
2. **Never start a dependent unit before its prerequisite** eval passes.
3. **If a unit has >2 dependencies**, consider further decomposition.

## Signs of Poor Decomposition

| Signal | Problem | Fix |
|---|---|---|
| "This unit will take about an hour" | Too large | Split into 3-4 smaller units |
| "Done when everything works" | No clear eval | Define a specific test or condition |
| "This might break auth or payments" | Multiple risks | Isolate each risk into its own unit |
| "I need to understand module X internals" | Too coupled | Redesign the boundary or extract an interface |
| Unit has no test/eval | Not verifiable | If you can't eval it, you can't delegate it |
