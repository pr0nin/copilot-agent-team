# Release Process

This repository uses `plugins/agent-team/` as the source of truth.

## Goals

- Prevent drift between distributable plugin files and dogfooding mirrors.
- Keep release steps simple and repeatable.

## Checklist

1. Make all agent/skill changes in `plugins/agent-team/` only.
2. Sync mirrors:

```bash
bash scripts/sync-plugin-mirrors.sh
```

3. Verify no drift remains:

```bash
git diff -- .github/agents .github/skills
```

4. Run local plugin smoke checks:

```bash
copilot plugin install ./plugins/agent-team
# Run a quick scenario: team-init, then a coordinator request
```

5. Run the version bump workflow:

- GitHub Actions: **Version Bump (GitVersion)** (`.github/workflows/version-bump-gitversion.yml`)
- This computes version from Git history and opens a PR that updates:
	- `.plugin/plugin.json`
	- `.plugin/marketplace.json`

6. Review and merge the bump PR.
7. Open a tag matching the plugin version (format: `vX.Y.Z`).
8. The release workflow (`.github/workflows/release-on-tag.yml`) validates tag/version parity and publishes release notes.
9. Update docs if behavior changed (`README.md`, examples, skills docs).

## Notes

- If CI fails with mirror drift, run `bash scripts/sync-plugin-mirrors.sh` and commit the mirror updates.
- If a contributor changed `.github/agents` or `.github/skills` directly, port those edits back into `plugins/agent-team/` first, then re-sync.
- If the release workflow fails, confirm the pushed tag matches `.plugin/plugin.json` exactly.
