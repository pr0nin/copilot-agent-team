# Copilot Agent Team

A reusable, generic agent team for [GitHub Copilot CLI](https://docs.github.com/en/copilot). Drop it into any repo to get a coordinated multi-agent development team out of the box.

## What's included

### Core Team (9 agents)

| Agent | Role | Key responsibility |
|-------|------|--------------------|
| **coordinator** | Technical program manager | Orchestrates work, delegates to specialists, verifies output |
| **developer** | Senior fullstack developer | Implements features, security review, end-to-end verification |
| **designer** | UX/design engineer | UI markup, CSS/styling, accessibility, visual verification |
| **tester** | Test engineer | E2E tests, regression protection, usability testing |
| **reviewer** | Code reviewer | Pre-push, post-PR, and post-deploy review (3 modes) |
| **product** | Product developer | Discovery, user interviews, acceptance criteria, plan critique |
| **platform-engineer** | Platform/tooling specialist | CI/CD, shell scripting, Docker, GitHub Actions, versioning |
| **clerk** | Administrative assistant | Documents, files, planning artifacts, journals |
| **agent-creator** | Agent designer | Creates new agents when capability gaps are found |

### Generic Instructions (3 files)

- **clarification-policy** — Stop and ask when uncertain
- **git** — Branch naming, conventional commits, PR conventions
- **safety** — Auto-execute vs confirm policy for destructive operations

### Prompt Workflows (1 file)

- **fix-issue** — End-to-end: read issue → plan → branch → implement → PR

### Optional Skills

| Skill | Description |
|-------|-------------|
| **playwright-cli** | Browser automation for testing, screenshots, form filling |
| **maskorama** | Opt-in animal persona system via structured interviews |
| **dotnet-conventions** | C#/.NET coding standards and feature patterns |
| **blazor-conventions** | Blazor SSR component patterns and best practices |
| **xunit-testing** | xUnit test patterns with FakeItEasy/NSubstitute |

## Quick Start

### Option 1: Use as GitHub Template

1. Click **"Use this template"** on GitHub to create a new repo
2. Edit `.github/copilot-instructions.md` with your project details
3. Delete any skills you don't need from `.github/skills/`

### Option 2: Copy into an existing repo

```bash
# Clone the template
git clone https://github.com/YOUR_ORG/copilot-agent-team /tmp/agent-team

# Copy into your project
cp -r /tmp/agent-team/.github/agents your-repo/.github/agents
cp -r /tmp/agent-team/.github/skills your-repo/.github/skills
cp -r /tmp/agent-team/.github/agent-journals your-repo/.github/agent-journals

# Don't forget to edit copilot-instructions.md for your project
cp /tmp/agent-team/.github/copilot-instructions.md your-repo/.github/copilot-instructions.md
```

### Option 3: Git submodule (for update tracking)

```bash
# Add as submodule
git submodule add https://github.com/YOUR_ORG/copilot-agent-team .github/agent-team-base

# Symlink or copy what you need
cp -r .github/agent-team-base/.github/agents .github/agents
```

## Customization

### Add project context

Edit `.github/copilot-instructions.md` — this is the main file agents reference for your project's architecture, commands, conventions, and stack.

### Add/remove skills

Skills live in `.github/skills/`. Delete any you don't need. To add a skill, create a directory with a `SKILL.md` file:

```
.github/skills/your-skill/
└── SKILL.md    # Frontmatter (name, description, applyTo) + content
```

### Activate Maskorama (animal personas)

Give your agents personality! The maskorama skill uses a structured interview where each agent discovers their own animal identity:

1. Ask the coordinator to "run maskorama for the team"
2. The coordinator interviews each agent about their working style
3. Each agent chooses their own animal, emoji, and speech rituals
4. Persona cards are added to agent files

See `.github/skills/maskorama/SKILL.md` for the full workflow and `.github/skills/maskorama/default-pack.md` for an example set.

### Add domain-specific agents

Create a new `.agent.md` file in `.github/agents/`:

```markdown
---
description: "Your agent description and trigger keywords"
tools: [read, edit, search, execute, web, todo, agent]
---

# Role
...

# Constraints
...
```

The **agent-creator** agent can also build new agents for you — just ask the coordinator.

### Add stack-specific instructions

Create instruction files in `.github/agents/instructions/`:

```markdown
---
applyTo: "**/*.py"
---

# Python Conventions
...
```

### Wire up MCP servers

Document your MCP servers in `.github/copilot-instructions.md` so agents know what tools are available. Then add the specific MCP tools to relevant agents' `tools` lists in their frontmatter.

## Architecture

```
                     Coordinator
                          │
        ┌────────┬────────┼────────┬────────┐
        │        │        │        │        │
    Developer  Designer  Tester  Product   Platform Eng
        │        │                          │
        └───↔────┘                    (relay/escalation)
     (direct collab)
                    
    Support roles:
    ├── Clerk (documents/files)
    ├── Reviewer (code review, 3 modes)
    └── Agent Creator (builds new agents)
```

**Key patterns:**
- **Hub-and-spoke**: Coordinator delegates all work, never edits files directly
- **Direct collaboration**: Designer ↔ Developer work together without coordinator in the loop during UI iterations
- **Platform engineer relay**: All agents escalate CLI/CI/CD/infrastructure questions to the `platform-engineer` agent
- **Journals**: Each agent maintains a private journal at `.github/agent-journals/<name>.journal.md`

## License

[Choose your license]
