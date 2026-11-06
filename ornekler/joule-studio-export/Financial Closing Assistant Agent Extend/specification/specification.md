# Specification

> **Guidelines**: Read [guidelines.md](./guidelines.md) before executing ANY tasks below.

Financial Closing Escalation Extension for Stonebridge Equipment Group — extends the SAP Financial Closing Assistant with three company-specific escalation classification rules (Critical, Urgent, Flag) delivered via a Before Hook and custom instructions. Strictly read-only and advisory. No new API integrations required.

Check off items as completed.

## Solution Setup

- [x] Create asset directory: `mkdir -p assets/closing-escalation-agent-extension/`
- [x] Invoke `setup-solution` skill to create `solution.yaml` and `asset.yaml` for the `closing-escalation-agent-extension` asset
- [x] Validate `solution.yaml` and `asset.yaml` exist and are well-formed

## Asset Implementation

- [x] Execute `specification/closing-escalation-agent-extension/specification.md` (all items)

## Post-Implementation Verification

- [x] Confirm `assets/closing-escalation-agent-extension/extension.yaml` contains all three escalation rules (Critical / Urgent / Flag), multi-rule reporting, read-only constraint, output format, and milestone log statements
- [x] Confirm `assets/closing-escalation-agent-extension/asset.yaml` requires the base agent `sap.agtcloass:agent:financial-closing-assistant:v1` version `1.0.0`
- [x] Confirm `solution.yaml` lists `./assets/closing-escalation-agent-extension/asset.yaml`
