# Security Policy

## Supported versions

| Service | Supported |
|---------|-----------|
| Verificate MCP (hosted) | Current production endpoint only |
| This documentation repo | Latest `main` branch |

## Reporting a vulnerability

**Do not** open public GitHub issues for security vulnerabilities.

Email: **security@verificate.ai** (or open a private [Security advisory](https://github.com/verificate/verificate-mcp/security/advisories/new) on the partner repo once published).

Include:

- Description of the issue
- Steps to reproduce (MCP request/response if applicable)
- Impact assessment
- Your contact information

We aim to acknowledge within **2 business days**.

## Scope

**In scope:**

- Authentication bypass on the MCP endpoint
- Cross-tenant data leakage via the MCP API
- Validation bypass that causes vetoes to be silently ignored
- Issues in published smoke-test scripts in this repo

**Out of scope:**

- Social engineering
- Denial of service without demonstrated impact on other tenants
- Issues in proprietary gate source (not published — report still welcome via private channel)
- Missing rate limits on evaluation keys (known; use partner tier for production)

## Safe harbor

We support good-faith security research on the **published MCP API** within evaluation key terms. Do not access other customers' data or attempt to extract proprietary source from hosted infrastructure.

## Keys and secrets

- Never commit MCP keys to this repository
- Rotate keys if exposed
- Evaluation keys are available at [verificate.ai/mcp](https://verificate.ai/mcp)
