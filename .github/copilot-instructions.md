# Copilot Instructions

## Product Context

**Product name**: copilot-agent-team

**Description**: A reusable, generic agent team for GitHub Copilot, distributed as a plugin. Drop it into any repo to get a coordinated multi-agent development team out of the box.

**Key goals**:
- Easy distribution via `copilot plugin install`
- Automatic updates for consuming teams
- Zero clutter in consumer repos
- Marketplace discoverability for core and niche plugins

---

## Architecture

**Solution structure**:
```
plugins/
  copilot-agent-team/        # The distributable plugin
    plugin.json              # Plugin manifest
    agents/                  # 9 core agents + instructions + prompts
    skills/                  # team-init, playwright-cli, maskorama
    examples/                # Stack-specific examples
.github/
  agents/                    # This repo's agent definitions (development)
  skills/                    # This repo's skills (development)
  copilot-instructions.md    # This file (repo-specific config)
  agent-journals/            # Agent working notes (gitignored)
  plugin/
    marketplace.json         # Marketplace manifest
```

**Key components**:
| Component | Purpose |
|-----------|---------|
| `plugins/copilot-agent-team/` | The distributable plugin package |
| `plugins/copilot-agent-team/agents/` | Core agent team definitions (.agent.md files) |
| `plugins/copilot-agent-team/skills/` | Reusable skills (team-init, playwright-cli, maskorama) |
| `plugins/copilot-agent-team/plugin.json` | Plugin manifest for CLI and VS Code installation |
| `.github/plugin/marketplace.json` | Marketplace manifest listing available plugins |
| `.github/agents/` | This repo's development agents (same team, for dogfooding) |

---

## Commands

No build, run, or test commands — this is a markdown-only project.

### Development Setup
```bash
# Install the plugin locally for testing
copilot plugin install ./plugins/copilot-agent-team

# Reinstall after making plugin changes
copilot plugin install ./plugins/copilot-agent-team

# Uninstall when done testing
copilot plugin uninstall copilot-agent-team
```

---

## Conventions

- **Language**: Markdown (agent definitions, skills, instructions)
- **Commits**: Conventional commits (`feat:`, `fix:`, `chore:`, `docs:`)
- **Branches**: `feature/`, `fix/`, `chore/`, `docs/` prefix with kebab-case description
- **PRs**: Reference issues with `Closes #N`

### Naming
- Files: kebab-case (e.g., `platform-engineer.agent.md`)
- Agent files: `<name>.agent.md`
- Instruction files: `<name>.instructions.md`
- Skill directories: kebab-case with `SKILL.md` inside

---

## Agent Team

This project uses a multi-agent team. See `.github/agents/` for individual agent definitions.

**Core team**: coordinator, clerk, platform-engineer, developer, tester, designer, agent-creator, product, reviewer

**Coordination model**: Hub-and-spoke with the coordinator at the center. The coordinator delegates work, verifies output, and synthesizes results. Agents collaborate directly when appropriate (e.g., designer ↔ developer for UI work).
