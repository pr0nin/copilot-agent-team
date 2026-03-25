# Optimize copilot-agent-team Repository

You are optimizing `this repository` — a reusable multi-agent team template for GitHub Copilot (9 agents, 3 instruction files, 1 prompt workflow, 5 skills, docs).

## Execution Model

1. **Read** every file listed in [Repo Inventory](#repo-inventory). Do not skip any.
2. **Produce a plan** listing every file change (create/edit/move/delete) with a one-line description of what changes. Group by commit.
3. **STOP. Print the plan. Wait for human approval.** Do not proceed until the user says "go".
4. **Execute** the approved plan using focused conventional commits on branch `chore/optimize-agent-team`.

---

## Design Principles

| # | Principle | Meaning |
|---|-----------|---------|
| 1 | **AI-density** | Maximum information, minimum tokens. Strip prose, personality, narrative, repeated boilerplate, examples the model already knows. Every token earns its place. |
| 2 | **Stack-agnostic core** | .NET-specific content → `examples/stacks/dotnet/` (retained as reference, not deleted) |
| 3 | **Runtime-generic** | Inline tool references to platform-mapped tools must be genericized (see [Tool Mapping](#tool-name-mapping)) |
| 4 | **Runtime priority** | Cloud agents → CLI → VS Code (when conflicts arise) |

---

## Repo Inventory

```
.github/
  agents/
    coordinator.agent.md (147 lines)
    developer.agent.md (109 lines)
    designer.agent.md (134 lines)
    tester.agent.md (148 lines)
    reviewer.agent.md (493 lines)
    product.agent.md (107 lines)
    platform-engineer.agent.md (81 lines)
    clerk.agent.md (34 lines)
    agent-creator.agent.md (71 lines)
    instructions/
      clarification-policy.instructions.md (32 lines)
      git.instructions.md (64 lines)
      safety.instructions.md (58 lines)
    prompts/
      fix-issue.prompt.md (57 lines)
  skills/
    playwright-cli/ (8 files, 933 lines)
    maskorama/ (2 files, 156 lines)
    blazor-conventions/ (1 file, 461 lines)
    dotnet-conventions/ (1 file, 159 lines)
    xunit-testing/ (1 file, 82 lines)
  copilot-instructions.md (119 lines)
  agent-journals/.gitkeep
README.md (163 lines)
AGENTS.md (24 lines)
```

---

## Target Structure

```
.github/
  agents/
    [9 compressed agent files]
    instructions/
      clarification-policy.instructions.md (keep, 95% signal already)
      git.instructions.md (fix dotnet ref)
      safety.instructions.md (fix broken refs, trim vague sections)
      journal.instructions.md (NEW — extracted)
      playwright-artifacts.instructions.md (NEW — extracted)
      escalation.instructions.md (NEW — extracted)
      designer-developer-collab.instructions.md (NEW — extracted)
    prompts/
      fix-issue.prompt.md (specify executor agent)
  skills/
    playwright-cli/ (unchanged)
    maskorama/ (unchanged)
  copilot-instructions.md (restructured)
  agent-journals/.gitkeep
README.md (streamlined, AGENTS.md merged in)
.gitignore (NEW)
examples/
  stacks/dotnet/
    README.md (NEW — explains these are .NET-specific references)
    skills/
      blazor-conventions/ (MOVED from .github/skills/)
      dotnet-conventions/ (MOVED from .github/skills/)
      xunit-testing/ (MOVED from .github/skills/)
    instructions/
      dotnet.instructions.md (NEW — extracted dotnet-specific refs)
  copilot-instructions-example.md (NEW — filled-in example)
```

Delete: `AGENTS.md` (content merged into README)

---

## Tool Name Mapping

The platform maps these tool names across runtimes (`agent`→`task`, `read`→`view`, `search`→`grep/glob`, `execute`→`bash`, `edit`→`edit/create`, `web`→varies, `todo`→SQL).

**Frontmatter `tools:` declarations** — leave as-is. Platform handles mapping.

**Inline references in agent body text** — genericize. Do NOT reference `read`, `search`, `execute`, `agent`, `todo`, `web` as tool names in prose. Use capability descriptions instead.

**External CLI tools** — `playwright-cli`, `gh`, `git`, `npm`, `docker` are safe to keep. They're not platform-mapped.

### Specific inline fixes required

| File | Line(s) | Current | Replace with |
|------|---------|---------|-------------|
| coordinator | ~29 | "`agent` tool" | "delegate to the appropriate agent" |
| coordinator | ~35 | "`todo` tool" | "make the plan visible and trackable" |
| coordinator | ~72-74 | "`list_agents`"/"`read_agent`" | "check agent status"/"retrieve results" |
| coordinator | ~82 | "`read` and `search`" | "inspect files and search the codebase" |
| tester | ~60 | "`read` and `search`" | "examine the codebase" |
| reviewer | ~29 | "`execute`" | "terminal/shell access" |
| product | ~82 | "`web` and `search`" | "research online and search the codebase" |
| platform-engineer | ~61 | "`agent` tool" | "invoke the Coordinator" |
| agent-creator | ~30 | "`read` and `search`" | "examine existing agents" |

Keep references to agent names (e.g., "hand off to `platform-engineer`") — those are names, not tool names.

---

## Work Area 1: Agent Compression

### Compression Targets

| Agent | Current | Target | Notes |
|-------|---------|--------|-------|
| coordinator | 147 | ≤85 | Remove Core Identity, Communication Style |
| developer | 109 | ≤70 | Remove Core Expertise list, Communication Style |
| designer | 134 | ≤80 | Remove Core Identity, verbose examples |
| tester | 148 | ≤80 | Remove Core Expertise list, tool examples |
| **reviewer** | **493** | **≤200** | Biggest target — see dedicated section |
| product | 107 | ≤65 | Remove Core Expertise, Communication Style |
| platform-engineer | 81 | ≤55 | Remove personality intro |
| clerk | 34 | ≤30 | Already lean — minor trim only |
| agent-creator | 71 | ≤50 | Remove verbose instructions |

### What to CUT from every agent

- **"Core Identity"/"Core Expertise" sections** — personality/resume prose. AI doesn't need to be told it has expertise.
- **"Communication Style" sections** — AI follows by example, not meta-description.
- **Personality intros** ("You are the X — a seasoned...with 20+ years...")
- **Code examples the model already knows** (basic git commands, gh CLI commands, playwright-cli usage, npm init, Playwright test syntax)
- **Motivational framing** ("Insight is cash", "every pixel serves a purpose", "protector of users")

### What to PRESERVE (behavioral signal)

- All Constraints sections (critical guardrails)
- Agent boundaries (who does/doesn't write code, tests)
- Collaboration protocols (designer↔developer, platform-engineer relay)
- Verification patterns (coordinator's 3-layer verification)
- Reviewer's three modes and detection table
- Security checklists (compress format, don't delete content)

### What to EXTRACT to shared instructions

These patterns appear in 5-8 agent files. Extract once, apply via `applyTo`:

#### 1. `journal.instructions.md` (8 agents × ~6 lines = ~48 lines saved)

```yaml
applyTo: "**/*.agent.md"
```

Content: journal location pattern (`.github/agent-journals/{agent-name}.journal.md`), date heading format, append-only rule. One concise block.

**Exception**: Clerk currently has no journal section. The new shared instruction covers it.

**Note for agents without `edit` tool** (coordinator, product, reviewer): The shared instruction should include: "If you lack file-editing capability, delegate journal writes to the clerk agent."

#### 2. `playwright-artifacts.instructions.md` (6 agents × ~3 lines = ~18 lines saved)

```yaml
applyTo: "**/coordinator.agent.md,**/designer.agent.md,**/developer.agent.md,**/platform-engineer.agent.md,**/reviewer.agent.md,**/tester.agent.md"
```

Content: Save artifacts to `.playwright-cli/` (gitignored). Clean up after checks. Keep only when user asks or as failure evidence.

#### 3. `escalation.instructions.md` (5 agents × ~3 lines = ~15 lines saved)

```yaml
applyTo: "**/developer.agent.md,**/designer.agent.md,**/tester.agent.md,**/product.agent.md,**/agent-creator.agent.md"
```

Content: Escalate CLI/CI/CD/infrastructure questions to `platform-engineer`. Platform-engineer relays insights to coordinator.

#### 4. `designer-developer-collab.instructions.md` (2 agents × ~10 lines = ~20 lines saved)

```yaml
applyTo: "**/designer.agent.md,**/developer.agent.md"
```

Content: Autonomous collaboration loop. Designer leads UI, developer implements. Multiple rounds without coordinator. Report joint summary when both satisfied.

After extraction, **remove the duplicated blocks** from each agent file.

### Reviewer.agent.md — Dedicated Compression Plan (493 → ≤200)

This is the highest-value compression target. Strategy:

| Section | Action |
|---------|--------|
| Personality intro (L6) | Delete entirely |
| Core Expertise (L14-21) | Delete — covered by constraints + mode descriptions |
| Git/gh/playwright-cli command blocks (L62-72, L112-143, L152-175, L206-230) | **Delete all**. AI knows these tools. |
| Output format template (~100 lines) | Collapse to section names + formatting rules (≤15 lines) |
| 4 review lens tables | Compress to compact lists (bullet per lens, not table per lens) |
| Mode 2/3 workflow prose | Compress — remove code blocks, keep structure |
| Communication Style | Delete |

**Preserve**: Three modes, mode detection table, all 12 constraints, plan alignment logic, review lens content (compressed), section structure rules.

### Before/After Example — product.agent.md

**BEFORE** (excerpt, lines 6-15 + 37-58 + 94-106):

```markdown
You are the **Product Developer** — a seasoned product thinker with deep experience
in modern product design, discovery, and delivery. Insight is cash, and cash is king.
Your job is to ensure the team builds the right thing, not just builds the thing right.

## Core Expertise

- **Product discovery**: Identifying assumptions, validating them cheaply...
- **User research**: Crafting focused interview questions...
- **Plan critique**: Finding gaps, unstated assumptions...
- **Acceptance criteria**: Defining clear, testable outcomes...
- **Handoff quality**: Ensuring context survives transitions...

### 1. Analyze the Plan

When the Coordinator presents a plan or feature request:

- Identify the **core assumption** — what must be true for this to be valuable?
- List **unstated assumptions** — what is the plan taking for granted?
- Find **edge cases** — what happens when users do the unexpected?
- Check **scope alignment** — does the plan solve the whole problem or just part of it?

### 2. Interview the User

Ask **at least 1 focused question** that:

- Validates the riskiest assumption in the plan
- Fills the biggest information gap
- Reveals user context that the plan doesn't account for

Good questions are specific and actionable. Bad questions are vague or leading.

**Good**: "When data is stale, would you rather see the old data with a warning, or no data at all?"
**Bad**: "Is the feature useful?"

Keep it to 1–3 questions. Respect the user's time — every question should earn its place.

## Project Journal

Maintain your journal at `.github/agent-journals/product.journal.md`...
(6 lines of journal boilerplate)

## Communication Style

- Direct and insight-driven — lead with what matters
- Frame everything in terms of user value and outcomes
- Challenge assumptions respectfully but firmly
- When disagreeing with a technical plan, explain the user-impact reason
```

**AFTER** (full optimized agent):

```markdown
---
description: "product. Use when: planning features, validating product ideas, user interview, stakeholder questions, acceptance criteria, product discovery, finding gaps in plans, UX review, QA acceptance, handoff review, product strategy, feature prioritization, user insight, validating assumptions"
tools: [read, search, web, todo, agent]
---

## Role

Ensure the team builds the right thing. Validate plans, interview users, sharpen acceptance criteria.

## Constraints

- **NEVER** write or edit code — delegate to developer.
- **NEVER** skip the interview step. Every plan gets ≥1 question to validate a key assumption.
- **NEVER** rubber-stamp. Your job: find what's missing.
- **ALWAYS** ground feedback in user value, not technical preference.

## When Involved

| Phase | Role |
|-------|------|
| Planning | Critique plan. Find gaps. Interview user. |
| Pre-handoff | Ensure acceptance criteria are clear, testable, user-value-oriented. |
| QA | Review from user perspective — does this solve the problem? |
| Acceptance | Final check: delivered work matches intent? Loose ends? |

## Workflow

### 1. Analyze the Plan
Identify: core assumption, unstated assumptions, edge cases, scope alignment.

### 2. Interview the User
1–3 focused questions. Each must validate an assumption, fill a gap, or reveal missing context.

### 3. Synthesize
Update plan with insight. Restate criteria if changed. Flag remaining risks.

### 4. Report
Output: Gaps found → Insight gathered → Updated criteria → Recommendation (proceed/adjust/more discovery) → Open risks.

## Research
When interviews aren't enough, research competitor patterns, UX conventions, domain constraints.
```

**Result**: 107 lines → ~42 lines. Journal, playwright artifacts, escalation handled by shared instructions. Communication Style deleted. Core Expertise deleted. Examples AI already knows deleted.

---

## Work Area 2: Fix Critical Issues

### 2.1 Contradictions

| Issue | Fix |
|-------|-----|
| Reviewer frontmatter has `agent` tool but body says "You do NOT invoke other agents directly" | Remove `agent` from reviewer's frontmatter `tools:` list. Reviewer escalates via reporting, not direct invocation. |
| Coordinator routing table missing reviewer, clerk, agent-creator | Add all three to the routing table |
| Product agent calls itself "Product Developer" | Rename to "Product" consistently throughout |
| Developer + reviewer have overlapping but different security checklists | Make reviewer's checklist canonical. Developer references "follow reviewer security lens" instead of maintaining a separate list. |

### 2.2 Broken References

| File | Issue | Fix |
|------|-------|-----|
| `git.instructions.md` L55 | `dotnet build` hardcoded | Replace with "Run the project's build command (see copilot-instructions.md)" |
| `safety.instructions.md` L25 | References `python.instructions.md` (doesn't exist) | Remove the line entirely |
| `safety.instructions.md` L14-15 | `issue/TK-ISSUE_NAME` convention is project-specific | Move to copilot-instructions.md as optional template content, remove from safety |
| `safety.instructions.md` L48-52 | "Bound by secrecy" vague corporate language | Replace with concise confidentiality rule |
| `fix-issue.prompt.md` | Doesn't specify which agent executes it | Add: route through coordinator |

### 2.3 Missing Tool Capabilities

3 agents (coordinator, product, reviewer) reference journal-writing but lack `edit` tool:

- **Coordinator & product**: Add note "delegate journal writing to clerk" (they shouldn't have `edit`)
- **Reviewer**: Same — delegate to clerk, or if journal is deemed unnecessary for reviewer, omit

---

## Work Area 3: .NET Migration

### Files to MOVE (not delete from git history — use `git mv` or copy+delete)

| Source | Destination |
|--------|-------------|
| `.github/skills/blazor-conventions/` | `examples/stacks/dotnet/skills/blazor-conventions/` |
| `.github/skills/dotnet-conventions/` | `examples/stacks/dotnet/skills/dotnet-conventions/` |
| `.github/skills/xunit-testing/` | `examples/stacks/dotnet/skills/xunit-testing/` |

### Files to CREATE

#### `examples/stacks/dotnet/README.md`

```markdown
# .NET Stack Skills

Reference skills for C#/.NET projects. Copy into `.github/skills/` to activate.

## Skills included

| Skill | Description |
|-------|-------------|
| blazor-conventions | Blazor SSR patterns, component best practices, Razor conventions |
| dotnet-conventions | C#/.NET coding standards, SOLID principles, feature patterns |
| xunit-testing | xUnit test patterns with mocking frameworks |

## Usage

\`\`\`bash
cp -r examples/stacks/dotnet/skills/* .github/skills/
\`\`\`
```

#### `examples/stacks/dotnet/instructions/dotnet.instructions.md`

Extract any .NET-specific references found in agent files or instruction files during compression. At minimum, the `dotnet build` reference from git.instructions.md gets a home here.

#### `examples/copilot-instructions-example.md`

A filled-in version of `copilot-instructions.md` showing a realistic example (e.g., a fictional "TaskTracker" app with TypeScript + React + PostgreSQL). Every placeholder replaced with example values. Add a header comment: "This is an example. Copy .github/copilot-instructions.md and fill in your own values."

---

## Work Area 4: Docs & Repo Structure

### 4.1 Create `.gitignore`

```gitignore
# Agent artifacts
.playwright-cli/
.github/agent-journals/*.journal.md
# Note: .github/agent-journals/.gitkeep must remain tracked (the glob above only matches *.journal.md)
issue/

# Dependencies
node_modules/

# Test output
playwright-report/
test-results/

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
```

### 4.2 Restructure README.md

Merge AGENTS.md content. New structure:

1. **Header** — one-line description
2. **Prerequisites** — Copilot tier, CLI version, supported runtimes
3. **Quick Start** — two options only (Template, Copy). Remove submodule option or demote to footnote.
4. **Verify It Works** — smoke test step (e.g., "ask the coordinator to introduce the team")
5. **Customization** — copilot-instructions.md, skills, adding agents, stack examples
6. **Team Roster** — table from AGENTS.md (the useful part)
7. **Architecture** — diagram (keep, it's good)
8. **Stack Examples** — point to `examples/stacks/`
9. **Maskorama** — brief mention, not a section (demote from current prominence)
10. **Why no CI/CD?** — one-line note: agent files are markdown, nothing to lint/build
11. **License**

Brownfield warning: Add note about existing `.github/copilot-instructions.md` — don't blindly overwrite. Merge manually.

Cross-platform: Replace `/tmp/` reference with current directory.

### 4.3 Delete AGENTS.md

After merging its content into README.

### 4.4 Restructure copilot-instructions.md

- Split sections into Required (Product Context, Commands) and Optional (Page Routes, MCP Servers)
- Add "Minimum Viable Config" callout — fill in Product Context + Commands + one Convention to get started
- Remove HTML comments (they waste tokens at runtime — agents read this file)
- Keep placeholders but make them tighter

---

## Work Area 5: fix-issue.prompt.md

- Add: "This workflow is executed by the **coordinator**" at the top
- Verify it doesn't reference platform-specific tool names

---

## Git Workflow

Branch: `chore/optimize-agent-team` (create from current HEAD)

### Commit sequence (suggested grouping)

1. `chore: add .gitignore` — .gitignore only
2. `chore: move .NET skills to examples/stacks/dotnet` — file moves + dotnet README
3. `chore: extract shared instruction files` — 4 new instruction files

> **Note**: Commit 3 creates shared instruction files AND removes the extracted boilerplate blocks from all agent files. Commit 4 then compresses the remaining agent content. These are tightly coupled — do not leave duplicated content between commits.

1. `refactor: compress agent files` — all 9 agents compressed + tool name genericization
2. `fix: resolve cross-agent contradictions` — routing table, reviewer tools, product rename, security checklist alignment
3. `fix: repair broken references in instruction files` — git.instructions.md, safety.instructions.md
4. `docs: restructure README and merge AGENTS.md` — README rewrite, AGENTS.md delete
5. `docs: restructure copilot-instructions.md and add example` — template + filled example
6. `chore: update fix-issue prompt` — executor specification

Each commit message includes:

```
Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
```

---

## Acceptance Criteria

- [ ] No agent file exceeds target line count (see table above)
- [ ] Zero inline references to platform-mapped tool names (`read`, `search`, `execute`, `agent` as tool, `todo`, `web`) in agent body text
- [ ] Frontmatter `tools:` declarations unchanged (except reviewer losing `agent`)
- [ ] All 4 shared instruction files created with correct `applyTo` patterns
- [ ] Extracted boilerplate removed from every agent that had it
- [ ] .NET skills exist in `examples/stacks/dotnet/skills/` with README
- [ ] `.gitignore` exists and covers all specified patterns
- [ ] `AGENTS.md` deleted; its content lives in README
- [ ] README has Prerequisites, Quick Start (no submodule), Verify It Works sections
- [ ] `copilot-instructions.md` has no HTML comments, has minimum viable config callout
- [ ] `examples/copilot-instructions-example.md` exists with all placeholders filled
- [ ] Reviewer frontmatter: `tools: [read, search, execute, web]` (no `agent`)
- [ ] Coordinator routing table includes all 9 agents (+ Explore)
- [ ] Product agent: zero instances of "Product Developer"
- [ ] `git.instructions.md`: zero instances of "dotnet"
- [ ] `safety.instructions.md`: zero references to `python.instructions.md` or `issue/TK-` convention
- [ ] `fix-issue.prompt.md` specifies coordinator as executor
- [ ] All commits on `chore/optimize-agent-team` branch with conventional commit format
- [ ] Repo builds cleanly (no broken file references between agents/instructions)
