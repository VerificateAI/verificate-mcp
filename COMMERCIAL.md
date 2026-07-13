# Commercial Terms & Access Model

Verificate MCP is **not freeware**. This repository is published so partners (including Cursor) can **evaluate, integrate, and sell against** the service without access to proprietary source code.

## What is free to use from this repo

- Documentation in this repository (connection guides, tool schemas, evaluation playbooks)
- Example MCP client configuration and smoke-test scripts
- Partnership proposal materials

All of the above are provided under the [LICENSE](LICENSE) in this repo for **integration and evaluation purposes only**.

## What requires a commercial license

- **Live MCP API access** beyond evaluation tier
- **Production deployment** with SLA, support, and audit retention
- **White-label or embedded** validation in your product
- **Source code access** to the protection engine (`ai/protections` and related modules)

## Access tiers

| Tier | Purpose | How to obtain |
|------|---------|---------------|
| **Free trial** | 30 days, all tools, no card required to start | [Sign up at verificate.ai/mcp](https://verificate.ai/mcp) |
| **Partner pilot** | Extended eval, co-design sessions, integration support | [Partnership inquiry](.github/ISSUE_TEMPLATE/partnership-inquiry.yml) |
| **Enterprise** | Production SLA, dedicated capacity, compliance artifacts | Contact via partnership issue or sales |

## Evaluation key terms (summary)

- Keys are tied to your organization and must not be shared publicly
- Keys must not be committed to public repositories
- Evaluation is for **testing and integration design**, not production load testing without agreement
- Verificate may revoke keys that abuse the service (scraping, reselling, bypass attempts)

After 30 days, continue on a monthly subscription ($30 USD/mo; launch pricing may apply). Full terms at [verificate.ai/mcp](https://verificate.ai/mcp).

## Intellectual property

The following remain **exclusive property of Verificate** and are not licensed by this repository:

- Deterministic protection gate implementations
- Integrity, gaming, and bypass detection logic
- Enterprise validation orchestration
- Audit intelligence and aggregated quality models
- Verificate, CORTEX, and related trademarks

Partners receive a **service API license** (right to call the MCP endpoint under their tier), not a **source license**.

## Partner integration rights

Qualified partners (e.g. IDE vendors, enterprise platforms) may:

- Document Verificate in official integration guides
- List Verificate in MCP server directories
- Build UX that calls Verificate MCP tools on behalf of users
- Co-market with prior written agreement

Partners may **not**:

- Reverse-engineer gate logic to replicate the service
- Remove or bypass validation gates in generated output flows
- Represent the service as open source or freeware

## Questions

Open a [Partnership inquiry](.github/ISSUE_TEMPLATE/partnership-inquiry.yml) or [Access request](.github/ISSUE_TEMPLATE/access-request.yml).
