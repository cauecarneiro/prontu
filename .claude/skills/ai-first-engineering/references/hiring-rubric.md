# Hiring Rubric for AI-First Engineering Teams

> Detailed reference for evaluating and hiring engineers in AI-first teams.
> For the quick version, see the parent [SKILL.md](../SKILL.md).

## The AI-First Engineer Profile

In traditional teams, the best engineers write clean, efficient code.
In AI-first teams, the best engineers **orchestrate AI effectively** — they decompose problems, design evals, and enforce quality at the system level.

### Key Mindset Shifts

| Traditional Engineer | AI-First Engineer |
|---|---|
| "I'll write this myself" | "I'll define the spec and eval, then delegate" |
| "I know this works because I wrote it" | "I know this works because the evals pass" |
| "Let me code faster" | "Let me plan better" |
| "This code is clever" | "This code is verifiable" |
| "I'll fix it later" | "I'll define 'fixed' now and eval for it" |

## Competency Assessment Matrix

### 1. Problem Decomposition

**What to evaluate:** Can they break ambiguous work into clear, agent-sized units?

| Level | Behavior |
|---|---|
| 🔴 Weak | Takes the entire task as a single unit; can't articulate sub-steps |
| 🟡 Developing | Splits into a few large pieces but misses dependencies |
| 🟢 Strong | Creates well-defined units with clear done conditions and risk isolation |
| ⭐ Expert | Adds dependency mapping, parallel execution opportunities, and model tier suggestions |

**Interview exercise:**
> "Here's a feature request: 'Add collaborative editing to the notes app.'
> Walk me through how you'd break this down for an AI agent to implement."

**Scoring guide:**
- ❌ "I'd tell the AI to implement collaborative editing" (no decomposition)
- 🟡 "I'd split it into backend, frontend, and sync" (too coarse)
- ✅ "I'd start with conflict resolution model, then OT/CRDT implementation, then sync protocol, then UI indicators — each with its own eval" (well-decomposed)

---

### 2. Acceptance Criteria & Eval Design

**What to evaluate:** Can they define measurable "done" conditions before starting?

| Level | Behavior |
|---|---|
| 🔴 Weak | "I'll know it's done when it works" |
| 🟡 Developing | Defines happy-path tests but misses edge cases |
| 🟢 Strong | Writes capability + regression evals before implementation |
| ⭐ Expert | Designs evals that catch subtle issues (race conditions, data loss, security) |

**Interview exercise:**
> "You need to add search functionality to a notes app.
> What evals would you define before writing any code?"

**Scoring guide:**
- ❌ "I'd test that search returns results" (too vague)
- 🟡 "I'd test search by title and by body content" (happy path only)
- ✅ "Capability: search by title, body, and tags. Edge cases: empty query, special characters, unicode. Regression: existing note listing still works, performance doesn't degrade" (comprehensive)

---

### 3. Prompt Engineering Quality

**What to evaluate:** Do they produce high-signal prompts that reduce retries?

| Level | Behavior |
|---|---|
| 🔴 Weak | Prompts are vague, missing context, or overly long |
| 🟡 Developing | Provides context but doesn't constrain output format |
| 🟢 Strong | Includes context, constraints, output format, and examples |
| ⭐ Expert | Iterates on prompts based on eval results; optimizes for the specific model tier |

**Evaluation approach:** Review their prompt history alongside the output quality and retry count.

---

### 4. Risk Judgment Under Pressure

**What to evaluate:** Do they maintain quality standards when delivery pressure increases?

| Level | Behavior |
|---|---|
| 🔴 Weak | Skips tests and reviews to ship faster |
| 🟡 Developing | Maintains tests but cuts review depth |
| 🟢 Strong | Identifies which quality controls are negotiable vs. non-negotiable |
| ⭐ Expert | Decomposes differently under pressure — ships smaller, safer increments |

**Interview exercise:**
> "You're behind schedule. The PM is pressing for release.
> The AI generated the feature and it passes happy-path tests.
> What do you do?"

**Scoring guide:**
- ❌ "Ship it — the AI generated it and it works" (no judgment)
- 🟡 "I'd run the full test suite but skip edge-case tests" (partial)
- ✅ "I'd ship behind a feature flag, keep the full test suite, and add edge-case coverage in the next sprint. I'd never skip security or data integrity checks" (risk-aware)

---

### 5. Code Explanation & Ownership

**What to evaluate:** Can they explain and take ownership of AI-generated code?

| Level | Behavior |
|---|---|
| 🔴 Weak | "The AI wrote it, I don't know why it does that" |
| 🟡 Developing | Can explain the happy path but not edge cases |
| 🟢 Strong | Understands and can defend every design decision |
| ⭐ Expert | Identifies limitations of AI output and proactively addresses them |

**Interview exercise:** Show them AI-generated code with a subtle bug and ask them to review it.

---

## Interview Structure (Recommended)

| Phase | Duration | Focus |
|---|---|---|
| 1. Decomposition exercise | 20 min | Give a vague feature request; evaluate breakdown quality |
| 2. Eval design exercise | 15 min | Given a feature, define evals before implementing |
| 3. Code review exercise | 15 min | Review AI-generated code with planted bugs |
| 4. Pressure scenario | 10 min | "Ship fast vs. ship safe" discussion |

## Red Flags & Green Flags Summary

### 🚩 Red Flags
- Cannot define done conditions before starting
- Trusts AI output without verification
- Prompts are vague or context-free
- Cannot explain AI-generated code they submitted
- Skips tests because "the AI got it right"
- Views AI as a magic box rather than a tool to orchestrate

### 🟢 Green Flags
- Writes evals before implementation
- Decomposes tasks without being prompted
- Questions AI output at boundaries and edge cases
- Can switch model tiers based on task complexity
- Maintains cost awareness across their work
- Treats AI-generated code with healthy skepticism
