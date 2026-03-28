# Copilot Instructions

## Product Context

**Product name**: [product_name]

**Description**: [short_product_description]

**Key goals**:
- [goal_1]
- [goal_2]

---

## Architecture

**Solution structure**:
```
[path_or_folder_1]/
  [subfolder_or_file]  # [what_it_contains]
[path_or_folder_2]/
  [subfolder_or_file]  # [what_it_contains]
```

**Key components**:
| Component | Purpose |
|-----------|---------|
| `[component_path_or_name]` | [purpose] |
| `[component_path_or_name]` | [purpose] |

---

## Commands

### Build
```bash
[build_command]
```

### Run
```bash
[run_command]
```

### Test
```bash
[test_command]
```

---

## Conventions

- **Language and framework**: [language_and_framework]
- **Styling**: [styling_approach]
- **Testing**: [testing_stack]
- **State management**: [state_management_or_na]
- **API style**: [api_style]

### Naming
- Files: [file_naming_style]
- Components/classes/types: [type_naming_style]
- Tests: [test_naming_style]

### Patterns
- [pattern_1]
- [pattern_2]

---

## Page Routes

| Route | Page | Description |
|-------|------|-------------|
| `[route]` | [page_name] | [description] |
| `[route]` | [page_name] | [description] |

---

## MCP Servers

---

## Agent Team

This project uses a multi-agent team. See `.github/agents/` for individual agent definitions.

**Core team**: coordinator, clerk, platform-engineer, developer, tester, designer, agent-creator, product, reviewer

**Coordination model**: Hub-and-spoke with the coordinator at the center. The coordinator delegates work, verifies output, and synthesizes results. Agents collaborate directly when appropriate (for example, designer <-> developer for UI work).
