---
name: e2e-testing
description: XCUITest E2E testing patterns for iOS, including Screen Object Model, stability strategies, and XcodeBuildMCP integration.
---

# iOS E2E Testing Patterns (XCUITest)

Comprehensive patterns for building stable, fast, and maintainable End-to-End (UI) test suites for iOS applications using Apple's native **XCUITest** framework.

## When to Activate

- Generating or modifying UI tests (`*UITests.swift`)
- Structuring test targets for a new iOS feature
- Debugging flaky UI tests or timeout issues
- Utilizing `XcodeBuildMCP` to run simulation tests autonomously

## Test Target Organization

Keep your UI tests decoupled from unit tests and organized by feature.

```swift
iOSAppUITests/
├── Core/
│   ├── BaseUITestCase.swift    # Setup, teardown, and app launch
│   └── ScreenObject.swift      # Base class/protocol for screens
├── Screens/
│   ├── LoginScreen.swift
│   └── HomeGalleryScreen.swift
├── Utilities/
│   └── XCUIElement+Extensions.swift
└── Tests/
    ├── AuthenticationTests.swift
    └── SearchFlowTests.swift
```

## Screen Object Model (SOM)

Instead of Page Objects (POM), iOS uses Screen Objects. Encapsulate XCUITest queries to keep tests readable and resilient to UI changes.

```swift
import XCTest

struct ItemSearchScreen {
    let app: XCUIApplication

    // Locators using Accessibility Identifiers
    var searchField: XCUIElement { app.searchFields["ItemSearchField"] }
    var resultCells: XCUIElementQuery { app.cells.matching(identifier: "ItemCell") }
    var createButton: XCUIElement { app.buttons["CreateItemButton"] }
    var emptyStateLabel: XCUIElement { app.staticTexts["NoResultsLabel"] }

    // Actions
    func search(for query: String) {
        searchField.tap()
        searchField.typeText(query)
        app.buttons["Search"].tap() // Keyboard search button
    }

    func selectItem(at index: Int) {
        let cell = resultCells.element(boundBy: index)
        XCTAssertTrue(cell.waitForExistence(timeout: 5.0))
        cell.tap()
    }
}
```

> **Vibe-Coding Tip**: Always instruct the AI to attach `.accessibilityIdentifier("SomeName")` to SwiftUI views so that Screen Objects can easily find them. Avoid querying by `.staticTexts["Exact String"]` which breaks on localization.

## Writing Resilient Tests

```swift
import XCTest

final class ItemSearchTests: XCTestCase {
    var app: XCUIApplication!
    var screen: ItemSearchScreen!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Pass launch arguments to configure the app for testing
        app.launchArguments.append("--ui-testing") 
        app.launch()
        
        screen = ItemSearchScreen(app: app)
    }

    func testSearchingForExistingItem() throws {
        screen.search(for: "Coffee")

        // Use expectations or waitForExistence instead of sleep
        let firstCell = screen.resultCells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5.0), "Results should appear")
        
        XCTAssertTrue(firstCell.staticTexts["Coffee Maker"].exists)
    }

    func testEmptyState() throws {
        screen.search(for: "NonExistentItem123")
        XCTAssertTrue(screen.emptyStateLabel.waitForExistence(timeout: 5.0))
    }
}
```

## Eliminating Flakiness

### 1. Never Sleep

```swift
// ❌ BAD: Arbitrary sleep causes slow tests and race conditions
sleep(3) 

// ✅ GOOD: Wait for specific elements or state changes
let button = app.buttons["Submit"]
XCTAssertTrue(button.waitForExistence(timeout: 5.0))
button.tap()
```

### 2. Wait for Hittable

Sometimes an element exists in the hierarchy but is covered by an animation or keyboard.

```swift
extension XCUIElement {
    func tapWhenHittable(timeout: TimeInterval = 5.0) {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "isHittable == true"), 
            object: self
        )
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        guard result == .completed else {
            XCTFail("Element \(self) did not become hittable")
            return
        }
        self.tap()
    }
}
```

### 3. Mock the Environment

Relying on live network calls makes UI tests flaky. Use launch arguments to switch the app to a "mocked" state.

```swift
// In your tests:
app.launchArguments.append("-UITestingMockNetwork")

// In your App code:
if ProcessInfo.processInfo.arguments.contains("-UITestingMockNetwork") {
    // Inject mock network client
}
```

## Running Tests via XcodeBuildMCP / CLI

When acting as an AI agent, you can verify your UI tests via the terminal or `XcodeBuildMCP`.

```bash
xcodebuild test \
  -scheme <YourScheme> \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.0' \
  -only-testing:YourAppUITests/ItemSearchTests/testSearchingForExistingItem
```

## Artifact Management

XCTest automatically captures screenshot attachments when tests fail (configured in the Test Plan). 

For debugging within a Claude Code session:
1. Parse the `.xcresult` bundle if deep debugging is needed using `xcrun xcresulttool`.
2. Ensure `continueAfterFailure = false` is set so the test stops immediately at the point of failure, making screenshots more relevant.
