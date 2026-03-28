# Architecture

## Coordination Model

```
                     Coordinator
                          │
        ┌────────┬────────┼────────┬────────┐
        │        │        │        │        │
    Developer  Designer  Tester  Product   Platform Eng
        │        │                          │
        └───↔────┘                    (relay/escalation)
     (direct collab)
                    
    Support roles:
    ├── Clerk (documents/files)
    ├── Reviewer (code review, 3 modes)
    └── Agent Creator (builds new agents)
```

## Key Patterns

- **Hub-and-spoke**: Coordinator delegates all work, never edits files directly
- **Direct collaboration**: Designer ↔ Developer work together without coordinator in the loop during UI iterations
- **Platform engineer relay**: All agents escalate CLI/CI/CD/infrastructure questions to the platform-engineer
- **Journals**: Each agent maintains a private journal at `.github/agent-journals/<name>.journal.md`

## Why No CI/CD?

Agent files are markdown — there's nothing to lint, build, or test in CI.
