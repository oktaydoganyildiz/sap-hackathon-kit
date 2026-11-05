# Contract — agent ↔ tools

Owner: <captain>. Agent developers mock against this; tool owners implement exactly this. Changes only via issue to the captain.

## Tool: `<tool_name>`
- Kind: read-only | write (needs HITL approval)
- Owner: @<user> · Folder: `<mcp-server/>`
- Description (what the LLM sees, English, action-oriented): "<Use this when …>"
- Input:
  ```json
  { "<param>": "<type> — <meaning>" }
  ```
- Output:
  ```json
  { "<field>": "<type> — <meaning>" }
  ```
- Example call → response:
  ```json
  { "<param>": "…" }
  ```
  ```json
  { "<field>": "…" }
  ```
- Errors: `<code>` — <when>

<!-- copy the block per tool; keep 3–6 tools -->

## Agent card / entry point
- Name: <agent name> · Skills: <list> · Expected latency: < 60 s per answer
