# MCP Tool Reference

Public API contract for the Verificate MCP server. Tool names and schemas are stable integration surfaces; internal gate implementation is proprietary.

## Transport

- **URL:** `POST https://verificate-portal-verificate-granite-4-small.apps.gpu4.fusion.isys.hpc.dc.uq.edu.au/mcp`
- **Auth:** `Authorization: Bearer <MCP_KEY>`
- **Body:** JSON-RPC 2.0

### List tools

```json
{"jsonrpc":"2.0","method":"tools/list","id":1}
```

### Call a tool

```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "id": 2,
  "params": {
    "name": "validate_ai_output",
    "arguments": { }
  }
}
```

Tool results return MCP `content[].text` as a JSON string (parse it).

---

## `validate_ai_output`

Enterprise validation gate for code, plans, or any agent output.

### Input

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `ai_output` | string | yes | Code, plan, or text to validate |
| `validation_type` | string | no | `code_generation` (default), `plan`, `design`, `architecture`, `text` |
| `context` | object | no | e.g. `{"language": "python"}` |

### Output (parsed JSON)

| Field | Type | Description |
|-------|------|-------------|
| `valid` | boolean | Overall pass/fail for integration hooks |
| `score` | number | Combined score 0–100 |
| `confidence` | number | 0–1 confidence |
| `issues` | string[] | Human-readable findings |
| `suggestions` | string[] | Recommended fixes |
| `protection` | object | Deterministic gate results (see below) |
| `assessment` | object | Independent LLM enterprise assessment |
| `provider` | string | Assessor model used |

### `protection` object (key fields)

| Field | Description |
|-------|-------------|
| `verdict` | `approved`, `approved_with_warnings`, `rejected` |
| `vetoed` | **If true, submission failed — non-overridable** |
| `vetoed_by` | Gate names that vetoed (e.g. `code_reality_gate`) |
| `protection_score` | 0–100 from deterministic gates |
| `issues` | Structured gate findings with `source`, `severity`, `line` |
| `gates_run` | Which gates executed |
| `gates_deferred` | Gates not run on shared service (documented honestly) |

---

## `validate_plan`

Alias for plan validation. Same behavior as `validate_ai_output` with `validation_type: "plan"`.

### Input

| Field | Type | Required |
|-------|------|----------|
| `plan` | string | yes |
| `context` | object | no |

### Assessment extras (when `assessment.available`)

- `missing_considerations`
- `risks`
- `standards_compliance`

---

## `analyze_code`

Enterprise code analysis — performance, scalability, reliability, tech debt (not syntax/lint).

### Input

| Field | Type | Required |
|-------|------|----------|
| `code` | string | yes |
| `analysis_type` | string | no — `quality`, `performance`, `scalability`, `security`, `tech_debt` |
| `language` | string | no — `python`, `cpp`, `sql`, `swift`, etc. |

### Output highlights

- `quality_score`, `complexity`, `issues`, `recommendations`
- `protection` — same gate envelope as validation
- `assessment.performance_findings` when available

---

## `generate_code`

Generate code via LLM, then run through protection engine. **Placeholder output is never returned as validated.**

### Input

| Field | Type | Required |
|-------|------|----------|
| `prompt` | string | yes |
| `language` | string | no — default `python` |
| `max_tokens` | integer | no — default 4000 |

### Output highlights

- `generated`, `code`, `validated`, `validation_score`, `attempts`, `protection`

---

## Example: good code (approved)

**Request:** `validate_ai_output` with a complete Python function.

**Response (abbreviated):**

```json
{
  "valid": true,
  "score": 96.8,
  "protection": {
    "verdict": "approved",
    "vetoed": false,
    "vetoed_by": [],
    "protection_score": 100.0,
    "gates_run": ["code_reality_gate", "integrity_monitor", "gaming_prevention", "bypass_detector"]
  },
  "assessment": {
    "available": true,
    "verdict": "approve_with_conditions",
    "score": 92.0,
    "feedback": "Functionally correct; minor enterprise performance notes."
  }
}
```

## Example: stub code (rejected)

**Request:** code containing `TODO`, mock comment, and `NotImplementedError`.

**Response (abbreviated):**

```json
{
  "valid": false,
  "score": 4.0,
  "issues": [
    "[code_reality_gate] NotImplementedError found in production code",
    "[code_reality_gate] Placeholder detected: Placeholder implementation note",
    "[code_reality_gate] Mock implementation detected: Mock implementation comment"
  ],
  "protection": {
    "verdict": "rejected",
    "vetoed": true,
    "vetoed_by": ["code_reality_gate"],
    "protection_score": 0.0
  }
}
```

This veto is **authoritative** — the independent assessor also rejected, but the gate would fail even if the LLM scored higher.

---

## Integration hook (pseudocode)

```javascript
const result = JSON.parse(mcpToolResult.content[0].text);

if (result.protection?.vetoed || !result.valid) {
  // Block apply / block "task complete" / show issues to user
  return { allowApply: false, issues: result.issues, suggestions: result.suggestions };
}

return { allowApply: true, score: result.score };
```

Full evaluation scenarios: [EVALUATION.md](EVALUATION.md)
