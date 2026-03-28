# Copilot Agent Team

A reusable, generic agent team for GitHub Copilot, distributed as a plugin. Drop it into any repo to get a coordinated multi-agent development team — 9 specialized agents that plan, implement, test, review, and ship together.

## Prerequisites

- GitHub Copilot subscription (Pro probably required for agent mode)
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

## Add Copilot Agent Team Marketplace

```bash
copilot plugin marketplace add pr0nin/copilot-agent-team
```

Manage the marketplace:
```bash
$ copilot plugin marketplace browse copilot-agent-team
# Plugins in "copilot-agent-team":
#   • agent-team - A coordinated multi-agent development team — 9 agents, 
#       3 skills, shared instructions. Drop into any repo for instant team coverage.

# Install with: copilot plugin install <plugin-name>@copilot-agent-team
```

## Install as Copilot CLI Plugin

```bash
copilot plugin install pr0nin/copilot-agent-team
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
- **Check skill readiness**: Ask the coordinator *"Generate a skill compatibility report for this workspace. List bundled skills, external dependencies, per-agent status (installed/missing/optional), evidence, and blockers."*
- **Customize agents**: Project-level agents in `.github/agents/` override plugin agents. Copy any `.agent.md` file into your repo and edit it there.
- **Add skills**: Skills live in `.github/skills/`. Each skill has a `SKILL.md` with frontmatter and content.

## Install as VS Code Plugin

> ⚠️ VS Code agent plugins are currently in **Preview**.

1. Open the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
2. Run **Chat: Install Plugin From Source**
3. Enter: `https://github.com/pr0nin/copilot-agent-team`
4. If prompted, specify plugin path: `plugins/agent-team`

No files are added to your repo. Manage the plugin from the Extensions view → **Agent Plugins - Installed**: enable, disable, or uninstall per-workspace or globally.

If VS Code does not support subpath plugin resolution, clone the repo and install from the CLI instead:

```bash
copilot plugin install ./plugins/agent-team
```

> **⚡ Important — run `team-init` after install:**
> Ask Copilot *"Run team-init to set up the agent team for this repo"*. This scans your project and configures `copilot-instructions.md` — detecting your language, framework, build commands, architecture, and conventions. Without this step, the agents work but don't know your stack.

### Next Steps

- **Verify it works**: Ask the coordinator *"Introduce the team and explain what each agent does."*
- **Check skill readiness**: Ask the coordinator *"Generate a skill compatibility report for this workspace. List bundled skills, external dependencies, per-agent status (installed/missing/optional), evidence, and blockers."*
- **Customize agents**: Project-level agents in `.github/agents/` override plugin agents. Copy any `.agent.md` file into your repo and edit it there.
- **Add skills**: Skills live in `.github/skills/`. Each skill has a `SKILL.md` with frontmatter and content.

## Developing the Plugin

This repo has a dual layout:

- **`plugins/agent-team/`** — the **source of truth** for all distributable agents and skills.
- **`.github/agents/` and `.github/skills/`** — generated mirrors for dogfooding this repo.

### Source-of-Truth Policy

- Edit agent/skill content in `plugins/agent-team/` only.
- Do not manually edit mirrored files in `.github/agents/` or `.github/skills/`.
- After plugin changes, regenerate mirrors:

```bash
bash scripts/sync-plugin-mirrors.sh
```

- CI enforces this with `.github/workflows/mirror-drift-check.yml` and fails if mirrors drift.

When developing, edit files in `plugins/agent-team/` and test locally:

```bash
# Install the plugin locally for testing
copilot plugin install ./plugins/agent-team

# Reinstall after making plugin changes
copilot plugin install ./plugins/agent-team

# Sync dogfooding mirrors from plugin source of truth
bash scripts/sync-plugin-mirrors.sh

# Uninstall when done testing
copilot plugin uninstall agent-team
```

### Conventions

- **Commits**: Conventional commits — `feat:`, `fix:`, `chore:`, `docs:`
- **Branches**: `feature/`, `fix/`, `chore/`, `docs/` prefix with kebab-case (e.g., `feature/add-new-skill`)
- **PRs**: Reference issues with `Closes #N`
- **Agent files**: `<name>.agent.md`
- **Instruction files**: `<name>.instructions.md`
- **Skills**: kebab-case directory with `SKILL.md` inside

### Versioning and Release

- Version bumps are automated with GitVersion via `.github/workflows/version-bump-gitversion.yml`.
- Releases are published from matching tags via `.github/workflows/release-on-tag.yml`.
- See `RELEASE.md` for the full release checklist.

See [docs/architecture.md](docs/architecture.md) for the coordination model and design patterns.

## License

MIT License. See [LICENSE](LICENSE) for details.
