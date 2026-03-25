# Copilot Instructions

> **Minimum viable config**: Fill in Product Context + Commands + one Convention to get started. Everything else is optional.

## Product Context

**Product name**: [Your product name]

**Description**: [Brief description of what this product does and who it's for]

**Key goals**:
- [Goal 1]
- [Goal 2]

---

## Architecture

**Solution structure**:
```
[Describe your project layout here]
```

**Key components**:
| Component | Purpose |
|-----------|---------|
| [Component 1] | [What it does] |
| [Component 2] | [What it does] |

---

## Commands

### Build
```bash
# [Your build command]
```

### Run
```bash
# [Your run/dev command]
```

### Test
```bash
# [Your test command]
```

---

## Conventions

- **Language & framework**: [e.g., TypeScript + React, C# + Blazor, Python + FastAPI]
- **Styling**: [e.g., Tailwind CSS, CSS Modules, styled-components]
- **Testing**: [e.g., Playwright E2E, Jest, xUnit]
- **State management**: [e.g., React Query, Redux, scoped services]
- **API style**: [e.g., REST, GraphQL, gRPC]

### Naming
- Files: [convention, e.g., kebab-case, PascalCase]
- Components: [convention]
- Tests: [convention, e.g., MethodName_Scenario_ExpectedResult]

### Patterns
- [Any architectural patterns: feature folders, CQRS, vertical slices, etc.]

---

## Page Routes

| Route | Page | Description |
|-------|------|-------------|
| `/` | Home | [Description] |

---

## MCP Servers

---

## Agent Team

This project uses a multi-agent team. See `.github/agents/` for individual agent definitions.

**Core team**: coordinator, clerk, platform-engineer, developer, tester, designer, agent-creator, product, reviewer

**Coordination model**: Hub-and-spoke with the coordinator at the center. The coordinator delegates work, verifies output, and synthesizes results. Agents collaborate directly when appropriate (e.g., designer ↔ developer for UI work).
