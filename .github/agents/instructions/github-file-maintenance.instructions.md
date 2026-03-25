---
applyTo: ".github/**"
---

# .github File Maintenance

- Write for machine consumption: precise, terse, unambiguous. No prose for humans.
- Files are auto-discovered via frontmatter (`applyTo`, `description`, `tools`, `handoffs`). Do not duplicate content across files.
- Minimize tokens. No filler, no generic knowledge, no restating what tables already express.
- Actionable only. Every line must tell the agent to *do* or *avoid* something.
- Persist learnings to `.github/agent-journals/{agent-name}.journal.md`, not VS Code Copilot memory (`/memories/`). VS Code memory is local; invisible to other agents. See `journal.instructions.md` for format.

## Exceptions

- **Skill reference docs** (e.g., `playwright-cli/references/`) may include examples and verbose documentation — these are tool manuals, not agent instructions.
- **Cultural/opt-in skills** (e.g., `maskorama`) may use prose — persona content IS the payload.
