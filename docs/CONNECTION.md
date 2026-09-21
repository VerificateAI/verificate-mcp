# Connecting to Verificate MCP

This guide covers Cursor and other MCP clients. No local install is required — Verificate runs as a hosted HTTP MCP server.

## Prerequisites

1. A free **30-day trial token** — [sign up at verificate.ai/mcp](https://verificate.ai/mcp) (no card required); copy the token from your dashboard
2. Cursor with MCP support enabled, or any MCP client that supports HTTP transport

## Cursor setup

### Global config (`~/.cursor/mcp.json`)

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

### Project-level config (`.cursor/mcp.json` in repo root)

Same structure. Useful for team pilots — **store the key in environment variable substitution if your Cursor version supports it**, or use a local untracked override.

> **Security:** Add `mcp.json` to `.gitignore` if it contains real keys. Use [`examples/mcp.json.example`](examples/mcp.json.example) as the committed template.

### Verify in Cursor

1. Restart Cursor or reload MCP servers
2. Open **Settings → MCP** (or the MCP tools panel in Agent)
3. Confirm server `verificate` shows **connected**
4. Confirm tools: `validate_ai_output`, `validate_plan`, `analyze_code`, `generate_code`

## Smoke test (terminal)

```bash
export VERIFICATE_MCP_KEY="your-key-here"
./examples/smoke-test.sh
```

Expected: `initialize` succeeds, `tools/list` returns 4 tools, `validate_ai_output` returns JSON with `valid` and `protection` fields.

## Suggested agent workflow

Add to your Cursor rules or AGENTS.md (see [`examples/agent-rules-snippet.md`](examples/agent-rules-snippet.md)):

1. **Before applying agent-generated code** → call `validate_ai_output`
2. **If `valid: false` or `protection.vetoed: true`** → fix issues from `issues` and `suggestions`; do not mark task complete
3. **Before starting implementation** → call `validate_plan` on the plan
4. **For performance-critical code** → call `analyze_code` with `analysis_type: "performance"`

## Authentication errors

| Response | Meaning |
|----------|---------|
| `Missing MCP key. Get a 30-day key at verificate.ai/mcp.` | No `Authorization` header |
| `401` / `403` | Invalid or expired key |
| Connection timeout | Network/firewall; endpoint is on UQ HPC OpenShift |

## Endpoint reference

| Path | Method | Purpose |
|------|--------|---------|
| `/mcp` | POST | MCP JSON-RPC (tools, initialize) |
| `/` | GET | Portal landing (lists `/mcp`, `/auth`, etc.) |

The MCP server does not expose proprietary gate source or internal admin APIs on the public route.

## Claude Desktop / other clients

Use the same URL and Bearer header. If your client only supports stdio MCP, use an HTTP-to-stdio bridge (e.g. `mcp-remote`) pointing at the URL above — see your client's MCP HTTP documentation.

## Partner technical evaluation

For Cursor or IDE vendor evaluation with extended keys and office hours:

→ [Partnership inquiry](../.github/ISSUE_TEMPLATE/partnership-inquiry.yml)

See also [EVALUATION.md](EVALUATION.md) for structured test cases.
