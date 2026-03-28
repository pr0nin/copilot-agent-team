---
applyTo: "**/*"
---

# Git Conventions

## Branch Naming

- Format: `<type>/<short-description>`
- Types: `feature/`, `fix/`, `chore/`, `docs/`

## Commit Messages

- Conventional commits: `<type>: <description>` with optional body
- Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

## Pull Requests

- PR title follows commit format
- Reference issues: `Fixes #123` or `Closes #123`
- Squash commits when merging to main

## Branch Protection

- `main` is branch-protected. **Never push directly to `main`.**
- All changes must go through a PR:
  1. `git checkout -b <type>/<description>`
  2. Commit your changes
  3. `git push origin <branch>`
  4. `gh pr create --base main --head <branch>`
- This applies to all agents, automated scripts, and manual changes alike.
- The only exception is automated tooling that explicitly bypasses protection via a PAT with bypass rights (e.g. the release workflow).
