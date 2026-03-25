# Copilot Instructions — Example

> This is an example of a filled-in `copilot-instructions.md` for a fictional app.
> Copy `.github/copilot-instructions.md` and replace the placeholders with your own values.

## Product Context

**Product name**: TaskTracker

**Description**: A team task management app for small dev teams. Users create boards, add tasks with priorities and deadlines, assign them to team members, and track progress through customizable columns.

**Key goals**:
- Fast, keyboard-driven task management
- Real-time collaboration (multiple users editing the same board)

---

## Architecture

**Solution structure**:
```
src/
  client/          # React SPA
  server/          # Express API
  shared/          # Shared types and validation
prisma/
  schema.prisma    # Database schema
```

**Key components**:
| Component | Purpose |
|-----------|---------|
| `src/client` | React 18 SPA with React Router, React Query |
| `src/server` | Express REST API with Prisma ORM |
| `src/shared` | Zod schemas shared between client and server |
| `prisma/` | PostgreSQL schema and migrations |

---

## Commands

### Build
```bash
npm run build
```

### Run
```bash
npm run dev
```

### Test
```bash
npx playwright test           # E2E tests
npm run test:unit              # Vitest unit tests
```

---

## Conventions

- **Language & framework**: TypeScript + React 18 + Express
- **Styling**: Tailwind CSS
- **Testing**: Playwright E2E, Vitest unit tests
- **State management**: React Query for server state, Zustand for client state
- **API style**: REST with Zod validation on both ends

### Naming
- Files: kebab-case (`task-board.tsx`, `create-task.ts`)
- Components: PascalCase (`TaskBoard`, `CreateTaskDialog`)
- Tests: `feature-name.spec.ts` for E2E, `module-name.test.ts` for unit

### Patterns
- Feature folders: `src/client/features/boards/`, `src/client/features/tasks/`
- Server routes mirror client features: `src/server/routes/boards.ts`
- All API responses wrapped in `{ data, error }` envelope

---

## Page Routes

| Route | Page | Description |
|-------|------|-------------|
| `/` | Dashboard | List of boards |
| `/boards/:id` | Board | Kanban board with columns and tasks |
| `/settings` | Settings | User preferences and team management |

---

## MCP Servers

---

## Agent Team

This project uses a multi-agent team. See `.github/agents/` for individual agent definitions.

**Core team**: coordinator, clerk, platform-engineer, developer, tester, designer, agent-creator, product, reviewer

**Coordination model**: Hub-and-spoke with the coordinator at the center. The coordinator delegates work, verifies output, and synthesizes results. Agents collaborate directly when appropriate (e.g., designer ↔ developer for UI work).
