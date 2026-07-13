# Verificate validation (add to Cursor rules or AGENTS.md)

When generating or editing code with the agent:

1. After producing code changes, call MCP tool **validate_ai_output** with the full proposed code.
2. If the response has `protection.vetoed: true` OR `valid: false`:
   - Do NOT mark the task complete.
   - Do NOT tell the user the work is done.
   - Fix every item in `issues` and `suggestions`, then re-validate.
3. Before starting a multi-file implementation, call **validate_plan** on the plan.
4. For performance-sensitive code, call **analyze_code** with `analysis_type: "performance"`.

Treat `[code_reality_gate]` vetoes as hard blockers — placeholders, TODOs, mocks, and NotImplementedError are not acceptable deliverables.

Pass `context: {"language": "<lang>"}` for non-Python code.
