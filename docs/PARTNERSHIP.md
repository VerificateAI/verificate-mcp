# Partnership Proposal — Cursor × Verificate MCP

**For Cursor partnerships / platform team**

## Summary

Verificate provides a **hosted MCP validation layer** that stops AI coding agents from shipping incomplete, deceptive, or enterprise-unready output. It is live today, connectable from Cursor via HTTP MCP, and designed so partners can integrate **without access to proprietary gate source**.

## Why Cursor should look at this now

1. **Agent speed outpaced agent trust** — Cursor users generate more code than ever; the failure mode is false completion, not slow generation.

2. **Self-validation does not scale** — the authoring model cannot reliably certify its own output for production. Enterprises ask Cursor for an independent check.

3. **MCP is the integration path** — Verificate is already MCP-native. Cursor users can connect with one config block and four tools.

4. **Deterministic enforcement, not another opinion** — gate vetoes are observable in API responses and cannot be overridden by the assessor LLM. That is qualitatively different from "ask the model if the model was right."

5. **Commercial model aligns with Cursor Enterprise** — evaluation keys for pilots; production licensing for teams that require SLA, audit retention, and support.

## What Cursor gets

| Benefit | Detail |
|---------|--------|
| Differentiated enterprise story | "Code validated by independent authority before it lands" |
| Reduced support burden | Fewer "agent said done but code is stubs" tickets |
| Native MCP — no fork | Document + directory listing + optional hooks |
| Observable quality metrics | Audit trail for gate rejection rates (enterprise tier) |
| Plan-mode quality | Validate architecture before token spend on bad plans |

## Proposed phases

### Phase 1 — Partner listing (weeks)

- Add Verificate to Cursor MCP partner/server documentation
- Link to this repo for connection + evaluation playbook
- Evaluation keys via verificate.ai/mcp or direct partner provisioning

### Phase 2 — Agent workflow (1–2 sprints)

- Document recommended agent rules (validate before apply)
- Optional: Cursor rule template in this repo's `examples/`
- Explore official "validate with Verificate" user setting

### Phase 3 — Deep integration (quarter)

- Pre-apply validation hook in Agent/Composer
- Inline display of `protection.vetoed` and fix suggestions
- Plan-mode `validate_plan` integration

### Phase 4 — Enterprise (ongoing)

- Team audit dashboard
- Custom gate policies (partner agreement)
- Dedicated capacity / on-prem options for regulated customers

## Evaluation offer for Cursor

We will provide:

- Extended evaluation MCP key(s) for Cursor engineering
- Structured test suite ([EVALUATION.md](EVALUATION.md))
- Technical office hours for hook design
- Sample response payloads and SLA expectations (hosted tier)

We do **not** require Cursor to publish or open-source any Verificate IP.

## Competitive positioning

| Approach | Limitation | Verificate |
|----------|------------|------------|
| Lint / CI only | Catches syntax, not "agent claimed done" | Catches placeholders & false completion in the agent loop |
| Same-model review | Self-referential | Independent assessor + deterministic gates |
| Human review | Does not scale with agent volume | Automated gate on every output |
| Custom prompts | Instructions ≠ enforcement | Veto is enforced in API response |

## Call to action

1. **Connect** — use [CONNECTION.md](CONNECTION.md) with a partner eval key  
2. **Run** — [EVALUATION.md](EVALUATION.md) test cases (15 minutes)  
3. **Meet** — [open a partnership issue](../.github/ISSUE_TEMPLATE/partnership-inquiry.yml)  

---

*Verificate — the validation layer between AI agents and production code.*
