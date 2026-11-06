# Specification: customer-billing-review-agent

> **Guidelines**: Read all applicable guidelines before executing ANY tasks below:
> - [guidelines.md](../guidelines.md) — Universal execution rules
> - [guidelines-agent.md](../guidelines-agent.md) — Universal agent patterns
> - [guidelines-agent-python.md](../guidelines-agent-python.md) — Python implementation details
> - [guidelines-agent-skills.md](../guidelines-agent-skills.md) — Runtime skills patterns
> - [guidelines-agent-mcp.md](../guidelines-agent-mcp.md) — MCP integration patterns

---

## Basic Setup

- [ ] Read `product-requirements-document.md` and `intent.md` for full requirements context.
- [ ] Bootstrap agent code in `assets/customer-billing-review-agent/` using instructions from the sap-agent-bootstrap section. (invoke from inside `assets/customer-billing-review-agent/`, use copy commands — do NOT create files manually)
- [ ] Install dependencies, validate the agent starts and responds at `/.well-known/agent.json`

---

## Runtime Skills

- [ ] Create `assets/customer-billing-review-agent/app/skills/billing-review/SKILL.md` with instructions for full customer billing review (steps: retrieve billing → retrieve contract terms → compare → summarize). Include the Customer Billing Review Summary format as a template.
- [ ] Create `assets/customer-billing-review-agent/app/skills/out-of-scope/SKILL.md` with instructions for detecting and declining out-of-scope requests (modifying invoices, issuing credits/write-offs, changing payment terms, initiating collections). Include example decline message template.

---

## Project-Specific Tasks

### Agent Identity & System Prompt

- [ ] In `assets/customer-billing-review-agent/app/agent.py`, set the agent name to `Customer Billing Review Agent` and company to `Barton Industrial Supply`.
- [ ] Write a system prompt that:
  - Identifies the agent as a read-only Customer Billing Review Agent for Barton Industrial Supply.
  - States the agent's three operating modes:
    - **Billing-only**: use only the `get_customer_billing_information` tool; do not fetch contract data.
    - **Contract-only**: use only the `get_contract_payment_terms` tool; do not fetch billing data.
    - **Full customer review**: use both tools, compare payment behavior against agreed terms, identify discrepancies, and generate a Customer Billing Review Summary.
  - Explicitly prohibits: modifying invoices or contracts, issuing credits or write-offs, changing payment arrangements, initiating collection actions.
  - Instructs the agent to clearly decline any out-of-scope request with a polite explanation referencing the read-only mandate.
  - Instructs the agent to generate a structured Customer Billing Review Summary containing: Customer ID, billing overview (open invoices, overdue amounts, payment history), contractual payment terms, identified discrepancies (with detail), and justified recommendations.

### Customer Billing Information Tool

- [ ] Invoke `mcp-translation-file` skill for `CE_BILLINGDOCUMENT_0001.edmx` (located at `specification/customer-billing-review-agent/api-specs/CE_BILLINGDOCUMENT_0001.edmx`) with:
  - `apiOrdId`: `sap.s4:apiResource:CE_BILLINGDOCUMENT_0001:v1`
  - `apiType`: `edmx`
  - `serverName`: `barton/customer-billing-information-mcp-server`
  - `serverTitle`: `Customer Billing Information MCP Server`
  - Scope hint: `MCP tool scope: read-only` — Resources in scope: billing documents, customer billing data, payment history.
- [ ] Register generated MCP server asset via `setup-solution` skill.
- [ ] Add entry in `asset.yaml` under `requires` for the Customer Billing Information MCP server.

### Contract Information Tool

- [ ] Invoke `mcp-translation-file` skill for `API_CABUSPARTPAYMENT_0002.edmx` (located at `specification/customer-billing-review-agent/api-specs/API_CABUSPARTPAYMENT_0002.edmx`) with:
  - `apiOrdId`: `sap.s4:apiResource:API_CABUSPARTPAYMENT_0002:v2`
  - `apiType`: `edmx`
  - `serverName`: `barton/contract-information-mcp-server`
  - `serverTitle`: `Contract Information MCP Server`
  - Scope hint: `MCP tool scope: read-only` — Resources in scope: contract payment terms, business partner payment data.
- [ ] Register generated MCP server asset via `setup-solution` skill.
- [ ] Add entry in `asset.yaml` under `requires` for the Contract Information MCP server.

### Mock Data for Preview Testing

- [ ] After MCP server assets are generated, run the `mcp-mock-config` skill to generate `mcp-mock.json` for both MCP servers.
- [ ] Ensure `mcp-mock.json` includes at least two customer scenarios:
  - **Customer A (Compliant)**: paying within agreed net terms, no overdue invoices.
  - **Customer B (Non-Compliant)**: one or more invoices overdue beyond agreed payment terms, with a discrepancy that the agent should detect and report.
- [ ] Mock data must be realistic for an industrial supply company (invoice amounts in USD, net-30 or net-60 payment terms, standard billing document fields).

### Customer Billing Review Logic

- [ ] Wire MCP tool loading in `agent.py` using `get_mcp_tools()` from the `mcp_tools` module — NEVER import directly from `sap_cloud_sdk.agentgateway` and NEVER create direct HTTP clients.
- [ ] Implement routing logic so the agent uses:
  - Only `get_customer_billing_information` for billing-only requests.
  - Only `get_contract_payment_terms` for contract-only requests.
  - Both tools for full customer review requests.
- [ ] Implement comparison logic (via agent reasoning in the system prompt / skill) that identifies:
  - Late payments (actual payment date vs. due date per contract terms).
  - Underpayments or partial payments.
  - Invoices overdue beyond contracted grace period.
  - Any other meaningful payment behavior deviations.
- [ ] Implement structured Customer Billing Review Summary output format with these sections:
  1. Customer ID & Name
  2. Billing Overview (open invoices count, total open amount, overdue amount)
  3. Contractual Payment Terms
  4. Identified Discrepancies (table: Invoice ID | Amount | Due Date | Actual Payment | Variance | Severity)
  5. Findings Summary (narrative)
  6. Recommendations (justified, read-only — advisory only)

### Out-of-Scope Guardrails

- [ ] Add explicit guardrail checks in the agent system prompt for the following prohibited actions; the agent must decline ALL of these with a clear message:
  - Modifying invoice details or amounts
  - Issuing credits, write-offs, or adjustments
  - Changing payment terms or schedules
  - Initiating or escalating collection actions
  - Any write, update, or delete operation on SAP data
- [ ] Test that the agent correctly declines at least three out-of-scope request types (see Testing section).

---

## MCP API Scope Hints

```
MCP API: sap.s4:apiResource:CE_BILLINGDOCUMENT_0001:v1
MCP tool scope: read-only
Resources in scope: BillingDocument, BillingDocumentItem, BillingDocumentPartner

MCP API: sap.s4:apiResource:API_CABUSPARTPAYMENT_0002:v2
MCP tool scope: read-only
Resources in scope: BusPartPayment, BusPartPaymentItem
```

---

## Business Instrumentation

- [ ] Implement business step instrumentation for all five milestones from the PRD using structured logging pattern `[MILESTONE_ID].[achieved|missed]: [description]` and OpenTelemetry custom spans. See [guidelines-agent-python.md](../guidelines-agent-python.md) for Python-specific implementation.

  - `M1.achieved: billing data retrieved for customer {customer_id}`
  - `M1.missed: billing data retrieval failed or returned no results for customer {customer_id}`
  - `M2.achieved: contract payment terms retrieved for customer {customer_id}`
  - `M2.missed: contract terms retrieval failed or returned no results for customer {customer_id}`
  - `M3.achieved: billing vs contract comparison completed for customer {customer_id}`
  - `M3.missed: comparison could not be completed due to missing data for customer {customer_id}`
  - `M4.achieved: Customer Billing Review Summary generated for customer {customer_id}`
  - `M4.missed: summary generation failed for customer {customer_id}`
  - `M5.achieved: out-of-scope request detected and declined — request type: {request_type}`
  - `M5.missed: out-of-scope request not properly identified or declined`

- [ ] Verify `bootstrap(app)` is called after `app = server.build()` in `main.py`

---

## Testing

- [ ] `conftest.py` only sets `IBD_TESTING=true` — this causes the agent to run with mock MCP tool results during tests.
- [ ] Write unit tests in `assets/customer-billing-review-agent/tests/`:
  - `test_billing_tool.py` — validates billing-only mode invokes only the billing tool.
  - `test_contract_tool.py` — validates contract-only mode invokes only the contract tool.
  - `test_full_review.py` — validates full review mode invokes both tools and returns a Customer Billing Review Summary.
  - `test_out_of_scope.py` — validates that requests to modify invoices, issue credits, change payment terms, and initiate collections are each declined.
  - `test_mock_compliant_customer.py` — validates the agent reports no discrepancies for the compliant mock customer.
  - `test_mock_noncompliant_customer.py` — validates the agent identifies and reports discrepancies for the non-compliant mock customer.
- [ ] Write one integration test executing end-to-end agent flow with mocked LLM responses and mocked MCP tools (tests must run offline).
- [ ] Run `pytest` from `assets/customer-billing-review-agent/` (no args) — if coverage < 70%, add tests until threshold met.
- [ ] Run `pytest` again from `assets/customer-billing-review-agent/` to generate final `test_report.json`.
- [ ] Verify `test_report.json` exists in `assets/customer-billing-review-agent/`.
