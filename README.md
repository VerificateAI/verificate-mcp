# Verificate MCP — Enterprise AI Code Validation

> **Looking to install it?** The maintained entry point is **[verificate-mcp-quickstart](https://github.com/VerificateAI/verificate-mcp-quickstart)**: one-line setup for Claude Code, Cursor, VS Code and any MCP client, 100 free validations with no signup. This repository is the partner and integration guide.

[![Verificate Gate](https://img.shields.io/badge/gated%20by-Verificate%20Gate-2ea44f?logo=shield&logoColor=white)](https://github.com/VerificateAI/verificate-gate-action)


**Real-time validation for AI-generated code and plans.**  
Deterministic veto checks + a Claude Haiku 5.5 review, exposed as a native [Model Context Protocol (MCP)](https://modelcontextprotocol.io) HTTP server.

> **This repository is a technical sales and integration guide.**  
> It documents how to connect, evaluate, and partner with Verificate.  
> **The protection engine, gate algorithms, and orchestration logic are proprietary and not included here.**

---

## Why this exists

AI coding agents are fast — but they routinely ship placeholders, false completion, and code that compiles yet fails in production. Verificate is an **independent validation authority** that sits between the agent and your codebase:

| Problem | Verificate response |
|---------|---------------------|
| `TODO`, mocks, `NotImplementedError` marked "done" | Deterministic **Code Reality Gate** — hard veto, not a suggestion |
| Agent self-validates its own output | **Independent AI assessor** (separate from the authoring model) |
| Plans missing scale, security, operability | **`validate_plan`** before any code is written |
| Enterprise needs audit evidence | Durable validation audit trail on every call |

Cursor (and any MCP-capable IDE) can call Verificate **today** via HTTP MCP — no fork, no plugin, no source access required.

---

## Quick start (Cursor)

### 1. Start your free 30-day trial

Verificate is a **commercial service** with a free trial — no card required to start:

1. **Create an account** at **[verificate.ai/mcp](https://verificate.ai/mcp)**
2. Copy your **30-day trial token** from the dashboard
3. Paste it into the MCP config below (replace `YOUR_TRIAL_TOKEN`)

For Cursor partnership or enterprise pilots, open a [Partnership inquiry](.github/ISSUE_TEMPLATE/partnership-inquiry.yml).

### 2. Add to Cursor MCP config

Copy [`examples/mcp.json.example`](examples/mcp.json.example) into your Cursor MCP settings (`~/.cursor/mcp.json` or project `.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "verificate": {
      "url": "https://mcp.verificate.ai/mcp",
      "transport": "http",
      "headers": {
        "Authorization": "Bearer YOUR_TRIAL_TOKEN"
      }
    }
  }
}
```

Replace `YOUR_TRIAL_TOKEN` with the token from your [verificate.ai/mcp](https://verificate.ai/mcp) dashboard. **Never commit tokens to git.**

### 3. Verify connection

In Cursor, open MCP tools and confirm these tools are listed:

- `validate_ai_output` — gate code or agent output
- `validate_plan` — gate plans/designs before coding
- `analyze_code` — enterprise quality analysis
- `generate_code` — generate through the protection engine

Or run the smoke script:

```bash
export VERIFICATE_MCP_KEY="your-trial-token-here"
./examples/smoke-test.sh
```

See [docs/CONNECTION.md](docs/CONNECTION.md) for full setup, troubleshooting, and agent integration patterns.

---

## What you get (without source access)

Partners evaluate Verificate through the **MCP contract** — the same surface Cursor agents use in production:

| Capability | How to evaluate |
|------------|-----------------|
| Placeholder/stub rejection | Submit stub code via `validate_ai_output`; observe `vetoed: true` and `vetoed_by` |
| Real code approval | Submit complete implementations; observe `valid: true` with enterprise assessment |
| Plan validation | Call `validate_plan` on an architecture proposal |
| Response structure | Documented in [docs/TOOLS.md](docs/TOOLS.md) with example payloads |
| Live service | Hosted endpoint — no local install required |

The deterministic gates are **authoritative**: a gate veto fails the submission regardless of LLM score. That guarantee is observable in every API response under `protection.vetoed` and `protection.vetoed_by`.

---

## Documentation

| Doc | Purpose |
|-----|---------|
| [docs/CONNECTION.md](docs/CONNECTION.md) | Cursor, Claude Desktop, and generic MCP client setup |
| [docs/TOOLS.md](docs/TOOLS.md) | Tool schemas, request/response shapes, example payloads |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | High-level system design (no proprietary gate logic) |
| [docs/PARTNERSHIP.md](docs/PARTNERSHIP.md) | Why Cursor should integrate — partnership proposal |
| [docs/EVALUATION.md](docs/EVALUATION.md) | Evaluation playbook for partners (test cases, success criteria) |
| [COMMERCIAL.md](COMMERCIAL.md) | Licensing, access tiers, and what is / isn't open source |

---

## For Cursor

We are proposing Verificate as a **recommended MCP validation layer** for Cursor Agent and Composer:

1. **Today** — list in MCP directory; users connect with an eval key  
2. **Near-term** — pre-apply validation hook before agent diffs land  
3. **Enterprise** — plan validation in Plan mode + audit analytics  

Full proposal: [docs/PARTNERSHIP.md](docs/PARTNERSHIP.md)

To schedule a technical evaluation: [open a partnership issue](.github/ISSUE_TEMPLATE/partnership-inquiry.yml).

---

## Service endpoint

| | |
|---|---|
| **MCP URL** | `https://mcp.verificate.ai/mcp` |
| **Protocol** | MCP over HTTP (JSON-RPC 2.0, spec 2024-11-05) |
| **Auth** | None needed to start (100 free validations per machine); optional Bearer token from [verificate.ai/auth/signup](https://verificate.ai/auth/signup) for your own quota |
| **Status** | Production (hosted) |

Requests without a token use the free tier (100 validations per machine). After that, sign up for a 30-day trial (no card) to get a token.

---

## Repository scope

| Included in this repo | Not included (proprietary) |
|-----------------------|----------------------------|
| MCP tool documentation | `ai/protections` gate source code |
| Connection examples | Gate algorithms and pattern libraries |
| Sample requests/responses | Orchestration and anti-bypass internals |
| Partnership & evaluation guides | Deployment secrets and infrastructure configs |
| Smoke-test scripts (API client only) | Training data, audit payloads, customer data |

---

## Contact

- **Free 30-day trial:** [verificate.ai/mcp](https://verificate.ai/mcp) — sign up, no card required
- **Partnership / Cursor integration:** [GitHub Issues → Partnership inquiry](.github/ISSUE_TEMPLATE/partnership-inquiry.yml)
- **Security:** see [SECURITY.md](SECURITY.md)

---

*Verificate — independent validation for AI-generated software.*
