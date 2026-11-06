---
name: billing-review
description: Guides the agent through a full customer billing review — retrieving billing data and contract terms, comparing payment behavior, identifying discrepancies, and generating a Customer Billing Review Summary.
allowed-tools:
  - get_customer_billing_information
  - get_contract_payment_terms
---

# Customer Billing Review Skill

Follow these steps in order for a full customer billing review:

## Step 1: Retrieve Customer Billing Information
Use the `get_customer_billing_information` tool with the provided customer ID.
- If the tool returns no data, inform the user and stop. Log: `M1.missed: billing data retrieval failed or returned no results for customer {customer_id}`
- On success, log: `M1.achieved: billing data retrieved for customer {customer_id}`

## Step 2: Retrieve Contract Payment Terms
Use the `get_contract_payment_terms` tool with the same customer ID.
- If the tool returns no data, inform the user and stop. Log: `M2.missed: contract terms retrieval failed or returned no results for customer {customer_id}`
- On success, log: `M2.achieved: contract payment terms retrieved for customer {customer_id}`

## Step 3: Compare Billing vs. Contract Terms
Analyze the billing data against the contractual payment terms. Look for:
- Invoices paid after the contracted due date (late payments)
- Invoices currently overdue beyond the contracted grace period
- Partial payments or underpayments on any invoice
- Any other deviations from agreed terms

- If comparison cannot be completed due to missing data, log: `M3.missed: comparison could not be completed due to missing data for customer {customer_id}`
- On success, log: `M3.achieved: billing vs contract comparison completed for customer {customer_id}`

## Step 4: Generate Customer Billing Review Summary
Produce a structured summary using this exact format:

---
**CUSTOMER BILLING REVIEW SUMMARY**
**Customer ID:** {customer_id}
**Customer Name:** {customer_name}
**Review Date:** {current_date}

**BILLING OVERVIEW**
- Open Invoices: {count}
- Total Open Amount: USD {amount}
- Overdue Amount: USD {overdue_amount}

**CONTRACTUAL PAYMENT TERMS**
- Payment Terms: {terms} (e.g., Net-30, Net-60)
- Discount Terms: {discount_terms or "None"}
- Penalty Clauses: {penalty_clauses or "None"}

**IDENTIFIED DISCREPANCIES**
| Invoice ID | Amount (USD) | Due Date | Payment Date | Variance (Days) | Severity |
|------------|-------------|----------|--------------|-----------------|----------|
| {invoice_id} | {amount} | {due_date} | {payment_date or "Unpaid"} | {days} | High/Medium/Low |

*(If no discrepancies: "No discrepancies identified. Customer is paying within agreed terms.")*

**FINDINGS SUMMARY**
{narrative summary of payment behavior and key findings}

**RECOMMENDATIONS**
{justified advisory recommendations — read-only, no actions initiated}
- Example: "Customer {name} is consistently paying 15+ days beyond net-30 terms. Recommend scheduling a payment terms review discussion."
---

- On success, log: `M4.achieved: Customer Billing Review Summary generated for customer {customer_id}`
- On failure, log: `M4.missed: summary generation failed for customer {customer_id}`
