# Agent Team Overview

This project uses a multi-agent team coordinated by the **coordinator** agent. See `.github/agents/` for individual agent definitions.

## Team Roster

| Agent | File | Role |
|-------|------|------|
| Coordinator | `coordinator.agent.md` | Orchestrates work across agents, verifies output |
| Developer | `developer.agent.md` | Implements features, security review, fullstack |
| Designer | `designer.agent.md` | UI/UX, styling, accessibility |
| Tester | `tester.agent.md` | E2E testing, regression protection |
| Reviewer | `reviewer.agent.md` | Code review (pre-push, post-PR, post-deploy) |
| Product | `product.agent.md` | Discovery, user interviews, acceptance criteria |
| Platform Engineer | `platform-engineer.agent.md` | CI/CD, scripting, Docker, GitHub Actions |
| Clerk | `clerk.agent.md` | Documentation, file management |
| Agent Creator | `agent-creator.agent.md` | Creates new agents when gaps are found |

## How to work with the team

- **Start with the coordinator** for multi-step tasks — it will route work to the right specialist
- **Call agents directly** for focused tasks (e.g., `@developer` for implementation, `@tester` for writing tests)
- **Check journals** at `.github/agent-journals/` for agent decision history and working notes
