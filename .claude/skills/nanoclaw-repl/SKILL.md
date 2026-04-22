---
name: nanoclaw-repl
description: Operate and extend NanoClaw v2, ECC's zero-dependency session-aware REPL built on claude -p.
origin: ECC
---

# NanoClaw REPL

Use this skill when running or extending `scripts/claw.js`.

## Capabilities

- persistent markdown-backed sessions
- model switching with `/model`
- dynamic skill loading with `/load`
- session branching with `/branch`
- cross-session search with `/search`
- history compaction with `/compact`
- export to md/json/txt with `/export`
- session metrics with `/metrics`

## Operating Guidance (iOS Workflow)

1. Keep sessions focused on a single Swift module or application feature.
2. Branch before high-risk changes (e.g., refactoring CoreData/SwiftData schema).
3. Compact after major milestones or successful XCTest suite runs.
4. Export before sharing or archival (e.g., attaching to Jira/Linear tickets).

## Extension Rules

- keep zero external runtime dependencies
- preserve markdown-as-database compatibility
- keep command handlers deterministic and local
