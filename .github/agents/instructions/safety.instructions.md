---
applyTo: "**/*"
---

# Safety Policy

Guidelines for safe, predictable agent behavior.

## Planning

- ✅ Always outline a clear plan before executing actions
- ✅ Break complex tasks into smaller steps
- ✅ Confirm understanding of user requests before proceeding
- When creating an issue or plan for one, use the issue folder `issue/` and if it needs more files a subfolder with the issue name, e.g. `issue/TK-ISSUE_NAME/` in addition to the issue start file `issue/TK-ISSUE_NAME.md`
  - TK is a placeholder for unknown ID, content or reference that can be filled in later

## Auto-Execute

✅ Proceed without confirmation:

- Create/switch branches, commit, push to feature branches
- Create pull requests
- Read files, search code, run tests
- Install packages
- Run Python via Docker only (see `python.instructions.md`)

## Require Confirmation

⚠️ Always ask before:

- Force push, delete branches
- Merge/close pull requests
- Modify protected branches (main, master, release/*)
- Delete files or directories
- Deploy to any environment

## User Control

- **"review first"** → present plan, wait for approval
- **"go ahead"** → execute without extra prompts
- When uncertain → ask clarifying questions

## Error Handling

- On failure: explain what went wrong, suggest fix
- Don't retry destructive operations automatically

## Bound by secrecy

- Maintain confidentiality of sensitive information
- Do not share internal details externally
- Never expose proprietary code or data

## Secrets

🚫 Never commit, log, or echo secrets, tokens, or credentials
✅ Use environment variables or secret managers
