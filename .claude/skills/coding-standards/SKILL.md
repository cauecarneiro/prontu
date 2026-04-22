---
name: coding-standards
description: Universal coding standards, best practices, and patterns for Swift, SwiftUI, and iOS development in a Vibe-Coding workflow.
---

# iOS Coding Standards & Best Practices

Universal coding standards for Swift, SwiftUI, and iOS AI-Driven Development.

## When to Activate

- Generating new Swift structs, classes, or actors
- Writing SwiftUI views or view models
- Reviewing AI-generated code for idiomatic Swift
- Refactoring existing code to follow Apple's API Design Guidelines
- Enforcing naming, formatting, or structural consistency in Swift

## Code Quality Principles

### 1. Readability at the Call Site
- Swift prioritizes clarity at the point of use.
- Method names should read as grammatical English phrases.
- Use argument labels to clarify the role of parameters.
- Optimize for the developer reading the code, not the machine.

### 2. Value Semantics over Reference Semantics
- Prefer `struct` and `enum` over `class` by default.
- Value types prevent unintended side effects and sharing of mutable state.
- Use `class` only when you explicitly need identity, Objective-C interoperability, or reference sharing.

### 3. Protocol-Oriented Programming (POP)
- Start with a `protocol` rather than a base `class`.
- Use protocol extensions to provide default implementations.
- Favor composition over inheritance.

### 4. Vibe-Coding Aesthetic
- Write code that AI can easily refactor and extend.
- Keep components small, focused, and independently testable.
- Avoid overly clever or terse code that confuses LLMs.

## Swift Standards

### Naming Conventions

```swift
// ✅ GOOD: Clear and readable at the call site
mutating func remove(at position: Index) -> Element
employees.remove(at: x)

// ❌ BAD: Redundant or unclear
mutating func removeElement(_ member: Element) -> Element
employees.removeElement(x)

// ✅ GOOD: Omit needless words
allViews.remove(cancelButton)

// ❌ BAD: Redundant words
allViews.removeElement(cancelButton)
```

### Optionals and Force Unwrapping

```swift
// ✅ GOOD: Safe optional binding
if let user = currentUser {
    print(user.name)
}
guard let session = currentSession else { return }

// ❌ BAD: Force unwrapping (unless absolutely mathematically guaranteed, like hardcoded URLs)
let name = currentUser!.name
```

### Error Handling

```swift
// ✅ GOOD: Use Swift's structured error handling
enum NetworkError: Error {
    case invalidURL
    case badResponse(Int)
}

func fetchUser(id: String) async throws -> User {
    // ...
}

// ✅ GOOD: Handle errors explicitly
do {
    let user = try await fetchUser(id: "123")
} catch NetworkError.badResponse(let code) {
    print("HTTP \(code)")
} catch {
    print("Unknown error: \(error)")
}

// ❌ BAD: Ignoring errors silently
let user = try? fetchUser(id: "123") // Only use if you truly don't care why it failed
```

### Async/Await Best Practices

```swift
// ✅ GOOD: Structured concurrency with TaskGroup or async let
async let user = fetchUser()
async let profile = fetchProfile()
let (u, p) = await (try user, try profile)

// ❌ BAD: Unstructured concurrency when not needed
Task {
    let user = try? await fetchUser()
}
// ... how do we know when it's done?
```

### Type Safety and Inference

```swift
// ✅ GOOD: Rely on type inference
let maxConnections = 5
var users: [User] = []

// ❌ BAD: Redundant type annotations
let maxConnections: Int = 5
var users: Array<User> = [User]()
```

## SwiftUI Best Practices

### View Composition

```swift
// ✅ GOOD: Small, focused views extracted into separate structs
struct UserProfileView: View {
    let user: User
    var body: some View {
        VStack {
            UserAvatar(url: user.avatarURL)
            UserInfo(name: user.name, bio: user.bio)
        }
    }
}

// ❌ BAD: Massive body or using functions returning AnyView
struct MassiveProfileView: View {
    let user: User
    var body: some View {
        VStack {
            // hundreds of lines of code...
        }
    }
}
```

### State Management (iOS 17+)

```swift
// ✅ GOOD: Modern @Observable macro
@Observable
class ProfileViewModel {
    var user: User?
    var isLoading = false
}

// ❌ BAD: Legacy ObservableObject (unless supporting iOS 16 and below)
class LegacyProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
}
```

## Anti-Patterns to Avoid

### 1. Massive View Controllers / View Models
Keep view models focused on preparing data for exactly one view.

### 2. Excessive use of `Any` or `AnyObject`
Swift is a strongly-typed language. If you are using `Any`, you are fighting the compiler.

### 3. Implicitly Unwrapped Optionals (`Type!`)
Only use these for Interface Builder outlets or when a dependency injection framework requires a two-phase initialization. Never use them as a convenience to avoid typing `?` or `if let`.

### 4. Ignoring Compiler Warnings
Swift compiler warnings are usually errors waiting to happen (especially concurrency warnings in Swift 6). Treat them as errors.

**Remember**: Code quality is not negotiable. Idiomatic Swift code enables rapid iteration, reduces bugs, and allows the Vibe-Coding AI to accurately grok your project structure.
