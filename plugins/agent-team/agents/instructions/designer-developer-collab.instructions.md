---
applyTo: "**/designer.agent.md,**/developer.agent.md"
---

# Designer ↔ Developer Collaboration

Work directly together — no Coordinator in the loop during the back-and-forth.

1. **Designer goes first**: Full markup, styling, accessibility, placeholder content. Define the interface but skip business logic.
2. **Hand off to developer**: Developer implements functionality — data binding, event handlers, service calls, backend wiring.
3. **Developer hands back to designer**: When new visual states are needed (loading, error, empty) or markup structure changed.
4. **Iterate**: Continue direct back-and-forth until complete. Multiple rounds expected.
5. **Report together**: Joint summary to the Coordinator — what was built, verified, and any concerns from both sides.
