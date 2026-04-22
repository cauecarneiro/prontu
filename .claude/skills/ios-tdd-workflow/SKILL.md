---
name: ios-tdd-workflow
version: 1.0.0
description: >-
  iOS Test-Driven Development skill.
  Enforces the Red-Green-Refactor cycle for Swift/SwiftUI projects.
  Use this skill when writing new features, fixing bugs, or refactoring iOS code.
  Keywords: TDD, XCTest, Swift Testing, iOS, SwiftUI, red-green-refactor, unit test, XCTestCase.
---

# iOS Test-Driven Development (TDD)

> Follow this workflow for every code change in an iOS project.
> The test is always written **before** the production code.

## TDD Cycle — Red → Green → Refactor

### 1. 🔴 Red — Write a Failing Test First

Before touching any production code:

- Create or locate the matching test file (e.g., `FooTests.swift` for `Foo.swift`).
- Write **one** small, focused test that describes the expected behavior.
- Use the **Swift Testing** framework (`import Testing`, `@Test`, `#expect`) for new projects.
  Fall back to `XCTest` only for UIKit-heavy or legacy targets.
- Name the test clearly: `test_<behavior>_<condition>_<expectedResult>`.
- Confirm the test **fails** (Red) — if it passes, the test is not adding value.

```swift
// Swift Testing example
@Test func formattedPrice_whenCentsAreZero_returnsWholeNumber() {
    let product = Product(priceInCents: 500)
    #expect(product.formattedPrice == "$5")
}
```

### 2. 🟢 Green — Write the Minimum Code to Pass

- Implement **only** enough production code to make the failing test pass.
- Do not add extra logic, future-proofing, or unrelated features.
- Run the test suite and confirm **all** tests pass (Green).

### 3. 🔵 Refactor — Improve Without Changing Behavior

- Clean up both production and test code (naming, duplication, structure).
- Run the full test suite after every change to ensure nothing broke.
- Commit when the cycle is complete: failing test → passing test → clean code.

---

## Practical Rules

| Rule | Guideline |
| --- | --- |
| **One assert per test** | Each test verifies a single behavior. Multiple assertions only when testing the same logical outcome. |
| **No production code without a failing test** | Every line of source code must be driven by a test. |
| **Test naming** | `test_<what>_<when>_<then>` pattern for readability. |
| **Test isolation** | No shared mutable state between tests. Use fresh instances in `setUp`. |
| **Arrange-Act-Assert** | Structure every test body in three clear sections. |
| **Fast feedback** | Unit tests must run in < 1 s each. Mock I/O, network, and persistence. |

---

## File & Target Conventions

- Production target: `Sources/` or main app target.
- Test target: `Tests/` or `<AppName>Tests` target.
- Mirror the production folder structure inside the test target.
- One test file per production file: `Foo.swift` → `FooTests.swift`.

---

## When to Apply

Use this TDD workflow for **any** of the following:

- Adding a new feature or module.
- Fixing a bug (write a test that reproduces the bug first).
- Refactoring existing code (ensure tests exist before changing).
