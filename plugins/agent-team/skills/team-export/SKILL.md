---
name: team-export
description: >
  Export agent team files from the copilot-agent-team plugin into your repo for full local ownership.
  Copies agent definitions to .github/agents/, shared instructions to .github/agents/instructions/,
  and prompts to .github/agents/prompts/ so you can customize them freely. After export, local agents
  override plugin agents. Uses an exact-path preflight and a merge-first update flow for pre-existing files.
  Use when: export, scaffold, detach, eject, copy agents locally, customize agents, own agents, local agents
---

# Team Export — Plugin to Local

Export the copilot-agent-team plugin's agent files into your repo's `.github/` directory for full local ownership and customization.

## When to use

- You want to customize agent definitions beyond single-file overrides
- You want full local control over the agent team
- You're transitioning from plugin-managed to locally-managed agents

## Relationship with team-init

- `team-export` and `team-init` solve different problems and should not be hard-coupled.
- `team-export` manages agent/instruction/prompt ownership in `.github/agents/`.
- `team-init` analyzes the repo and creates/updates `.github/copilot-instructions.md`.
- If `team-export` is run before `team-init`, keep exported files and still run `team-init` when you want project-specific instructions generated.
- Do not auto-run `team-init` from `team-export`. Ask the user after export whether they want to run `team-init` next.

## What gets exported

| Content | Source (plugin) | Destination (your repo) |
|---------|----------------|------------------------|
| 9 agent definitions | `agents/*.agent.md` | `.github/agents/` |
| 9 shared instructions | `agents/instructions/*.instructions.md` | `.github/agents/instructions/` |
| 1 prompt | `agents/prompts/*.prompt.md` | `.github/agents/prompts/` |

## What does NOT get exported

- **Bundled plugin skills** (`team-init`, `team-export`, `maskorama`) — continue to work from the plugin
- **External skill dependencies** (for example `playwright-cli`, `agent-customization`) — are not bundled here; install separately if your workflow depends on them
- **copilot-instructions.md** — already handled by `team-init`
- **agent-journals/** — runtime state, not agent definitions
- **examples/** — reference material, stays in the plugin

## Steps

### 1. Confirm intent

Ask the user to confirm:

> **Team Export** will copy **{TOTAL_FILES}** agent-team files from the copilot-agent-team plugin into your repo's `.github/agents/` directory.
>
> Count breakdown (computed at runtime):
> - Agents: **{AGENT_FILE_COUNT}**
> - Instructions: **{INSTRUCTION_FILE_COUNT}**
> - Prompts: **{PROMPT_FILE_COUNT}**
>
> After export, you own these files — edit them freely. Local agents override plugin agents.
>
> Bundled plugin skills (`team-init`, `team-export`, `maskorama`) will continue to work from the plugin.
> External skills (for example `playwright-cli`, `agent-customization`) are separate and may need to be installed.
>
> Proceed? (yes/no)

If the user declines, stop.

Before showing this confirmation, compute counts from the current export manifest. Do not hardcode file totals.

### 2. Detect conflicts

Build an exact export manifest first, then check each exact destination path before writing anything.

**Exact destination-path preflight (required):**

1. Build the destination list from the current export manifest (all files in **Files to copy**).
2. For each destination path, record one status: `missing`, `exists-unmodified`, `exists-modified`, `exists-untracked`, `exists-renamed`.
3. Treat every `exists-*` file as a conflict candidate; never rely only on broad glob checks.
4. Show the full preflight table to the user before any write operation.

Check whether any destination paths in the manifest already exist in the project.

Common destination families:

- `.github/agents/*.agent.md` files
- `.github/agents/instructions/*.instructions.md` files
- `.github/agents/prompts/*.prompt.md` files

**If conflicts are found**, use the same safety strategy as `team-init` (read, preserve, propose, confirm):

1. If source control is available (for example Git), inspect changed files and diffs before resolving collisions.
2. For each conflicting file, include source-control diff context (new, modified, deleted, renamed) in your assessment.
3. Read existing file content and plugin source content fully.
4. Propose a per-file update plan with a short diff-style summary that incorporates source-control context.
5. Never silently overwrite user content.
6. Ask for confirmation before writing each conflict resolution batch.

**When source control is unavailable:**

1. Default to **Keep local by default** for all existing files.
2. Allow replace only with explicit per-file confirmation (user must name the file path being replaced).
3. Create a timestamped backup copy before any replace write.
4. Show before/after preview for each replace action and ask for a second confirmation.

For each conflicting file, ask the user to choose:

- **A — Merge**: keep user-specific content and add/update plugin-provided sections
- **B — Keep local**: do not change this file
- **C — Use plugin version**: replace file with exported plugin content

> **Existing files detected:**
> - `.github/agents/developer.agent.md`
> - `.github/agents/instructions/git.instructions.md`
> - *(list all conflicts)*
>
> For conflicts, choose a default mode:
> 1. **Merge-first** (recommended) — propose safe merges and confirm before write
> 2. **Keep local by default** — only create missing files (required default when source control is unavailable)
> 3. **Use plugin by default** — replace conflicts with plugin versions
> 4. **Abort** — cancel the export

**If no conflicts**, proceed directly to **Create directory structure**.

### 3. Create directory structure

Ensure these directories exist:

```
.github/agents/
.github/agents/instructions/
.github/agents/prompts/
```

### 4. Copy, merge, and annotate files

For each file being exported:

1. Read the source file content from the plugin
2. If destination file already exists, apply the conflict mode selected in **Detect conflicts**. For merge mode, preserve user-specific content and append or adapt plugin sections as needed, matching existing file structure and source-control diff context.
3. First, read the `version` field from the plugin's `plugin.json` file. Then insert an ownership comment **immediately after the YAML frontmatter closing `---`** (or at the top if no frontmatter):

```
<!-- Exported from copilot-agent-team plugin (v{VERSION}). You own this file — edit freely. -->
```

Where `{VERSION}` is the version read from `plugin.json` (e.g., `0.0.1`).

4. Write the result to the destination path

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
> - **Merged/Updated**: Y files
> - **Skipped**: Z files (kept local)
>
> Your agent team is now locally managed. Key things to know:
> - ✏️ **Edit freely** — these files are yours now
> - 🔄 **Local overrides plugin** — your `.github/agents/` files take priority over plugin versions
> - 🔌 **Plugin still active** — bundled skills (`team-init`, `team-export`, `maskorama`) still come from the plugin
> - 🧰 **External dependencies** — install separately if needed (for example `playwright-cli`, `agent-customization`)
> - 🗑️ **Optional cleanup** — run `copilot plugin uninstall copilot-agent-team` if you no longer need the plugin (skills will stop working)
> - 🧭 **Next step** — run `team-init` if you want to create or refresh `.github/copilot-instructions.md` for this repo
>
> **Tip**: To see what changed in newer plugin versions, compare your files against the latest plugin release.
