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

### 1. Detect project type
- Scan repo root for: `package.json`, `*.csproj`/`*.sln`, `pyproject.toml`/`setup.py`, `go.mod`, `Cargo.toml`, `pom.xml`/`build.gradle`, `Gemfile`, `composer.json`, `mix.exs`
- Note monorepo indicators: `workspaces`, `lerna.json`, `nx.json`, `turbo.json`

### 2. Infer product info
- Read `README.md` — first H1 = product name, first paragraph = description
- Fallbacks: `package.json` `name`+`description`, `pyproject.toml` `[project]`, `*.csproj` `<RootNamespace>`, `Cargo.toml` `[package]`

### 3. Detect commands
- `package.json` → `scripts` (`build`, `dev`, `start`, `test`, `lint`)
- `Makefile` → target names; `pyproject.toml` → `[project.scripts]`; fallback `pytest`
- `.csproj`/`.sln` → `dotnet build/run/test`; `go.mod` → `go build/run/test ./...`
- `Cargo.toml` → `cargo build/run/test`; `docker-compose.yml` → `docker compose up`

### 4. Map architecture
- List top-level dirs; identify `src/`, `lib/`, `app/`, `api/`, `web/`, `packages/`, `services/`
- Build depth-2 directory tree → **Solution structure** block
- Identify key components (API, UI, DB, shared libs) → **Key components** table

### 5. Detect conventions
- **Framework**: infer from deps (`react`, `next`, `vue`, `angular`, `fastapi`, `flask`, `django`, `express`, `blazor`, `gin`)
- **Styling**: `tailwind.config.*`, `postcss.config.*`, `*.module.css`, `*.scss`, `styled-components`
- **Testing**: `jest.config.*`, `vitest.config.*`, `playwright.config.*`, `pytest.ini`, `*.test.*`, `*.spec.*`
- **API**: `graphql`, `trpc`, REST patterns, `.proto` files
- **Naming**: observe existing files — kebab-case, PascalCase, snake_case

### 6. Detect routes
- **Next.js**: `app/` or `pages/` dirs; **React Router**: `<Route`, `createBrowserRouter`
- **ASP.NET**: `[Route(`, `MapGet(`, `MapPost(`; **FastAPI/Flask**: `@app.get`, `@app.route`, `@router`
- **Express**: `router.get`, `app.get`; **Rails**: `config/routes.rb`
- Fill **Page Routes** table; omit if no routes found

### 7. Fill or merge template

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

### 8. Ask user
- Ask the user for anything not auto-detected (goals, state management, patterns)
- Batch related questions into a single prompt

### 9. Verify
- Show the filled-in file and ask for confirmation before writing
- Apply requested changes and re-confirm
