# Publish this repo to GitHub (standalone technical sales repo)

The `verificate-mcp-partner/` folder is designed to be pushed as its **own public GitHub repository** — no proprietary code included.

## What goes on GitHub

- README, partnership docs, MCP tool reference
- Connection examples (`mcp.json.example`, smoke test script)
- Issue templates for partnership / access requests
- Commercial terms (COMMERCIAL.md, LICENSE)

## What stays private (main Verificate_v1 repo)

- `MCP Server/ai/protections/` — all gate implementations
- `MCP Server/mcp_protections.py`, `mcp_server_minimal.py`
- OpenShift deployment manifests with secrets
- Audit data, API keys, customer configs

## Create the GitHub repo

```bash
cd verificate-mcp-partner

git init
git add .
git commit -m "Initial public partner repo for Verificate MCP"

# Create repo on GitHub (org: verificate or your org)
gh repo create verificate/verificate-mcp --public --source=. --remote=origin \
  --description "Verificate MCP — enterprise AI code validation for Cursor and MCP clients (partner docs, not source)"

git push -u origin main
```

## Suggested repo settings

| Setting | Recommendation |
|---------|----------------|
| Visibility | Public |
| Description | `Enterprise AI code validation via MCP — connect from Cursor without source access` |
| Topics | `mcp`, `cursor`, `ai-validation`, `enterprise`, `model-context-protocol` |
| Website | `https://verificate.ai/mcp` |
| Issues | Enabled (partnership + access templates) |
| Wiki | Off |
| Discussions | Optional for partner Q&A |

## Pin for Cursor reviewers

1. **README.md** — start here
2. **docs/PARTNERSHIP.md** — why Cursor
3. **docs/EVALUATION.md** — 15-minute proof
4. **examples/smoke-test.sh** — live API demo

## Cursor connection (for reviewers)

Reviewers get a key from verificate.ai/mcp or a partner-provisioned key — **never embed keys in the repo**.

## Optional: GitHub Pages

This repo is markdown-only; GitHub renders README and docs natively. No Pages build required unless you want a custom site later.
