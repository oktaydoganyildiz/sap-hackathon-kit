# Customer Billing Review Agent — Barton Industrial Supply

## Business challenge

Barton Industrial Supply needs a read-only AI agent that retrieves current customer billing information and contractual payment terms, compares actual payment behavior against agreed terms, identifies meaningful discrepancies, and generates a structured Customer Billing Review Summary with findings and justified recommendations. The agent must not modify invoices, contracts, or payment arrangements, and must clearly decline any out-of-scope requests.

## Business Goals & Success Criteria

| Metric | Baseline | Target | Timeline | Process / Capability | Source |
|--------|----------|--------|----------|----------------------|--------|
| Reduce manual billing review time per customer | — | 70% reduction | — | Customer Billing Review | agent-derived |
| Discrepancy detection rate per review cycle | — | 95%+ of billing vs. contract mismatches flagged | — | Invoice to Cash | agent-derived |
| Out-of-scope request deflection | — | 100% clearly declined | — | Agent guardrails | agent-derived |

## Key Milestones

1. **Billing Data Retrieved** — Agent successfully fetches current invoice and billing data for the requested customer.
2. **Contract Terms Retrieved** — Agent successfully fetches contractual payment terms for the requested customer.
3. **Comparison Performed** — Agent compares payment behavior against agreed terms and identifies discrepancies.
4. **Review Summary Generated** — Agent produces a structured Customer Billing Review Summary with findings and recommendations.
5. **Out-of-Scope Request Handled** — Agent detects and clearly declines any request outside its read-only review mandate.

## Business Architecture (RBA)

### End-to-End Process

Lead to Cash Standard B2B

### Process Hierarchy

```
Lead to Cash Standard B2B (E2E)
└── Invoice to Cash (physical products and services)
    └── Manage customer invoices (BPS-363_002)
        └── Prepare billing data
        └── Review payment terms against billing records
        └── Identify payment discrepancies
        └── Generate billing review summary
```

### Summary

The customer billing review challenge maps to the Lead to Cash E2E process, specifically the Invoice to Cash phase — covering billing data retrieval, contract payment term lookup, payment behavior comparison, and discrepancy reporting.

## Fit Gap Analysis

| Requirement (business) | Standard asset(s) found | API ORD ID | MCP Server ORD ID | MCP Server Version | Webhook API ORD ID | Gap? | Notes / assumptions |
|------------------------|------------------------|------------|-------------------|--------------------|--------------------|------|---------------------|
| Retrieve customer billing information | Billing Document (SAP S/4HANA Cloud) | `sap.s4:apiResource:CE_BILLINGDOCUMENT_0001:v1` | — | — | — | Yes | No pre-built MCP server; custom MCP tool required for testing; mock data used in Preview |
| Retrieve contractual payment terms | Contract Accounting Business Partner Payment (SAP S/4HANA Cloud) | `sap.s4:apiResource:API_CABUSPARTPAYMENT_0002:v2` | — | — | — | Yes | No pre-built MCP server; custom MCP tool required; mock data used in Preview |
| Compare billing vs. contract terms & identify discrepancies | SAP S/4HANA Cloud — Customer Invoice Processing, Billing Data Management | — | — | — | — | Partial | Agent reasoning layer performs comparison; no dedicated standard tool found |
| Generate Customer Billing Review Summary | — | — | — | — | — | Yes | Custom agent capability; structured output formatted by the agent |
| Read-only enforcement (no write operations) | — | — | — | — | — | No | Enforced via agent system prompt and scope guardrails |

### Key findings

- SAP S/4HANA Cloud provides the billing and contract payment capabilities required; no pre-built MCP servers exist for these APIs in the customer landscape.
- Custom MCP tools (or mock tools) must be built for both the Customer Billing Information and Contract Information capabilities.
- Mock data is required to support Preview/testing mode.
- The agent's comparison and summary generation are implemented as reasoning logic, not standard SAP tooling.
- Read-only scope is enforced entirely within the agent; no backend write permissions are needed.
- The solution is self-contained as a Python A2A agent with no n8n workflow dependency.

## Recommendations

### Customer Billing Review AI Agent

#### Executive Summary

Python A2A agent with billing + contract tools, read-only, mock-enabled for Preview.

#### Recommended Solution

A pro-code Python AI agent (A2A protocol) for Barton Industrial Supply that integrates the Customer Billing Information and Contract Information capabilities as MCP tools. The agent supports three interaction modes: billing-only, contract-only, and full customer review (both capabilities). For full reviews, it compares payment behavior against agreed terms, identifies discrepancies, and produces a Customer Billing Review Summary. Mock data is provided for Preview testing. The agent enforces read-only scope and declines all out-of-scope requests with a clear explanation.

#### Recommended solution category

AI Agent

#### Intent fit
95%
