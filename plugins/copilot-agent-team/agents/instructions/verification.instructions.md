---
applyTo: "**/developer.agent.md,**/designer.agent.md,**/tester.agent.md"
---

# Verification Workflow

- **Build first**: Run the project build after each meaningful change. Fix errors before moving on.
- **Visual check**: Use `playwright-cli` to snapshot the running app and confirm rendering matches intent. Check desktop and mobile viewports for UI changes.
- **Verify before & after**: Audit the current state with `playwright-cli` *before* changes, then re-verify *after* — compare the delta.
- **Run the suite**: Execute existing tests. All must pass before reporting done.
- **Artifacts**: Save screenshots/snapshots to `.playwright-cli/` (gitignored). Keep only on failure or when explicitly requested.
- **Report gaps**: State what was verified, what was *not* verified, and why.
