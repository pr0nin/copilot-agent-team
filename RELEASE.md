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
7. Create and push a tag matching the plugin version (format: `vX.Y.Z`).
   - The tag **must** match the version in `.plugin/plugin.json` (e.g., if the version is `0.1.0`, the tag should be `v0.1.0`).
   - You can do this manually:

     ```bash
     VERSION=$(jq -r '.version' .plugin/plugin.json)
     git tag "v$VERSION"
     git push origin "v$VERSION"
     ```
   - Or use the GitHub Actions workflow: **Tag Plugin Version** (`.github/workflows/tag-plugin-version.yml`)
     - **Prerequisites**: The workflow uses a Personal Access Token (PAT) stored in the `TAG_PUSH_PAT` repository secret to push tags. Set it up once:
       1. **Create a fine-grained Personal Access Token**:
          - Go to [GitHub Settings → Personal access tokens → Fine-grained tokens](https://github.com/settings/tokens?type=beta)
          - Click **Generate new token**
          - Set **Repository access**: Select `copilot-agent-team` only
          - Set **Permissions**: Under "Repository permissions", select `Contents` and set to **Read and Write**
          - Click **Generate token** and copy the token
       2. **Store the token as a repository secret**:
          - In this repo, go to **Settings → Secrets and variables → Actions**
          - Click **New repository secret**
          - Set **Name**: `TAG_PUSH_PAT`
          - Paste your token in **Secret** and click **Add secret**
       3. For more details, see [GitHub's Personal Access Token documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
     - Trigger it from the Actions tab after merging the version bump PR.
     - The workflow will create and push the tag if it does not already exist.
     - If the tag already exists, the workflow will no-op (best practice: do not fail the workflow, just log and exit).
   - Double-check that the tag appears on GitHub and matches the intended version.
8. The release workflow (`.github/workflows/release-on-tag.yml`) validates tag/version parity and publishes release notes.
9. Update docs if behavior changed (`README.md`, examples, skills docs).

## Notes

- If CI fails with mirror drift, run `bash scripts/sync-plugin-mirrors.sh` and commit the mirror updates.
- If a contributor changed `.github/agents` or `.github/skills` directly, port those edits back into `plugins/agent-team/` first, then re-sync.
- If the release workflow fails, confirm the pushed tag matches `.plugin/plugin.json` exactly.
