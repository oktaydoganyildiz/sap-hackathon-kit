# Product Requirements Document (PRD)

**Title:** Customer Billing Review Agent — Barton Industrial Supply
**Date:** 2026-11-06
**Owner:** Barton Industrial Supply — Finance / Accounts Receivable
**Solution Category:** AI Agent

---

## Product Purpose & Value Proposition

**Elevator Pitch:**
Finance and AR teams at Barton Industrial Supply spend significant time manually pulling billing records and contracts to check whether customers are paying on time and per agreed terms. This agent automates that retrieval, comparison, and reporting in seconds — entirely read-only.

**Business Need:**
There is no unified, conversational tool to quickly retrieve a customer's current billing status, look up their contractual payment terms, compare the two, and surface discrepancies. Analysts must navigate multiple SAP screens or exports and assemble findings manually.

**Expected Value:**
Faster, more consistent billing reviews; higher discrepancy detection; and freed capacity for AR and finance staff to focus on resolution rather than data gathering.

**Product Objectives (Prioritized):**
1. Reduce manual billing review time per customer by 70%.
2. Detect 95%+ of billing-vs-contract discrepancies per review cycle.
3. Ensure 100% of out-of-scope requests are clearly declined.

---

## Business Metrics

| Metric | Baseline | Target | Timeline | Process / Capability | Source |
|--------|----------|--------|----------|----------------------|--------|
| Manual billing review time per customer | — | 70% reduction | — | Customer Billing Review | agent-derived |
| Discrepancy detection rate per review cycle | — | 95%+ | — | Invoice to Cash | agent-derived |
| Out-of-scope request deflection rate | — | 100% | — | Agent guardrails | agent-derived |

---

## Requirements

### Must-Have Requirements

**R1**: Retrieve Customer Billing Information

- **Problem to Solve**: AR analysts need quick access to a customer's current billing status, open invoices, and payment history without navigating SAP manually.
- **User Story**: As an AR analyst, I need to ask the agent for a customer's current billing information so that I can assess their payment status quickly.
- **Acceptance Criteria**:
  - Given a valid customer ID, when the analyst requests billing info, then the agent returns current invoice data, open balances, and recent payment history.
  - Given a billing-only request, when the agent responds, then only the Customer Billing Information capability is used (no contract data fetched).
- **Maps to Objective**: Objective 1
- **Priority Rank**: 1

**R2**: Retrieve Contract Payment Terms

- **Problem to Solve**: Analysts need to know what payment terms were agreed with a customer in order to evaluate payment behavior.
- **User Story**: As a credit manager, I need to retrieve the contractual payment terms for a customer so that I can determine whether their payment behavior is within agreement.
- **Acceptance Criteria**:
  - Given a valid customer ID, when the analyst requests contract terms, then the agent returns the agreed payment terms (due dates, discount terms, penalty clauses if applicable).
  - Given a contract-only request, when the agent responds, then only the Contract Information capability is used (no billing data fetched).
- **Maps to Objective**: Objective 1
- **Priority Rank**: 2

**R3**: Full Customer Billing Review (Billing + Contract Comparison)

- **Problem to Solve**: Analysts need to compare actual payment behavior against contracted terms to identify customers who are paying late, underpaying, or otherwise deviating from agreed conditions.
- **User Story**: As an AR analyst, I need the agent to compare a customer's billing data with their contract terms so that I can identify payment discrepancies without manual cross-referencing.
- **Acceptance Criteria**:
  - Given a full review request, when the agent processes it, then both capabilities are invoked and the results are compared.
  - Given the comparison is complete, when discrepancies exist, then they are identified and described (e.g., "Customer paying 15 days beyond net-30 terms").
  - Given no discrepancies, when the comparison is complete, then the agent confirms compliance.
- **Maps to Objective**: Objectives 1 & 2
- **Priority Rank**: 3

**R4**: Generate Customer Billing Review Summary

- **Problem to Solve**: Analysts need a structured, shareable output from a review — not raw data — to present findings to managers or use in collections discussions.
- **User Story**: As an AR analyst, I need the agent to produce a Customer Billing Review Summary with findings and recommendations so that I can act on or share the results.
- **Acceptance Criteria**:
  - Given a completed full review, when the agent responds, then the output is a structured Customer Billing Review Summary containing: customer identity, billing overview, contract terms, identified discrepancies, and justified recommendations.
  - The summary must be read-only analysis only — no actions initiated.
- **Maps to Objective**: Objectives 1 & 2
- **Priority Rank**: 4

**R5**: Decline Out-of-Scope Requests

- **Problem to Solve**: The agent must not be used to modify records, issue credits, change payment terms, or initiate collections — doing so could create compliance or legal risk.
- **User Story**: As a compliance officer, I need the agent to refuse any request outside its read-only review mandate so that no unauthorized actions are taken via the agent.
- **Acceptance Criteria**:
  - Given a request to modify an invoice, issue a credit, change payment terms, or initiate a collection action, when the agent receives it, then the agent clearly declines and explains it is outside scope.
  - The agent never performs write operations against any SAP system.
- **Maps to Objective**: Objective 3
- **Priority Rank**: 5

**R6**: Mock Data Support for Preview Testing

- **Problem to Solve**: Reviewers need to test the agent's behavior in Preview before connecting to live SAP data.
- **User Story**: As a developer or reviewer, I need the agent to work with generated mock data in Preview mode so that I can validate its behavior without live system access.
- **Acceptance Criteria**:
  - Given the agent is running in Preview, when a billing or contract review is requested, then realistic mock customer billing and contract data is returned.
  - Mock data must cover at least one compliant customer and one customer with payment discrepancies.
- **Maps to Objective**: Objective 1
- **Priority Rank**: 6

---

## Solution Architecture

**Architecture Overview:**
A single Python A2A AI agent backed by two MCP tools — one for Customer Billing Information and one for Contract Information. In Preview/test mode, both tools return deterministic mock data. In production, the tools connect to SAP S/4HANA Cloud APIs.

**Key Components:**

- **Billing Review Agent (Python A2A)**: Core reasoning agent; routes requests to the appropriate tool(s), performs comparison logic, generates the Customer Billing Review Summary.
- **Customer Billing Information MCP Tool**: Fetches invoice, open balance, and payment history data for a given customer (read-only). Uses `sap.s4:apiResource:CE_BILLINGDOCUMENT_0001:v1` in production; returns mock data in Preview.
- **Contract Information MCP Tool**: Fetches contractual payment terms for a given customer (read-only). Uses `sap.s4:apiResource:API_CABUSPARTPAYMENT_0002:v2` in production; returns mock data in Preview.
- **Mock Data Provider**: Supplies deterministic test data for both tools when running in Preview, including at least one compliant and one non-compliant customer scenario.

**Integration Points:**

- SAP S/4HANA Cloud — Billing Document API (`CE_BILLINGDOCUMENT_0001`) — read-only, on-demand per request.
- SAP S/4HANA Cloud — Contract Accounting Business Partner Payment API (`API_CABUSPARTPAYMENT_0002`) — read-only, on-demand per request.

---

### Agent Extensibility & Instrumentation

**Agent Extensibility:**
The agent is designed with extension points so that additional review capabilities (e.g., dunning history, credit limit checks) can be added as new MCP tools without restructuring the core agent.

**Business Step Instrumentation:**
All key business steps are instrumented with structured log statements following the pattern `[MILESTONE_ID].[achieved|missed]: [description]` to support observability in production.

---

### Automation & Agent Behaviour

**Automation Level:** Autonomous agent (read-only, no write actions)

**Actions the agent performs without human approval:**
- Retrieve customer billing information
- Retrieve contract payment terms
- Compare billing data against contract terms
- Identify and describe discrepancies
- Generate and return Customer Billing Review Summary

**Actions that require human review or approval:**
- All resolution actions (credits, write-offs, payment arrangement changes, collections) — these are explicitly out of scope and will be declined.

**Model or engine used:** SAP Generative AI Hub (default LLM)

**Knowledge & data sources accessed:**
- SAP S/4HANA Cloud: Customer billing documents and payment history (read-only)
- SAP S/4HANA Cloud: Contract payment terms (read-only)
- Mock data provider (Preview/testing only)

**Tools or connectors invoked:**
- `get_customer_billing_information` (read-only): Retrieves current billing data for a given customer.
- `get_contract_payment_terms` (read-only): Retrieves contractual payment terms for a given customer.

**Guardrails & fail-safes:**
- Agent will never write, update, or delete any SAP record.
- Agent will never issue credits, write-offs, or initiate collection actions.
- Agent will never change payment arrangements or contract terms.
- Any out-of-scope request results in a clear, polite decline with an explanation.
- If a tool returns no data, the agent informs the user and does not proceed with a partial review.

---

## Milestones

### M1: Billing Data Retrieved

- **Description**: The agent has successfully fetched current billing information for the requested customer.
- **Achieved when**: The Customer Billing Information tool returns a valid response with invoice and payment data.
- **Log on achievement**: `M1.achieved: billing data retrieved for customer {customer_id}`
- **Log on miss**: `M1.missed: billing data retrieval failed or returned no results for customer {customer_id}`

### M2: Contract Terms Retrieved

- **Description**: The agent has successfully fetched the contractual payment terms for the requested customer.
- **Achieved when**: The Contract Information tool returns a valid response with payment term data.
- **Log on achievement**: `M2.achieved: contract payment terms retrieved for customer {customer_id}`
- **Log on miss**: `M2.missed: contract terms retrieval failed or returned no results for customer {customer_id}`

### M3: Billing vs. Contract Comparison Performed

- **Description**: The agent has compared the customer's actual payment behavior against their agreed contractual terms.
- **Achieved when**: The agent completes the comparison and identifies whether discrepancies exist.
- **Log on achievement**: `M3.achieved: billing vs contract comparison completed for customer {customer_id}`
- **Log on miss**: `M3.missed: comparison could not be completed due to missing data for customer {customer_id}`

### M4: Customer Billing Review Summary Generated

- **Description**: The agent has produced and returned a structured Customer Billing Review Summary.
- **Achieved when**: The agent outputs a summary containing billing overview, contract terms, discrepancies (if any), and recommendations.
- **Log on achievement**: `M4.achieved: Customer Billing Review Summary generated for customer {customer_id}`
- **Log on miss**: `M4.missed: summary generation failed for customer {customer_id}`

### M5: Out-of-Scope Request Handled

- **Description**: The agent detected and declined a request that falls outside its read-only review mandate.
- **Achieved when**: The agent identifies an out-of-scope request and returns a clear, structured decline message.
- **Log on achievement**: `M5.achieved: out-of-scope request detected and declined — request type: {request_type}`
- **Log on miss**: `M5.missed: out-of-scope request not properly identified or declined`
