# Copilot Agent Team

A reusable, generic agent team for GitHub Copilot. Drop it into any repo to get a coordinated multi-agent development team out of the box.

## Prerequisites

- GitHub Copilot subscription (Business or Enterprise recommended for agent mode)
- GitHub Copilot CLI or VS Code with Copilot extension
- Supported runtimes: Cloud agents, CLI, VS Code

## Quick Start

### Option 1: Use as GitHub Template

1. Click **"Use this template"** on GitHub to create a new repo
2. Edit `.github/copilot-instructions.md` with your project details
3. Delete any skills you don't need from `.github/skills/`

### Option 2: Copy into an existing repo

```bash
git clone https://github.com/YOUR_ORG/copilot-agent-team ./copilot-agent-team-base
cp -r ./copilot-agent-team-base/.github/agents your-repo/.github/agents
cp -r ./copilot-agent-team-base/.github/skills your-repo/.github/skills
cp -r ./copilot-agent-team-base/.github/agent-journals your-repo/.github/agent-journals
cp ./copilot-agent-team-base/.github/copilot-instructions.md your-repo/.github/copilot-instructions.md
```

> **Brownfield warning**: If your repo already has `.github/copilot-instructions.md`, don't blindly overwrite it — merge the Agent Team section manually.

## Verify It Works

Ask the coordinator: *"Introduce the team and explain what each agent does."*

## Customization

- **Add project context**: Edit `.github/copilot-instructions.md` — the main file agents reference for your project's architecture, commands, and conventions.
- **Add/remove skills**: Skills live in `.github/skills/`. Each skill has a `SKILL.md` with frontmatter and content.
- **Add domain-specific agents**: Create `.agent.md` files in `.github/agents/`, or ask the agent-creator.
- **Add stack-specific instructions**: Create instruction files in `.github/agents/instructions/`.
- **Wire up MCP servers**: Document your MCP servers in `.github/copilot-instructions.md` so agents know what tools are available.

## Team Roster

| Agent | Role | Key responsibility |
|-------|------|--------------------|
| **coordinator** | Technical program manager | Orchestrates work, delegates, verifies output |
| **developer** | Fullstack developer | Implements features, security review |
| **designer** | UX/design engineer | UI markup, CSS, accessibility, visual verification |
| **tester** | Test engineer | E2E tests, regression protection |
| **reviewer** | Code reviewer | Pre-push, post-PR, post-deploy review (3 modes) |
| **product** | Product | Discovery, user interviews, acceptance criteria |
| **platform-engineer** | Platform/tooling specialist | CI/CD, scripting, Docker, GitHub Actions |
| **clerk** | Administrative assistant | Documents, files, journals |
| **agent-creator** | Agent designer | Creates new agents for capability gaps |

**How to work with the team:**
- **Start with the coordinator** for multi-step tasks — it routes work to the right specialist
- **Call agents directly** for focused tasks (e.g., `@developer` for implementation, `@tester` for writing tests)
- **Check journals** at `.github/agent-journals/` for agent decision history and working notes

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
- **Platform engineer relay**: All agents escalate CLI/CI/CD/infrastructure questions to the platform-engineer
- **Journals**: Each agent maintains a private journal at `.github/agent-journals/<name>.journal.md`

## Stack Examples

Stack-specific skills and instructions are in `examples/stacks/`. Currently available: .NET (Blazor, dotnet-conventions, xUnit).

**Maskorama**: Opt-in animal persona system. See `.github/skills/maskorama/` for details.

## Why no CI/CD?

Agent files are markdown — there's nothing to lint, build, or test in CI.

## License

[Choose your license]
