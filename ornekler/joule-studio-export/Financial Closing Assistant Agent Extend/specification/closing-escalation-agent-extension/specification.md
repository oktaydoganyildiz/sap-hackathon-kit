# Specification: closing-escalation-agent-extension

> **Guidelines**: Read [guidelines.md](../guidelines.md) and [guidelines-agent-extension.md](../guidelines-agent-extension.md) before executing ANY tasks below. Follow all constraints described there throughout execution.

## Basic Setup

- [x] Read the project input (`product-requirements-document.md`, `intent.md`)
- [x] Confirm the base agent to extend:
  - **ordId**: `sap.agtcloass:agent:financial-closing-assistant:v1`
  - **version**: `1.0.0`
  - **Extension capability**: `urn:sap:extension-capability:v1:default`
  - Verify: `instructionSupported: true`, `tools.additions.enabled: true`, `supportedHooks: [agent_pre_hook, agent_post_hook]`

## Feature Flag Check

- [x] Check feature flag `enable_agent_extension_mcp_server`:
  - If `true`: MCP tool integration is enabled — keep `tools` section in `extension.yaml`
  - If `false` or unavailable: omit `tools` section entirely from `extension.yaml`
- [x] Check feature flag `enable_agent_extension_n8n_hooks`:
  - This extension does NOT use n8n hooks — no hook wiring is required regardless of flag value
  - Omit `hooks` section from `extension.yaml`

## API & MCP Discovery

- [x] Confirm no new MCP servers or API integrations are required for this extension:
  - The three escalation rules (Critical, Urgent, Flag) are applied entirely via custom instructions
  - The base Financial Closing Assistant already provides AFC task data and S/4HANA posting data access
  - No `api-specs/` or `mcp-specs/` directories are needed for this asset
- [x] Skip `mcp-translation-file` invocation — no new APIs are integrated by this extension

## Escalation Rule Instructions

- [x] Author the custom instruction content for the extension. The instructions MUST implement all three Stonebridge-specific escalation rules:

  **Rule 1 — Critical – Immediate Action Required**
  - Condition: Any posting error where the document amount exceeds EUR 100,000
  - Classification label: `Critical – Immediate Action Required`
  - Required output per item: document reference, amount in EUR, escalation reason, recommended next step

  **Rule 2 — Urgent – Deadline Imminent**
  - Condition: Any incomplete closing task with fewer than four hours remaining before the official period-end deadline
  - Classification label: `Urgent – Deadline Imminent`
  - Required output per item: task reference, time remaining (hours/minutes), escalation reason, recommended next step

  **Rule 3 — Flag – Schedule Risk**
  - Condition: Any overdue closing task that blocks one or more downstream closing dependencies
  - Classification label: `Flag – Schedule Risk`
  - Required output per item: task reference, blocked downstream dependency name(s), escalation reason, recommended next step

- [x] Include multi-rule reporting instruction: if a single item satisfies more than one rule, it MUST appear under each applicable section with its respective escalation reason — never collapsed into a single section
- [x] Include strict read-only instruction: the agent MUST NOT post documents, complete tasks, approve entries, or modify closing schedules under any circumstance; all output is explicitly advisory
- [x] Include output format instruction:
  - Produce a single consolidated escalation summary
  - Ordered: Critical → Urgent → Flag
  - Each section must always be present; if no items qualify, output `No items found` for that section
  - Each item must include: reference (document ID or task ID), escalation reason, recommended next step
- [x] Include milestone logging instructions:
  - On generating any Critical item: emit `M1.achieved: Stonebridge escalation rules active — Critical rule fired for document/task {ref}`
  - On generating any Urgent item: emit `M1.achieved: Stonebridge escalation rules active — Urgent rule fired for task {ref}`
  - On generating any Flag item: emit `M1.achieved: Stonebridge escalation rules active — Flag rule fired for task {ref}`
  - On delivering the full consolidated summary: emit `M2.achieved: Consolidated escalation summary delivered — Critical: {n}, Urgent: {n}, Flag: {n}`
  - On detecting a multi-rule item: emit `M3.achieved: Multi-rule item detected and reported under all applicable sections`
  - On completing a cycle with zero write operations: emit `M4.achieved: Read-only compliance confirmed — no write operations triggered during escalation cycle`
  - If summary cannot be completed (data retrieval failure): emit `M2.missed: Summary generation incomplete — one or more sections missing from escalation output`

## Preservation of Base Agent Capabilities

- [x] Confirm the custom instructions are scoped to escalation classification behaviour only
- [x] Verify instructions do not override, disable, or conflict with any existing Financial Closing Assistant capability (journal entry creation, accruals processing, receivables/payables clearing, analytical insights)
- [x] The Before Hook (`agent_pre_hook`) injects escalation context before the main orchestrator logic — it must not suppress or alter responses to non-closing queries

## Agent Extension Asset Creation

- [x] Invoke the `create-agent-extension` skill from `assets/closing-escalation-agent-extension/` to generate `extension.yaml` and `asset.yaml` with:
  - Base agent: `sap.agtcloass:agent:financial-closing-assistant:v1` version `1.0.0`
  - Capability: `urn:sap:extension-capability:v1:default`
  - `instruction`: the full Stonebridge escalation instruction text (Rules 1–3, multi-rule reporting, read-only guardrail, output format, milestone logging)
  - `tools`: include only if `enable_agent_extension_mcp_server = true`; if enabled, no new tools are added by this extension (leave tools section empty or omit)
  - `hooks`: omit entirely (no n8n hooks required)
- [x] Ensure `extension.yaml` contains:
  - `capabilityId: default`
  - `instruction` section with the full escalation instructions
  - No write-capable tools
  - No hooks (unless base agent hooks are used for a future enhancement)
- [x] Ensure `asset.yaml` contains:
  - `requires` referencing the base agent (`kind: agent`, ordId `sap.agtcloass:agent:financial-closing-assistant:v1`, version `1.0.0`)
  - Correct asset metadata (name, description referencing Stonebridge closing escalation)

## Solution Setup

- [x] Invoke the `setup-solution` skill to create / update `solution.yaml` registering `./assets/closing-escalation-agent-extension/asset.yaml`
- [x] Verify `solution.yaml` `assets:` list includes `./assets/closing-escalation-agent-extension/asset.yaml`

## Final Validation

- [x] `assets/closing-escalation-agent-extension/extension.yaml` exists and is well-formed YAML
- [x] `assets/closing-escalation-agent-extension/asset.yaml` exists and is well-formed YAML
- [x] `extension.yaml` `capabilityImplementations` includes `instruction` with non-empty content covering all three escalation rules
- [x] `extension.yaml` does NOT contain any write-capable tools or n8n hook entries
- [x] `asset.yaml` `requires` includes the base agent entry (`kind: agent`, ordId `sap.agtcloass:agent:financial-closing-assistant:v1`)
- [x] `solution.yaml` `assets:` list includes `./assets/closing-escalation-agent-extension/asset.yaml`
- [x] Re-read both YAML files and verify:
  - Rule 1 (Critical, EUR 100,000 threshold) is present in the instruction
  - Rule 2 (Urgent, 4-hour deadline window) is present in the instruction
  - Rule 3 (Flag, overdue + downstream dependency blocking) is present in the instruction
  - Multi-rule reporting requirement is present
  - Read-only advisory constraint is present
  - Output format (Critical → Urgent → Flag, always three sections) is present
  - All four milestone log statements (M1–M4) are present
