# Copilot Instructions

<!-- 
  This is the main instruction file for GitHub Copilot and the agent team.
  Fill in each section with your project-specific details.
  Agents reference this file for project context, conventions, and architecture.
-->

## Product Context

<!-- What is this product? Who is it for? What problem does it solve? -->

**Product name**: [Your product name]

**Description**: [Brief description of what this product does and who it's for]

**Key goals**:
- [Goal 1]
- [Goal 2]

---

## Architecture

<!-- High-level architecture overview: projects, services, data flow -->

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

<!-- Common commands for building, running, testing -->

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

<!-- Coding standards, naming conventions, patterns used -->

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

<!-- If this is a web application, list the routes -->

| Route | Page | Description |
|-------|------|-------------|
| `/` | Home | [Description] |

---

## MCP Servers

<!-- If you use MCP servers, list them here so agents know what tools are available -->

<!-- Example:
### Project MCP
- **Purpose**: Resource management, diagnostics, integration discovery
- **Tools**: project-specific-mcp/*, resource inspection, health checks

### Playwright MCP  
- **Purpose**: Browser automation for testing and verification
- **Tools**: playwright-cli:*
-->

---

## Agent Team

This project uses a multi-agent team. See `.github/agents/` for individual agent definitions.

**Core team**: coordinator, clerk, platform-engineer, developer, tester, designer, agent-creator, product, reviewer

**Coordination model**: Hub-and-spoke with the coordinator at the center. The coordinator delegates work, verifies output, and synthesizes results. Agents collaborate directly when appropriate (e.g., designer ↔ developer for UI work).

<!-- Add any project-specific agent notes here, e.g.:
- "The developer should use [specific MCP tools] for this project"
- "We have a custom [domain] agent at .github/agents/[name].agent.md"
-->
