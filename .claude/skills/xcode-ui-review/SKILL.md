---
name: xcode-ui-review
description: >
  Automated UI/UX review pipeline for iOS apps. Builds and runs the app in Xcode Simulator,
  interacts with the UI, captures strategic screenshots, and uses Claude's vision to analyze
  interfaces against Apple HIG, project design system, and UI/UX best practices.
  Outputs a structured report with actionable findings, severity levels, and fix suggestions.
---

# Xcode UI Review Skill

## Overview

This skill automates the full cycle of **visual UI/UX quality assurance** for iOS applications:

```
Build → Run in Simulator → Interact → Screenshot → Analyze → Report
```

It bridges the gap between **Xcode development tooling** (via MCP servers) and
**Claude's multimodal analysis capabilities** to produce professional-grade UI audits
without requiring manual screenshot gathering or separate review tools.

---

## Architecture

### Pipeline Stages

```
┌─────────────────────────────────────────────────────────────────────┐
│                     XCODE UI REVIEW PIPELINE                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌────────────────┐  │
│  │  STAGE 1  │──▶│  STAGE 2  │──▶│  STAGE 3  │──▶│    STAGE 4     │  │
│  │  Build &  │   │ Navigate  │   │ Capture   │   │   AI Analysis  │  │
│  │   Boot    │   │ & Interact│   │Screenshots│   │   & Reporting  │  │
│  └──────────┘   └──────────┘   └──────────┘   └────────────────┘  │
│       │              │              │                  │            │
│   xcodebuild     simctl/idb    simctl/idb      Claude Vision +    │
│   + simctl       tap/swipe     screenshot      Apple HIG RAG      │
│                  type/scroll                                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### MCP Server Stack (Recommended)

The skill leverages one or more MCP servers. Choose based on your setup:

| MCP Server | Install | Strengths | Best For |
|---|---|---|---|
| **XcodeBuildMCP** (★ recommended) | `npx -y xcodebuildmcp@latest mcp` | 59+ tools, UI automation, tap/swipe, accessibility tree, screenshots | Full pipeline (build → interact → capture) |
| **xcode-mcp-server** (PyPI) | `uvx xcode-mcp-server` | AppleScript-based, project management, screenshots | Build + capture (no UI interaction) |
| **ios-simulator-mcp** | `npx -y ios-simulator-mcp` | IDB-powered, video recording, focused simulator control | Capture + interaction |
| **mcp-server-simulator-ios-idb** (Inditex) | Node-based IDB wrapper | Natural language commands, session management | Interaction + capture |
| **ebowwa/xcode-mcp** | Custom Node build | Project creation, simulator boot, basic install/launch | Lightweight setup |

**Minimum viable stack:** XcodeBuildMCP alone covers all 4 stages.
**Maximum coverage stack:** XcodeBuildMCP + ios-simulator-mcp (for video recording).

### MCP Configuration Example

```json
{
  "mcpServers": {
    "XcodeBuildMCP": {
      "command": "npx",
      "args": ["-y", "xcodebuildmcp@latest", "mcp"]
    },
    "ios-simulator": {
      "command": "npx",
      "args": ["-y", "ios-simulator-mcp"],
      "env": {
        "IOS_SIMULATOR_MCP_DEFAULT_OUTPUT_DIR": "~/ui-review-screenshots"
      }
    }
  }
}
```

---

## Stage 1: Build & Boot

### Goal
Compile the project and launch it on a target simulator.

### Steps
1. **Discover project** — Locate `.xcodeproj` or `.xcworkspace`
2. **Resolve scheme** — List available schemes, pick the one matching the target
3. **Select simulator** — Boot or reuse an existing simulator (prefer iPhone 15 Pro / iPhone 16)
4. **Build for simulator** — `simulator/build` with Debug configuration
5. **Install & launch** — Deploy the `.app` bundle and start it

### Key Tools (XcodeBuildMCP)
```
simulator/build          — Build the project
simulator/build-and-run  — Build + install + launch in one step
simulator/list-devices   — List available simulators
simulator/boot           — Boot a specific device
```

### Error Handling
- If build fails → capture build errors, report them, abort pipeline
- If simulator not found → list available devices, suggest closest match
- If app crashes on launch → capture crash log, include in report

---

## Stage 2: Navigate & Interact

### Goal
Traverse the app's key screens to expose all reviewable UI surfaces.

### Interaction Modes

**A. Guided Flow (recommended):**
The user provides a navigation script describing the screens to visit:

```yaml
# Example: review-flow.yaml
app_id: com.company.myapp
flows:
  - name: "Onboarding"
    steps:
      - wait: 2
      - screenshot: "01-splash"
      - tap: { text: "Get Started" }
      - wait: 1
      - screenshot: "02-onboarding-1"
      - swipe: "left"
      - screenshot: "03-onboarding-2"
      - swipe: "left"
      - screenshot: "04-onboarding-3"

  - name: "Home & Navigation"
    steps:
      - tap: { text: "Skip" }
      - wait: 2
      - screenshot: "05-home"
      - tap: { tab: "Search" }
      - screenshot: "06-search"
      - tap: { tab: "Profile" }
      - screenshot: "07-profile"

  - name: "Dark Mode"
    steps:
      - appearance: "dark"
      - wait: 1
      - screenshot: "08-home-dark"
      - tap: { tab: "Search" }
      - screenshot: "09-search-dark"
```

**B. Exploratory Mode:**
Claude uses the accessibility tree to discover interactive elements and
autonomously navigate the app, capturing screenshots at each distinct screen.

**C. Manual Capture:**
User provides pre-taken screenshots. The skill skips Stages 1-2 and goes
directly to analysis.

### Key Tools (XcodeBuildMCP)
```
ui-automation/tap        — Tap on element by coordinates or accessibility label
ui-automation/swipe      — Swipe in a direction
ui-automation/type       — Type text into focused field
simulator/screenshot     — Capture current screen
simulator/accessibility  — Read accessibility hierarchy (to discover elements)
simulator/appearance     — Toggle light/dark mode
```

---

## Stage 3: Capture Screenshots

### Goal
Organize high-quality screenshots in a structured directory.

### Directory Structure
```
ui-review/
├── {project-name}/
│   ├── {date-timestamp}/
│   │   ├── light/
│   │   │   ├── 01-splash.png
│   │   │   ├── 02-onboarding-1.png
│   │   │   ├── 05-home.png
│   │   │   ├── 06-search.png
│   │   │   └── 07-profile.png
│   │   ├── dark/
│   │   │   ├── 08-home-dark.png
│   │   │   └── 09-search-dark.png
│   │   ├── accessibility/
│   │   │   └── (accessibility tree dumps per screen)
│   │   ├── metadata.json
│   │   └── report.md
│   └── previous-runs/
│       └── ...
```

### metadata.json
```json
{
  "project": "MyApp",
  "scheme": "MyApp",
  "simulator": "iPhone 16 Pro",
  "ios_version": "18.2",
  "date": "2026-02-20T14:30:00Z",
  "screenshots": [
    {
      "id": "01-splash",
      "flow": "Onboarding",
      "screen": "Splash Screen",
      "appearance": "light",
      "path": "light/01-splash.png"
    }
  ],
  "design_system": "reference/design-tokens.json",
  "review_criteria": ["hig", "accessibility", "design-system", "consistency"]
}
```

---

## Stage 4: AI Analysis & Reporting

### Goal
Use Claude's vision capabilities to evaluate each screenshot against
multiple quality dimensions and produce an actionable report.

### Analysis Dimensions

Each screenshot is analyzed across these categories:

#### 1. Apple HIG Compliance
Uses the local Apple HIG RAG database (162 pages, 1540 chunks indexed)
to check against official guidelines:
- Navigation patterns (tab bars, navigation bars, sidebars)
- Component usage (buttons, lists, forms, alerts)
- Typography and readability
- Color and contrast
- Platform idioms and conventions
- Spacing and layout guidelines
- Liquid Glass (iOS 26+) adoption where applicable

#### 2. UI/UX Best Practices
- Visual hierarchy and information architecture
- Touch target sizes (minimum 44×44 pt)
- Consistent spacing rhythm
- Loading states and empty states
- Error state handling
- Gesture discoverability

#### 3. Design System Consistency
If the user provides design tokens or a reference design system:
- Color palette adherence
- Typography scale compliance
- Spacing system consistency
- Component variant correctness
- Icon style uniformity
- Border radius and shadow consistency

#### 4. Accessibility
- Contrast ratios (WCAG AA minimum: 4.5:1 for text)
- Dynamic Type support indicators
- Touch target adequacy
- Color-only information encoding
- Accessibility label quality (from tree dumps)

#### 5. Cross-Screen Consistency
Comparing screenshots to each other:
- Navigation pattern consistency
- Header/footer alignment across screens
- Color usage consistency
- Typography consistency
- Spacing rhythm maintenance

### Analysis Prompt Template

For each screenshot, Claude receives:

```
You are a senior iOS UI/UX designer reviewing this screen.

**Context:**
- App: {app_name}
- Screen: {screen_name}
- Flow: {flow_name}
- Appearance: {light|dark}
- Device: {simulator_device}

**Apple HIG Reference:**
{relevant_hig_chunks from RAG query}

**Design System Reference (if provided):**
{design_tokens}

**Previous screens in this flow:**
{thumbnails or descriptions of preceding screens}

**Evaluate this screen on:**
1. HIG Compliance — Does it follow Apple's guidelines?
2. Visual Hierarchy — Is the most important content prominent?
3. Spacing & Layout — Is the rhythm consistent and intentional?
4. Typography — Are font sizes, weights, and styles appropriate?
5. Color & Contrast — Are colors accessible and purposeful?
6. Component Quality — Are standard components used correctly?
7. Consistency — Does it match the rest of the app?
8. Interaction Design — Are touch targets adequate? Are actions clear?

**For each issue found, provide:**
- Severity: 🔴 Critical | 🟡 Major | 🔵 Minor | ⚪ Suggestion
- Category: [HIG | UX | Design System | Accessibility | Consistency]
- Description: What's wrong
- Location: Where on the screen (describe region)
- Recommendation: How to fix it
- HIG Reference: (if applicable) Which guideline section
```

### Report Output

The final report is generated as a Markdown document:

```markdown
# UI Review Report — {App Name}
**Date:** {timestamp}
**Device:** {simulator}   **iOS:** {version}
**Screens reviewed:** {count}

## Executive Summary
{High-level findings: X critical, Y major, Z minor issues}
{Top 3 most impactful improvements}

## Screen-by-Screen Analysis

### 1. Splash Screen
![](light/01-splash.png)

| # | Severity | Category | Finding | Recommendation |
|---|----------|----------|---------|----------------|
| 1 | 🔴 | HIG | ... | ... |
| 2 | 🟡 | UX | ... | ... |

### 2. Home
![](light/05-home.png)
...

## Cross-Screen Issues
{Issues that span multiple screens}

## Design System Drift
{Inconsistencies with the provided design system}

## Accessibility Audit
{WCAG compliance summary}

## Priority Action Items
1. 🔴 {Most critical fix}
2. 🔴 {Second critical fix}
3. 🟡 {High-impact improvement}
...
```

---

## Usage

### Minimal (screenshots only, no interaction)

```
User: Review the UI of my app at /path/to/MyApp.xcodeproj
```

The skill will:
1. Build the project
2. Launch on simulator
3. Capture the initial screen
4. Ask the user which screens to navigate to (or explore autonomously)
5. Analyze and report

### With Flow Script

```
User: Run a UI review of my app using this flow:
[attaches review-flow.yaml]
```

### With Design System

```
User: Review my app's UI against our design system.
[attaches design-tokens.json]
Project: /path/to/MyApp.xcodeproj
```

### Screenshots Only (skip build)

```
User: Analyze these screenshots for UI/UX issues.
[attaches screenshots]
```

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|---|---|---|
| `UI_REVIEW_OUTPUT_DIR` | Where to store screenshots and reports | `~/ui-reviews` |
| `UI_REVIEW_SIMULATOR` | Preferred simulator device | `iPhone 16 Pro` |
| `UI_REVIEW_APPEARANCE` | `light`, `dark`, or `both` | `both` |
| `UI_REVIEW_DESIGN_SYSTEM` | Path to design tokens JSON | (none) |

### Design Tokens Format

If providing a design system reference, use this format:

```json
{
  "colors": {
    "primary": "#007AFF",
    "secondary": "#5856D6",
    "background": "#FFFFFF",
    "surface": "#F2F2F7",
    "text-primary": "#000000",
    "text-secondary": "#8E8E93"
  },
  "typography": {
    "heading-1": { "size": 34, "weight": "bold", "font": "SF Pro Display" },
    "heading-2": { "size": 28, "weight": "bold", "font": "SF Pro Display" },
    "body": { "size": 17, "weight": "regular", "font": "SF Pro Text" },
    "caption": { "size": 12, "weight": "regular", "font": "SF Pro Text" }
  },
  "spacing": {
    "unit": 8,
    "scales": [4, 8, 12, 16, 24, 32, 48]
  },
  "radii": {
    "small": 8,
    "medium": 12,
    "large": 16
  }
}
```

---

## Prerequisites

- **macOS** with **Xcode** installed (+ command line tools)
- At least one iOS Simulator configured
- One of the recommended MCP servers installed and configured
- For IDB-based MCPs: Facebook IDB tool (`brew install idb-companion`)

---

## Limitations

- Cannot interact with system dialogs (permission prompts) automatically
  — user may need to pre-grant permissions
- Cannot evaluate animations or transitions (static screenshots only)
  — use ios-simulator-mcp video recording for motion review
- SwiftUI Previews are not accessible via MCP
- Physical device testing requires code signing configuration
- Analysis quality depends on screenshot resolution and clarity

---

## Future Enhancements

- **Diff mode**: Compare screenshots between two builds/versions
- **Regression detection**: Flag visual changes automatically
- **Figma integration**: Compare implementation vs. design mockups
- **Video analysis**: Review transitions and animations frame-by-frame
- **Multi-device matrix**: Run the same flow on iPhone SE, Pro, Pro Max
- **Localization review**: Switch language and review text truncation
- **Performance overlay**: Capture with GPU/CPU debug overlays
