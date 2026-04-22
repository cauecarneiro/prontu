# Agent-Friendly Architecture Patterns

> Detailed reference for designing architectures that enable AI agent workflows.
> For the quick version, see the parent [SKILL.md](../SKILL.md).

## Why Architecture Matters for AI Agents

AI agents operate by reading code, reasoning about it, and generating changes. Their effectiveness is **directly proportional** to how well the architecture supports their workflow:

- **Context window limits** — agents can only "see" a limited amount of code at once.
- **Reasoning limits** — agents struggle with implicit behavior and hidden conventions.
- **Testing limits** — agents need fast, deterministic feedback to validate changes.

An agent-hostile architecture turns a capable model into a confused one.

## The 5 Pillars of Agent-Friendly Architecture

### 1. Explicit Boundaries

**Principle:** Every module, layer, and component should have a clearly defined interface.

**Agent-Friendly:**
```swift
// Clear protocol boundary
protocol NoteRepository {
    func fetchAll() -> [Note]
    func save(_ note: Note) throws
    func delete(id: UUID) throws
}

// Implementation behind the boundary
final class SwiftDataNoteRepository: NoteRepository {
    private let context: ModelContext
    // ...
}
```

**Agent-Hostile:**
```swift
// Everything in one class, no clear boundary
final class NoteManager {
    // Mixes persistence, business logic, and presentation
    func doEverything() { /* 500 lines */ }
}
```

### 2. Stable Contracts

**Principle:** APIs and data contracts should change infrequently. When they do change, the change should be detectable at compile time.

**Guidelines:**
- Use versioned APIs for external interfaces.
- Prefer additive changes over breaking changes.
- Document breaking changes in migration guides.
- Use deprecation warnings, not silent behavior changes.

### 3. Typed Interfaces

**Principle:** Strong typing at boundaries catches errors at compile time, giving agents immediate feedback.

**Agent-Friendly:**
```swift
// Typed enum — agent gets compile-time errors on missing cases
enum NoteCategory: String, Codable {
    case personal, work, ideas, archive
}

func filterNotes(by category: NoteCategory) -> [Note] { ... }
```

**Agent-Hostile:**
```swift
// Magic strings — agent has no way to know valid values
func filterNotes(by category: String) -> [Note] { ... }
// What are the valid categories? "personal"? "Personal"? "PERSONAL"?
```

### 4. Deterministic Tests

**Principle:** Tests must produce the same result on every run, giving agents reliable feedback.

**Sources of non-determinism to eliminate:**

| Source | Fix |
|---|---|
| Current date/time | Inject a clock; use fixed dates in tests |
| Random number generation | Inject a seed or use a mock generator |
| Network calls | Mock all network dependencies |
| File system state | Use in-memory stores or temp directories |
| Test execution order | Ensure tests are independent; no shared state |
| Async timing | Use deterministic async testing utilities |

### 5. Minimal Implicit Behavior

**Principle:** Avoid hidden conventions, magic files, and ambient state that agents can't discover programmatically.

| Implicit (Bad) | Explicit (Good) |
|---|---|
| `AppDelegate` configures everything at launch | Explicit dependency graph with injection |
| Naming convention determines routing | Route registration with typed declarations |
| `.env` file overrides config silently | Config struct with documented defaults |
| Middleware order matters but isn't documented | Pipeline declaration with explicit ordering |
| Observer pattern with no subscriber list | Published event types with documented effects |

## Architecture Patterns That Work Well with AI Agents

### Clean Architecture / Hexagonal

```
┌─────────────────────────────────────┐
│           Presentation              │ ← SwiftUI Views
├─────────────────────────────────────┤
│           Use Cases                 │ ← Business Logic
├─────────────────────────────────────┤
│           Domain Models             │ ← Pure data types
├─────────────────────────────────────┤
│           Repositories              │ ← Protocols (boundaries)
├─────────────────────────────────────┤
│           Infrastructure            │ ← SwiftData, Network, etc.
└─────────────────────────────────────┘
```

**Why it works:**
- Each layer has a clear, testable boundary.
- Agent can work on one layer without understanding others.
- Protocols at boundaries enable easy mocking for tests.

### Feature Modules

```
Features/
├── Notes/
│   ├── Models/
│   ├── Views/
│   ├── ViewModels/
│   └── Tests/
├── Tags/
│   ├── Models/
│   ├── Views/
│   ├── ViewModels/
│   └── Tests/
└── Settings/
    ├── Models/
    ├── Views/
    ├── ViewModels/
    └── Tests/
```

**Why it works:**
- Agent can focus on one feature module at a time.
- Tests are co-located with code — easy to find and run.
- Features are independent — changes to Notes don't affect Tags.

## Architecture Decision Record (ADR) Template

For AI-first teams, include agent-friendliness in every ADR:

```markdown
# ADR-XXX: [Title]

## Status: Proposed / Accepted / Deprecated

## Context
[What is the problem or decision?]

## Decision
[What approach was chosen?]

## Agent-Friendliness Assessment
- Can an agent modify this in isolation? [Yes/No]
- Are boundaries explicit and typed? [Yes/No]
- Are tests deterministic? [Yes/No]
- Is implicit behavior minimized? [Yes/No]

## Consequences
- Positive: [benefits]
- Negative: [trade-offs]
- Agent impact: [how this affects agent workflows]
```

## Common Anti-Patterns

| Anti-Pattern | Impact on Agents | Fix |
|---|---|---|
| God objects | Agent can't fit the context | Split into focused components |
| Convention over configuration | Agent can't discover behavior | Make behavior explicit |
| Circular dependencies | Agent can't reason about flow | Break cycles with protocols |
| Cross-cutting concerns in business logic | Agent changes leaked side effects | Extract into middleware/decorators |
| Untyped dictionaries at boundaries | Agent can't validate changes | Use Codable structs with typed fields |
