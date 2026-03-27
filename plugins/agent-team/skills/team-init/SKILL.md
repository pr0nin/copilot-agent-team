---
name: team-init
description: >
  Onboard the agent team into a new or existing repository. Analyzes the host repo to fill in
  copilot-instructions.md template placeholders — or merge agent team sections into an existing
  copilot-instructions.md. Detects product name, architecture, commands, conventions, routes,
  and key components. Similar to `copilot init` but for the agent team.
  Use when: onboarding, hire a team, team init, setup, initialize, first run, copilot init, brownfield, merge instructions
---

# Team Init — Repo Onboarding

Analyze the host repo and fill in `.github/copilot-instructions.md` placeholders automatically.

## Steps

### 0. Detect installation context

Before beginning, determine how the agent team was installed:

**Check**: Do `.agent.md` files exist in the project's `.github/agents/` directory?

**Plugin context** (no local agent files — team runs from a plugin):
- Inform the user: *"Agents are provided by the copilot-agent-team plugin — no agent files will be copied into your repo."*
- Skip Step 2 (agent collision detection) — plugin agents are read-only
- In Step 8, only create/update `.github/copilot-instructions.md` and `.github/agent-journals/` directory
- Do NOT copy agent files, instruction files, or prompt files into the project
- Remind the user: *"To customize an agent, copy its `.agent.md` from the plugin into `.github/agents/` — local agents override plugin agents."*

**Local context** (agent files exist in `.github/agents/`):
- Proceed with the full flow including collision detection and file management

### 1. Detect project type
- Scan repo root for: `package.json`, `*.csproj`/`*.sln`, `pyproject.toml`/`setup.py`, `go.mod`, `Cargo.toml`, `pom.xml`/`build.gradle`, `Gemfile`, `composer.json`, `mix.exs`
- Note monorepo indicators: `workspaces`, `lerna.json`, `nx.json`, `turbo.json`

### 2. Check for agent collisions

Before writing any files, scan the host repo for agents that may conflict with the incoming team.

**Locate existing agents:**
- Search for `*.agent.md` files anywhere in the repo (common paths: `.github/agents/`, `.vscode/agents/`, `.copilot/agents/`)
- Also check `AGENTS.md` / `agents.md` for inline agent definitions
- If nothing is found, skip the rest of this step silently

**Parsing `AGENTS.md`:**
AGENTS.md files have no standard format. Try these extraction strategies in order:
1. **YAML frontmatter blocks** — look for `---` delimited blocks with `name` and `description` keys
2. **Heading-based sections** — each `##` or `###` heading is an agent name; the body text below is the description
3. **Markdown tables** — columns like `Name | Description | …`; each row is an agent
4. **Prose paragraphs** — look for bold agent names (`**name**`) followed by a colon and description text

Extract from each agent found: a name and a description (first 200 chars if longer).

**Build a collision map:**
For each existing agent found, extract:
- Its filename stem (e.g. `guru` from `guru.agent.md`)
- Its `description` frontmatter field — or the first 200 chars of body text if no frontmatter
- All "Use when:" trigger phrases

Compare against every incoming team agent (coordinator, clerk, platform-engineer, developer, tester, designer, agent-creator, product, reviewer) using three detection layers.

**Layer 1 — Name collision (exact match or known alias):**

Check the existing agent's filename stem against this alias table:

| Incoming agent | Also matches these names |
|---|---|
| `coordinator` | `lead`, `orchestrator`, `manager`, `hub`, `conductor` |
| `clerk` | `writer`, `docs`, `scribe`, `secretary`, `note-taker` |
| `platform-engineer` | `devops`, `infra`, `sre`, `ops`, `infrastructure`, `deploy` |
| `developer` | `coder`, `dev`, `engineer`, `programmer`, `implementer` |
| `tester` | `qa`, `quality`, `test-engineer`, `test-runner`, `testing` |
| `designer` | `ux`, `ui`, `ux-designer`, `ui-engineer`, `design`, `css` |
| `agent-creator` | `agent-builder`, `factory`, `agent-maker`, `meta-agent` |
| `product` | `pm`, `product-manager`, `product-owner`, `po`, `planner` |
| `reviewer` | `auditor`, `checker`, `code-reviewer`, `linter`, `gate` |

Before comparing, normalize all names: lowercase, then replace underscores and spaces with hyphens (e.g. `platform_engineer` → `platform-engineer`). A hit on any alias → flag as name collision.

**Layer 2 — Keyword overlap (proportional threshold):**

Tokenize "Use when:" trigger phrases by splitting on commas, then trimming whitespace, and discarding any empty tokens (for example, from trailing commas or ellipses). Treat each comma-separated phrase as one keyword (e.g. "shell scripting" is one keyword, not two). Comparison is case-insensitive.

Compute: `overlap_ratio = overlapping_keywords / min(count_A, count_B)`, where `count_A` and `count_B` are the numbers of non-empty keywords for each agent after tokenization.

Flag a **keyword collision** when `overlap_ratio ≥ 0.30` (i.e. ≥ 30% of the shorter keyword list overlaps).

**Layer 3 — Semantic domain judgment:**

Even when Layers 1 and 2 find no match, flag a **semantic collision** if, in your judgment, both agents would be invoked for the same class of user requests. Two agents can describe the same functional domain using entirely different vocabulary (e.g. "manages deployment pipelines, container orchestration" vs. "Docker CLI, Dockerfile, docker-compose"). Consider:
- Would a user's request plausibly route to both agents?
- Do they operate on the same file types, tools, or system boundaries?
- Do their descriptions target the same workflow stage (build, test, deploy, review)?

If any layer flags a collision, proceed to the interview below.

**Conduct an interview for each detected collision:**

Present a collision card:

```
⚠️  Potential conflict detected

Incoming agent : platform-engineer
Your agent     : guru  (.github/agents/guru.agent.md)

--- Incoming "Use when" ---
command line, shell scripting, bash, zsh, PowerShell, terminal, CLI tools,
cross-platform scripting, GitHub Actions, CI/CD …

--- Your "Use when" ---
command line, shell scripting, bash, zsh, PowerShell, terminal …

Overlapping keywords: command line, shell scripting, bash, zsh, PowerShell, terminal
```

Then ask the user:

> How would you like to resolve this?
>
> **A** — Keep the **incoming agent** (`platform-engineer` replaces `guru`)  
> **B** — Keep **your agent** (skip installing `platform-engineer`)  
> **C** — Keep **both** (rename the incoming one, e.g. `team-platform-engineer`)  
> **D** — **Merge** (draft a combined agent together)  
> **E** — Show me the full content of both agents first

- **D (Merge):** Draft a merged `description` and system-prompt that combines both. Present it, iterate until the user approves, and use the merged file going forward.
- **E (Review):** Display full file contents of both agents side by side, then loop back to the choice.

Collect all decisions before proceeding. Do not write any agent files until every collision is resolved.

**Carry these decisions forward into the later step where you write or overwrite agent files:**
- **A / D**: write the incoming (or merged) agent file, overwriting the existing one
- **B**: skip writing that incoming agent entirely
- **C**: write the incoming agent under the agreed new name; leave the existing file untouched

### 3. Infer product info
- Read `README.md` — first H1 = product name, first paragraph = description
- Fallbacks: `package.json` `name`+`description`, `pyproject.toml` `[project]`, `*.csproj` `<RootNamespace>`, `Cargo.toml` `[package]`

### 4. Detect commands
- `package.json` → `scripts` (`build`, `dev`, `start`, `test`, `lint`)
- `Makefile` → target names; `pyproject.toml` → `[project.scripts]`; fallback `pytest`
- `.csproj`/`.sln` → `dotnet build/run/test`; `go.mod` → `go build/run/test ./...`
- `Cargo.toml` → `cargo build/run/test`; `docker-compose.yml` → `docker compose up`

### 5. Map architecture
- List top-level dirs; identify `src/`, `lib/`, `app/`, `api/`, `web/`, `packages/`, `services/`
- Build depth-2 directory tree → **Solution structure** block
- Identify key components (API, UI, DB, shared libs) → **Key components** table

### 6. Detect conventions
- **Framework**: infer from deps (`react`, `next`, `vue`, `angular`, `fastapi`, `flask`, `django`, `express`, `blazor`, `gin`)
- **Styling**: `tailwind.config.*`, `postcss.config.*`, `*.module.css`, `*.scss`, `styled-components`
- **Testing**: `jest.config.*`, `vitest.config.*`, `playwright.config.*`, `pytest.ini`, `*.test.*`, `*.spec.*`
- **API**: `graphql`, `trpc`, REST patterns, `.proto` files
- **Naming**: observe existing files — kebab-case, PascalCase, snake_case

### 7. Detect routes
- **Next.js**: `app/` or `pages/` dirs; **React Router**: `<Route`, `createBrowserRouter`
- **ASP.NET**: `[Route(`, `MapGet(`, `MapPost(`; **FastAPI/Flask**: `@app.get`, `@app.route`, `@router`
- **Express**: `router.get`, `app.get`; **Rails**: `config/routes.rb`
- Fill **Page Routes** table; omit if no routes found

### 8. Fill or merge template

**Plugin context**: Only create/update `.github/copilot-instructions.md` with discovered values and ensure `.github/agent-journals/` directory exists. Do not copy any agent, instruction, or prompt files. Skip to Step 9.

**Greenfield** (template placeholders present):
- Replace every `[placeholder]` in `.github/copilot-instructions.md` with discovered values
- Remove unfilled placeholder rows; preserve **Agent Team** and **MCP Servers** sections

**Brownfield** (existing `copilot-instructions.md` with real content):
- Read the existing file fully before making changes
- Identify which sections already have project-specific content — preserve them
- For sections that exist in both: propose a merged version, showing what's new from the team template alongside existing content. Never silently overwrite user content.
- For sections only in the template (e.g., Agent Team, MCP Servers): append them
- For sections only in the existing file: keep them untouched
- If the existing file uses a different structure/format: adapt the team sections to match, don't restructure the user's file
- Show a diff-style summary of proposed changes before writing

### 9. Ask user
- Ask the user for anything not auto-detected (goals, state management, patterns)
- Batch related questions into a single prompt

### 10. Verify
- Show the filled-in file and ask for confirmation before writing
- Apply requested changes and re-confirm
