# Architecture Overview

High-level design for partners evaluating Verificate MCP. **Gate algorithms, pattern libraries, and orchestration source are proprietary and not published.**

## System context

```
┌─────────────────────────────────────────────────────────────┐
│  Cursor / IDE / Agent                                        │
│  (authoring model — e.g. Composer, Claude, GPT)              │
└──────────────────────────┬──────────────────────────────────┘
                           │ MCP HTTP (JSON-RPC)
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  Verificate MCP Server (hosted, OpenShift)                   │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Layer 1: Deterministic Protection Gates (AUTHORITATIVE)│    │
│  │  • Code reality / completeness                         │    │
│  │  • Integrity & deception detection                   │    │
│  │  • Gaming & false-completion detection               │    │
│  │  • Bypass / abuse detection                          │    │
│  │  → veto cannot be overridden by any LLM              │    │
│  └─────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Layer 2: Independent AI Assessor                    │    │
│  │  • Separate model from authoring agent               │    │
│  │  • Enterprise bar: perf, scale, reliability, debt    │    │
│  │  • ISO/IEC 25010 / MLOps framing                     │    │
│  │  → can reject or warn; cannot override gate veto     │    │
│  └─────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Audit collector (durable, persistent)               │    │
│  │  • Every validation recorded                         │    │
│  │  • Compliance & partner analytics                    │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## Design principles

### 1. Anti-bypass by construction

The MCP server is not a cosmetic wrapper. Deterministic gates run **in-process on every validation call**. If gates fail to load, the server returns an explicit error — never a silent pass.

Partners can verify this by submitting known stub patterns and observing `protection.vetoed: true` with structured `vetoed_by` — without needing source code.

### 2. Authoring model ≠ judging model

The agent that writes code should not be the sole authority on whether that code is production-ready. Verificate uses an **independent assessor** (commercial LLM API and/or on-cluster Verificate models) for enterprise quality judgment.

### 3. Syntax is upstream

Verificate intentionally does **not** duplicate IDE linters. Cursor handles syntax, format, and style. Verificate handles **completeness, deception, enterprise quality, and plan soundness**.

### 4. Honest capability disclosure

Some gates require sandboxes, external binaries, or live system checks. On the shared hosted service, these are listed in `protection.gates_deferred` — never silently omitted.

## MCP tools (integration surface)

| Tool | Role |
|------|------|
| `validate_ai_output` | Primary gate for agent output |
| `validate_plan` | Pre-implementation design validation |
| `analyze_code` | Deep enterprise analysis |
| `generate_code` | Generate + gate (no validated placeholders) |

Tool schemas: [TOOLS.md](TOOLS.md)

## Deployment (public facts only)

| Attribute | Value |
|-----------|-------|
| Hosting | OpenShift on UQ GPU4 HPC cluster |
| Transport | HTTPS MCP (HTTP JSON-RPC) |
| Auth | Bearer MCP key per organization |
| Availability | Production; multi-replica MCP with durable audit sidecar |

Infrastructure configs, secrets, and internal routing are **not** part of this repository.

## What partners can inspect

| Inspectable | Not provided |
|-------------|--------------|
| MCP tool schemas & responses | Gate source code |
| Veto behavior on test inputs | Pattern/regex libraries |
| Score and issue structure | Audit raw data |
| Latency and availability | Customer payloads |
| `gates_run` / `gates_deferred` transparency | Model prompts (assessor) |

## Suggested Cursor integration points

1. **MCP directory listing** — users add key + URL
2. **Agent pre-apply hook** — `validate_ai_output` before diff apply
3. **Plan mode** — `validate_plan` before codegen
4. **Enterprise dashboard** — aggregated audit (partner API, separate agreement)

Partnership details: [PARTNERSHIP.md](PARTNERSHIP.md)
