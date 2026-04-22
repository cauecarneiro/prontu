---
name: cost-aware-llm-pipeline
description: Cost optimization patterns for iOS LLM APIs — model routing, budget tracking with Swift actors, async retry logic, and prompt caching.
---

# Cost-Aware LLM Pipeline (iOS)

Patterns for controlling LLM API costs while maintaining quality in iOS apps or server-side Swift. Combines model routing, budget tracking, retry logic, and prompt caching into a composable `async/await` pipeline.

## When to Activate

- Building iOS applications that consume external LLM APIs (Claude, OpenAI)
- Processing batches of items with varying complexity
- Implementing budget constraints for API spend using Swift Actors
- Optimizing latency and cost without sacrificing quality on complex tasks

## Core Concepts

### 1. Model Routing by Task Complexity

Automatically select cheaper, faster models (like Haiku) for simple tasks, reserving expensive models (like Opus/Sonnet) for complex reasoning.

```swift
enum LLMModel: String {
    case sonnet = "claude-sonnet-4-6"
    case haiku = "claude-haiku-4-5-20251001"
}

struct RoutingConfig {
    static let sonnetTextThreshold = 10_000 // chars
    static let sonnetItemThreshold = 30     // items
    
    static func selectModel(textLength: Int, itemCount: Int, forceModel: LLMModel? = nil) -> LLMModel {
        if let forceModel { return forceModel }
        
        if textLength >= sonnetTextThreshold || itemCount >= sonnetItemThreshold {
            return .sonnet // Complex task
        }
        return .haiku // Simple task (3-4x cheaper)
    }
}
```

### 2. Thread-Safe Budget Tracking (Actors)

Use Swift Actors to track cumulative spend across concurrent API calls safely.

```swift
struct CostRecord: Sendable {
    let model: LLMModel
    let inputTokens: Int
    let outputTokens: Int
    let costUSD: Double
}

actor BudgetTracker {
    let budgetLimit: Double
    private(set) var records: [CostRecord] = []
    
    init(budgetLimit: Double = 1.00) {
        self.budgetLimit = budgetLimit
    }
    
    var totalCost: Double {
        records.reduce(0) { $0 + $1.costUSD }
    }
    
    var isOverBudget: Bool {
        totalCost > budgetLimit
    }
    
    func add(record: CostRecord) throws {
        guard !isOverBudget else {
            throw PipelineError.budgetExceeded(totalCost)
        }
        records.append(record)
    }
}
```

### 3. Narrow Retry Logic (Async/Await)

Retry only on transient errors (rate limits, timeouts) using Swift's concurrency features. Fail fast on authentication or bad request errors.

```swift
enum PipelineError: Error {
    case budgetExceeded(Double)
    case unrecoverableAPIError(String)
}

func callWithRetry<T>(maxRetries: Int = 3, operation: () async throws -> T) async throws -> T {
    for attempt in 0..<maxRetries {
        do {
            return try await operation()
        } catch let error as NetworkError {
            // Only retry transient errors
            guard error.isTransient, attempt < maxRetries - 1 else {
                throw error
            }
            // Exponential backoff
            let delay = UInt64(pow(2.0, Double(attempt))) * 1_000_000_000
            try await Task.sleep(nanoseconds: delay)
        }
    }
    fatalError("Unreachable")
}
```

### 4. Prompt Caching

When consuming APIs that support caching (like Anthropic's `ephemeral` cache control), structure your requests to put the static system prompt at the beginning.

```swift
struct MessagePayload: Encodable {
    let role: String
    let content: [ContentBlock]
}

struct ContentBlock: Encodable {
    let type: String
    let text: String
    let cacheControl: CacheControl?
    
    enum CodingKeys: String, CodingKey {
        case type, text
        case cacheControl = "cache_control"
    }
}

// Ensure the massive system prompt block has cache_control embedded
let systemBlock = ContentBlock(
    type: "text", 
    text: massiveSystemPrompt, 
    cacheControl: CacheControl(type: "ephemeral")
)
```

## Composition

Combine all four techniques in a single pipeline function:

```swift
final class LLMPipeline {
    let apiClient: APIClient
    let tracker: BudgetTracker
    
    init(apiClient: APIClient, tracker: BudgetTracker) {
        self.apiClient = apiClient
        self.tracker = tracker
    }
    
    func process(text: String, itemCount: Int) async throws -> String {
        // 1. Check budget (Actor isolated)
        guard await !tracker.isOverBudget else {
            throw PipelineError.budgetExceeded(await tracker.totalCost)
        }
        
        // 2. Select model
        let model = RoutingConfig.selectModel(textLength: text.count, itemCount: itemCount)
        
        // 3. Execute with Retry
        let response = try await callWithRetry {
            try await apiClient.sendMessage(model: model, text: text)
        }
        
        // 4. Record cost
        let cost = calculateCost(model: model, inputs: response.inTokens, outputs: response.outTokens)
        try await tracker.add(record: CostRecord(model: model, inputTokens: response.inTokens, outputTokens: response.outTokens, costUSD: cost))
        
        return response.text
    }
}
```

## Best Practices

- **Start with the cheapest model** and only route to expensive models when complexity thresholds are met.
- **Fail fast on budget limits.** Check the budget actor *before* making the network call.
- **Log model selection decisions** so you can tune your thresholds over time via analytics.
- **Use Swift Actors** for all state tracking that could be modified by concurrent networking Tasks.

## Anti-Patterns to Avoid

- Using the most expensive model for all requests regardless of complexity.
- Implementing retry logic that catches `Error` unconditionally (this wastes budget retrying Bad Requests or Auth failures).
- Using `class` and `DispatchQueue` for budget tracking instead of modern Swift `actor`.
