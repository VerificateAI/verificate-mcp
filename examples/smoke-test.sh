#!/usr/bin/env bash
# Verificate MCP smoke test — API client only (no proprietary code).
# Usage: VERIFICATE_MCP_KEY=xxx ./examples/smoke-test.sh

set -euo pipefail

BASE_URL="${VERIFICATE_MCP_URL:-https://verificate-portal-verificate-granite-4-small.apps.gpu4.fusion.isys.hpc.dc.uq.edu.au/mcp}"
KEY="${VERIFICATE_MCP_KEY:-}"

if [[ -z "$KEY" ]]; then
  echo "ERROR: Set VERIFICATE_MCP_KEY (free 30-day trial: sign up at https://verificate.ai/mcp)"
  exit 1
fi

mcp_call() {
  local payload="$1"
  curl -sS -m 120 -X POST "$BASE_URL" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $KEY" \
    -d "$payload"
}

echo "==> initialize"
INIT=$(mcp_call '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"smoke-test","version":"1.0"}},"id":1}')
echo "$INIT" | head -c 400
echo ""

if echo "$INIT" | grep -q '"error"'; then
  echo "FAIL: initialize returned error"
  exit 1
fi

echo "==> tools/list"
TOOLS=$(mcp_call '{"jsonrpc":"2.0","method":"tools/list","id":2}')
echo "$TOOLS" | grep -o '"name":"[^"]*"' | head -10
echo ""

echo "==> validate_ai_output (good code — expect valid)"
GOOD='{"jsonrpc":"2.0","method":"tools/call","id":3,"params":{"name":"validate_ai_output","arguments":{"ai_output":"def add(a: int, b: int) -> int:\n    return a + b\n","context":{"language":"python"}}}}'
GOOD_OUT=$(mcp_call "$GOOD")
echo "$GOOD_OUT" | python3 -c "
import json,sys
raw=json.load(sys.stdin)
text=raw['result']['content'][0]['text']
data=json.loads(text)
print('valid:', data.get('valid'), '| vetoed:', data.get('protection',{}).get('vetoed'), '| score:', data.get('score'))
" 2>/dev/null || { echo "$GOOD_OUT" | head -c 500; echo; }

echo "==> validate_ai_output (stub — expect veto)"
BAD='{"jsonrpc":"2.0","method":"tools/call","id":4,"params":{"name":"validate_ai_output","arguments":{"ai_output":"def process(data):\n    # TODO: implement\n    raise NotImplementedError()\n","context":{"language":"python"}}}}'
BAD_OUT=$(mcp_call "$BAD")
echo "$BAD_OUT" | python3 -c "
import json,sys
raw=json.load(sys.stdin)
text=raw['result']['content'][0]['text']
data=json.loads(text)
p=data.get('protection',{})
print('valid:', data.get('valid'), '| vetoed:', p.get('vetoed'), '| vetoed_by:', p.get('vetoed_by'))
" 2>/dev/null || { echo "$BAD_OUT" | head -c 500; echo; }

echo ""
echo "Smoke test complete. Review output above."
echo "Full evaluation: docs/EVALUATION.md"
