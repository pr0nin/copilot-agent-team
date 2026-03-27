# Copilot Agent Team

A reusable, generic agent team for GitHub Copilot. Drop it into any repo to get a coordinated multi-agent development team out of the box.

## Prerequisites

- GitHub Copilot subscription (Business or Enterprise recommended for agent mode)
- GitHub Copilot CLI or VS Code with Copilot extension
- Supported runtimes: Cloud agents, CLI, VS Code

## Quick Start

### Option 1: Use as GitHub Template

1. Click **"Use this template"** on GitHub to create a new repo
2. Choose your agent management approach:
   - **Plugin-managed** (recommended): Delete `.github/agents/` and `.github/skills/`, then install the plugin: `copilot plugin install ./plugins/copilot-agent-team` — agents auto-update with `copilot plugin update`
   - **Local**: Keep `.github/agents/` and `.github/skills/` as-is for full local control — you manage updates manually
3. Run the **team-init** skill to auto-configure: ask Copilot *"Run team-init to set up the agent team for this repo"*

### Option 2: Copy into an existing repo

```bash
git clone https://github.com/YOUR_ORG/copilot-agent-team ./copilot-agent-team-base
mkdir -p your-repo/.github/agents your-repo/.github/skills
cp -r ./copilot-agent-team-base/plugins/copilot-agent-team/agents/. your-repo/.github/agents/
cp -r ./copilot-agent-team-base/plugins/copilot-agent-team/skills/. your-repo/.github/skills/
mkdir -p your-repo/.github/agent-journals
echo '.github/agent-journals/' >> your-repo/.gitignore
cp ./copilot-agent-team-base/plugins/copilot-agent-team/examples/copilot-instructions-example.md your-repo/.github/copilot-instructions.md
```

> **Brownfield warning**: If your repo already has `.github/copilot-instructions.md`, don't overwrite it — run `team-init` to merge the Agent Team sections automatically.

After copying, run the **team-init** skill: *"Run team-init to set up the agent team for this repo"*. It will scan your project and fill in `copilot-instructions.md` automatically — detecting your language, framework, build commands, architecture, and conventions.

> **Manual alternative**: If you prefer, edit `.github/copilot-instructions.md` by hand instead.

### Option 3: Install as Copilot CLI Plugin

```bash
copilot plugin install pr0nin/copilot-agent-team:plugins/copilot-agent-team
```

> Plugin agents and skills are loaded from a local cache — no files are added to your repo. Run `team-init` after install to configure `copilot-instructions.md` for your project.

Manage the plugin:
```bash
copilot plugin list                          # See installed plugins
copilot plugin update copilot-agent-team     # Pull latest version
copilot plugin disable copilot-agent-team    # Temporarily disable
copilot plugin enable copilot-agent-team     # Re-enable
copilot plugin uninstall copilot-agent-team  # Remove
```

> **Customization**: Project-level agents (in `.github/agents/`) override plugin agents. To customize an agent, copy its `.agent.md` file into your repo and edit it there.

### Option 4: Install as VS Code Plugin (Preview)

1. Open the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
2. Run **Chat: Install Plugin From Source**
3. Enter: `https://github.com/pr0nin/copilot-agent-team`
4. If prompted, specify plugin path: `plugins/copilot-agent-team`

> **Prerequisites**: VS Code 1.110+ with `chat.plugins.enabled` set to `true` in settings. Agent plugins are currently in **Preview**. No files are added to your repo. If VS Code does not support subpath plugin resolution, clone the repo and use `copilot plugin install ./plugins/copilot-agent-team` from the CLI instead. Run `team-init` after install to configure `copilot-instructions.md` for your project.

Manage the plugin from the Extensions view → **Agent Plugins - Installed**: enable, disable, or uninstall per-workspace or globally.

## Verify It Works

Ask the coordinator: *"Introduce the team and explain what each agent does."*

## Customization

- **Configure for your project**: Run the `team-init` skill — it auto-detects your stack and fills in `copilot-instructions.md`. Or edit it manually.
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

**Maskorama**: Opt-in animal persona system. Run the maskorama skill to activate: ask Copilot *"Run maskorama to assign animal personas to the team."*

## Plugin Marketplace

This repo also serves as a plugin marketplace. Add it as a marketplace source to browse and install available plugins:

```bash
copilot plugin marketplace add pr0nin/copilot-agent-team
copilot plugin marketplace browse copilot-agent-team
```

Future niche plugins (specialized agents, domain-specific skills) will be listed here for side-by-side installation with the core team.

## Why no CI/CD?

Agent files are markdown — there's nothing to lint, build, or test in CI.

## License

[Choose your license]
