# Copilot Agent Team

A reusable, generic agent team for GitHub Copilot, distributed as a plugin. Drop it into any repo to get a coordinated multi-agent development team — 9 specialized agents that plan, implement, test, review, and ship together.

## Prerequisites

- GitHub Copilot subscription (Business or Enterprise recommended for agent mode)
- GitHub Copilot CLI or VS Code with Copilot extension

## The Team

| Agent | Role |
|-------|------|
| **coordinator** | Orchestrates work, delegates to specialists, verifies output |
| **developer** | Implements features, fixes bugs, security review |
| **designer** | UI/UX markup, CSS, accessibility, visual verification |
| **tester** | E2E tests, regression protection, test automation |
| **reviewer** | Code review — pre-push, post-PR, and post-deploy modes |
| **product** | Discovery, user interviews, acceptance criteria |
| **platform-engineer** | CI/CD, scripting, Docker, GitHub Actions |
| **clerk** | Documents, files, planning artifacts |
| **agent-creator** | Creates new agents when capability gaps emerge |

Start with the **coordinator** for multi-step tasks — it routes work to the right specialist. Call agents directly for focused tasks (e.g., `@developer` for implementation, `@tester` for writing tests).

## Install as Copilot CLI Plugin

```bash
copilot plugin install pr0nin/copilot-agent-team:plugins/copilot-agent-team
```

Plugin agents and skills are loaded from a local cache — no files are added to your repo.

Manage the plugin:

```bash
copilot plugin list                          # See installed plugins
copilot plugin update copilot-agent-team     # Pull latest version
copilot plugin disable copilot-agent-team    # Temporarily disable
copilot plugin enable copilot-agent-team     # Re-enable
copilot plugin uninstall copilot-agent-team  # Remove
```

> **⚡ Important — run `team-init` after install:**
> Ask Copilot *"Run team-init to set up the agent team for this repo"*. This scans your project and configures `copilot-instructions.md` — detecting your language, framework, build commands, architecture, and conventions. Without this step, the agents work but don't know your stack.

### Next Steps

- **Verify it works**: Ask the coordinator *"Introduce the team and explain what each agent does."*
- **Customize agents**: Project-level agents in `.github/agents/` override plugin agents. Copy any `.agent.md` file into your repo and edit it there.
- **Add skills**: Skills live in `.github/skills/`. Each skill has a `SKILL.md` with frontmatter and content.
- **Stack-specific examples**: See [`examples/stacks/`](examples/stacks/) for stack-specific skills and instructions (e.g., .NET, Blazor, xUnit).

## Install as VS Code Plugin

> ⚠️ VS Code agent plugins are currently in **Preview**.

1. Open the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
2. Run **Chat: Install Plugin From Source**
3. Enter: `https://github.com/pr0nin/copilot-agent-team`
4. If prompted, specify plugin path: `plugins/copilot-agent-team`

No files are added to your repo. Manage the plugin from the Extensions view → **Agent Plugins - Installed**: enable, disable, or uninstall per-workspace or globally.

If VS Code does not support subpath plugin resolution, clone the repo and install from the CLI instead:

```bash
copilot plugin install ./plugins/copilot-agent-team
```

> **⚡ Important — run `team-init` after install:**
> Ask Copilot *"Run team-init to set up the agent team for this repo"*. This scans your project and configures `copilot-instructions.md` — detecting your language, framework, build commands, architecture, and conventions. Without this step, the agents work but don't know your stack.

### Next Steps

- **Verify it works**: Ask the coordinator *"Introduce the team and explain what each agent does."*
- **Customize agents**: Project-level agents in `.github/agents/` override plugin agents. Copy any `.agent.md` file into your repo and edit it there.
- **Add skills**: Skills live in `.github/skills/`. Each skill has a `SKILL.md` with frontmatter and content.
- **Stack-specific examples**: See [`examples/stacks/`](examples/stacks/) for stack-specific skills and instructions (e.g., .NET, Blazor, xUnit).

## Developing the Plugin

This repo has a dual layout:

- **`plugins/copilot-agent-team/`** — the distributable plugin. This is what consumers install. Contains the agent definitions, skills, examples, and `plugin.json` manifest.
- **`.github/agents/` and `.github/skills/`** — the same agent team, used for developing this repo itself (dogfooding). Changes here do **not** affect the distributed plugin.

When developing, edit files in `plugins/copilot-agent-team/` and test locally:

```bash
# Install the plugin locally for testing
copilot plugin install ./plugins/copilot-agent-team

# Reinstall after making plugin changes
copilot plugin install ./plugins/copilot-agent-team

# Uninstall when done testing
copilot plugin uninstall copilot-agent-team
```

### Conventions

- **Commits**: Conventional commits — `feat:`, `fix:`, `chore:`, `docs:`
- **Branches**: `feature/`, `fix/`, `chore/`, `docs/` prefix with kebab-case (e.g., `feature/add-new-skill`)
- **PRs**: Reference issues with `Closes #N`
- **Agent files**: `<name>.agent.md`
- **Instruction files**: `<name>.instructions.md`
- **Skills**: kebab-case directory with `SKILL.md` inside

See [docs/architecture.md](docs/architecture.md) for the coordination model and design patterns.

## License

[Choose your license]
