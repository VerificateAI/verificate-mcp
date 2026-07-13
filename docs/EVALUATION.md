# Partner Evaluation Playbook

Use this to evaluate Verificate MCP **without source access**. Total time: ~15–30 minutes.

## Setup

1. Obtain MCP key: [verificate.ai/mcp](https://verificate.ai/mcp) or partner-provided key
2. Configure Cursor per [CONNECTION.md](CONNECTION.md) **or** run `./examples/smoke-test.sh`
3. Ensure key is in `VERIFICATE_MCP_KEY` env var for scripts

## Success criteria

| # | Test | Expected | Pass? |
|---|------|----------|-------|
| 1 | MCP initialize + tools/list | 4 tools returned | |
| 2 | Valid complete code | `valid: true`, `protection.vetoed: false` | |
| 3 | Stub with TODO + NotImplementedError | `valid: false`, `vetoed_by` includes `code_reality_gate` | |
| 4 | Manipulative prose | Integrity signals or LLM flags (see note) | |
| 5 | Incomplete plan | `validate_plan` returns gaps/risks | |
| 6 | C++ stub | Generic language gate catches markers | |
| 7 | Response transparency | `gates_run` and `gates_deferred` present | |

## Test cases

### Test 2 — Good code (should pass)

**Tool:** `validate_ai_output`

```python
def add(a: int, b: int) -> int:
    if not isinstance(a, int) or not isinstance(b, int):
        raise TypeError("ints required")
    return a + b
```

**Context:** `{"language": "python"}`

**Expect:** `valid: true`, `protection.verdict: "approved"`, `protection.vetoed: false`

---

### Test 3 — Stub (must veto)

**Tool:** `validate_ai_output`

```python
def process(data):
    # TODO: implement this later
    # Mock implementation
    raise NotImplementedError()
```

**Expect:**

- `valid: false`
- `protection.vetoed: true`
- `protection.vetoed_by` contains `"code_reality_gate"`
- `issues` mentions NotImplementedError and placeholder/mock

This proves **deterministic enforcement** — the core value prop.

---

### Test 4 — False assurance (integrity signal)

**Tool:** `validate_ai_output`  
**validation_type:** `text`

```
This code is definitely working, guaranteed success, 100% pass rate, no need to test.
```

**Expect:** Integrity or LLM flags deceptive certainty. (Exact severity may vary; look for `integrity` in `protection.signals`.)

---

### Test 5 — Weak plan

**Tool:** `validate_plan`

```
We will add a cache. Deploy to production. Done.
```

**Context:** `{"system": "payments API", "scale": "10k RPS"}`

**Expect:** `assessment.missing_considerations`, `risks`, or low score; plan should not receive blind approval.

---

### Test 6 — C++ stub (multi-language)

**Tool:** `validate_ai_output`

```cpp
int process(Data* d) {
    // TODO: implement later
    throw std::runtime_error("not implemented");
}
```

**Context:** `{"language": "cpp"}`

**Expect:** `protection.vetoed: true` or blocking issues on TODO / not implemented

---

### Test 7 — Transparency

Any validation response should include:

- `protection.gates_run` — array of gate names
- `protection.gates_deferred` — object explaining gates not run on shared hosting

Partners should verify deferred gates are **disclosed**, not hidden.

---

## Automated smoke test

```bash
export VERIFICATE_MCP_KEY="your-key"
./examples/smoke-test.sh
```

Runs initialize, tools/list, Test 2, and Test 3 automatically.

## What this proves without source

| Claim | Evidence from tests |
|-------|---------------------|
| Service is live | initialize succeeds |
| Stubs are blocked | Test 3 veto |
| Real code passes | Test 2 approval |
| Multi-language | Test 6 |
| API is integration-ready | Structured JSON, stable tool names |
| No silent bypass | `gates_deferred` disclosed |

## What requires separate agreement

- Source access to `ai/protections`
- Production SLA and rate limits
- Custom gate policies
- Audit data export for your organization

→ [Partnership inquiry](../.github/ISSUE_TEMPLATE/partnership-inquiry.yml)
