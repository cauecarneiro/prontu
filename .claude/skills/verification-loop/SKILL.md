---
name: verification-loop
description: "A comprehensive Verification Loop for iOS AI-Driven Development sessions."
---

# Verification Loop Skill (iOS)

A comprehensive verification system for Claude Code sessions working on iOS projects. This skill defines a deterministic loop to verify that AI-generated Swift code compiles, passes tests, and adheres to quality standards.

## When to Activate

Invoke this skill:
- After completing a feature, view, or significant code change
- Before committing code or creating a PR
- When you want to ensure the iOS build is stable after refactoring
- When debugging complex compilation issues

## Verification Phases

### Phase 1: Build Verification
```bash
# Check if the project builds for the Simulator
xcodebuild clean build \
  -scheme <YourAppScheme> \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  | xcpretty
```
*Note: If `xcpretty` is not installed, pipe output through `grep -A 5 error:` to reduce noise.*

If the build fails, STOP and fix the compilation errors before continuing.

### Phase 2: Lint & Format Check
```bash
# Run SwiftLint to catch style violations
swiftlint lint --strict

# Run SwiftFormat to ensure standard formatting
swiftformat . --lint
```
Report all style violations. If `--strict` triggers failures, fix them before continuing.

### Phase 3: Test Suite Verification
```bash
# Run XCTest unit and UI tests
xcodebuild test \
  -scheme <YourAppScheme> \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  | xcpretty -t
```

Report:
- Total tests run
- Passed / Failed
- Any failing standard output/error logs from the test runner

### Phase 4: Security & Architecture Scan
```bash
# Check for common iOS security risks (hardcoded keys, print statements)
grep -rn "API_KEY" --include="*.swift" . 2>/dev/null | head -10
grep -rn "print(" --include="*.swift" . 2>/dev/null | head -10
grep -rn "TODO:" --include="*.swift" . 2>/dev/null | head -10

# Warning: Ensure no sensitive flags in Info.plist
cat <App>/Info.plist | grep -A 1 "NSAppTransportSecurity"
```

### Phase 5: Diff Review
```bash
# Show what changed
git diff --stat
git diff HEAD~1 --name-only
```

Review each changed Swift file for:
- Unintended changes (especially in `.xcodeproj/project.pbxproj` or `Info.plist`)
- Missing Swift concurrency (`@MainActor`) handling
- Potential retain cycles (missing `[weak self]` in closures)

## Output Format

After running all phases, produce a concise verification report:

```
iOS VERIFICATION REPORT
======================

Build:     [PASS/FAIL] (Target: iPhone 16 Pro Simulator)
Lint:      [PASS/FAIL] (X warnings)
Tests:     [PASS/FAIL] (X/Y passed)
Security:  [PASS/FAIL] (X prints/todos found)
Diff:      [X files changed]

Overall:   [READY/NOT READY] for Commit

Issues to Fix:
1. ...
2. ...
```

## Continuous Vibe-Coding Mode

For long iterative sessions, run verification after major logical chunks:

```markdown
Set a mental checkpoint:
- After generating a complex SwiftUI View hierarchy
- After wiring up a difficult `@Observable` ViewModel
- Before moving to the next feature task

If instructed to "verify", execute Phases 1 & 3 automatically.
```

## Integration with XcodeBuildMCP

If the user has installed the `XcodeBuildMCP` server, you can replace the bash `xcodebuild` commands with the corresponding MCP tools (e.g., `xcode_build`, `xcode_test`) for more reliable, structured output parsing.
