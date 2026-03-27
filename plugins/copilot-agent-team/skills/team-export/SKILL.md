---
name: team-export
description: >
  Export agent team files from the copilot-agent-team plugin into your repo for full local ownership.
  Copies agent definitions to .github/agents/, shared instructions to .github/agents/instructions/,
  and prompts to .github/agents/prompts/ so you can customize them freely. After export, local agents
  override plugin agents.
  Use when: export, scaffold, detach, eject, copy agents locally, customize agents, own agents, local agents
---

# Team Export — Plugin to Local

Export the copilot-agent-team plugin's agent files into your repo's `.github/` directory for full local ownership and customization.

## When to use

- You want to customize agent definitions beyond single-file overrides
- You want full local control over the agent team
- You're transitioning from plugin-managed to locally-managed agents

## What gets exported

| Content | Source (plugin) | Destination (your repo) |
|---------|----------------|------------------------|
| 9 agent definitions | `agents/*.agent.md` | `.github/agents/` |
| 9 shared instructions | `agents/instructions/*.instructions.md` | `.github/agents/instructions/` |
| 1 prompt | `agents/prompts/*.prompt.md` | `.github/agents/prompts/` |

## What does NOT get exported

- **Skills** (team-init, team-export, playwright-cli, maskorama) — continue to work from the plugin
- **copilot-instructions.md** — already handled by `team-init`
- **agent-journals/** — runtime state, not agent definitions
- **examples/** — reference material, stays in the plugin

## Steps

### 1. Confirm intent

Ask the user to confirm:

> **Team Export** will copy 19 agent files (9 agents, 9 instructions, 1 prompt) from the copilot-agent-team plugin into your repo's `.github/agents/` directory.
>
> After export, you own these files — edit them freely. Local agents override plugin agents.
>
> Skills (team-init, team-export, playwright-cli, maskorama) will continue to work from the plugin.
>
> Proceed? (yes/no)

If the user declines, stop.

### 2. Detect conflicts

Check if any of the following already exist in the project:

- `.github/agents/*.agent.md` files
- `.github/agents/instructions/*.instructions.md` files
- `.github/agents/prompts/*.prompt.md` files

**If conflicts are found**, list them and ask the user to choose:

> **Existing files detected:**
> - `.github/agents/developer.agent.md`
> - `.github/agents/instructions/git.instructions.md`
> - *(list all conflicts)*
>
> Choose how to proceed:
> 1. **Overwrite all** — replace existing files with plugin versions
> 2. **Skip existing** — only copy files that don't already exist
> 3. **Abort** — cancel the export

**If no conflicts**, proceed directly to Step 3.

### 3. Create directory structure

Ensure these directories exist:

```
.github/agents/
.github/agents/instructions/
.github/agents/prompts/
```

### 4. Copy and annotate files

For each file being exported:

1. Read the source file content from the plugin
2. First, read the `version` field from the plugin's `plugin.json` file. Then insert an ownership comment **immediately after the YAML frontmatter closing `---`** (or at the top if no frontmatter):

```
<!-- Exported from copilot-agent-team plugin (v{VERSION}). You own this file — edit freely. -->
```

Where `{VERSION}` is the version read from `plugin.json` (e.g., `0.0.1`).

3. Write the annotated content to the destination path

**Files to copy:**

**Agent definitions** (from plugin `agents/` → `.github/agents/`):
- `clerk.agent.md`
- `coordinator.agent.md`
- `designer.agent.md`
- `developer.agent.md`
- `platform-engineer.agent.md`
- `product.agent.md`
- `reviewer.agent.md`
- `tester.agent.md`
- `agent-creator.agent.md`

**Shared instructions** (from plugin `agents/instructions/` → `.github/agents/instructions/`):
- `clarification-policy.instructions.md`
- `designer-developer-collab.instructions.md`
- `escalation.instructions.md`
- `git.instructions.md`
- `github-file-maintenance.instructions.md`
- `journal.instructions.md`
- `playwright-artifacts.instructions.md`
- `safety.instructions.md`
- `verification.instructions.md`

**Prompts** (from plugin `agents/prompts/` → `.github/agents/prompts/`):
- `fix-issue.prompt.md`

### 5. Print summary

After all files are processed, display:

> **Export complete!**
>
> - **Copied**: X files
> - **Skipped**: Y files (already existed)
>
> Your agent team is now locally managed. Key things to know:
> - ✏️ **Edit freely** — these files are yours now
> - 🔄 **Local overrides plugin** — your `.github/agents/` files take priority over plugin versions
> - 🔌 **Plugin still active** — skills (team-init, team-export, playwright-cli, maskorama) still come from the plugin
> - 🗑️ **Optional cleanup** — run `copilot plugin uninstall copilot-agent-team` if you no longer need the plugin (skills will stop working)
>
> **Tip**: To see what changed in newer plugin versions, compare your files against the latest plugin release.
