# Financial Closing Escalation Extension – Stonebridge Equipment Group

Extend the SAP Financial Closing Assistant with company-specific closing escalation rules to drastically reduce the time required to identify and act on critical period-end closing issues.

## Business Challenge

Stonebridge Equipment Group's Finance Controllers spend up to two hours per period-end close manually scanning for critical issues — posting errors above EUR 100,000, incomplete closing tasks approaching the official deadline, and overdue tasks that block downstream dependencies. This manual process delays corrective action and increases schedule risk. The objective is to reduce issue identification and escalation time to 15 minutes by embedding automated, rule-based escalation logic directly into the existing Financial Closing Assistant. All output must remain strictly advisory (read-only); no documents are posted, no tasks are completed, and no schedules are modified.

## Business Goals & Success Criteria

| Metric | Baseline | Target | Timeline | Process / Capability | Source |
|--------|----------|--------|----------|----------------------|--------|
| Time to identify & escalate critical closing issues | 2 hours | 15 minutes | Per period-end close | Financial Period-End Closing – Escalation | user |
| Posting errors above EUR 100,000 classified as Critical | Manual / ad hoc | Automated – 100% coverage | Per period-end close | Posting Error Detection | user |
| Incomplete tasks flagged with < 4 hrs to deadline | Manual / ad hoc | Automated – 100% coverage | Per period-end close | Closing Task Monitoring | user |
| Overdue tasks blocking dependencies flagged as Schedule Risk | Manual / ad hoc | Automated – 100% coverage | Per period-end close | Dependency Risk Management | user |

## Key Milestones

- **Escalation Rules Active**: Extension deployed and all three classification rules (Critical, Urgent, Flag) operational for Finance Controllers.
- **Consolidated Summary Delivered**: Agent produces a prioritised escalation summary ordered Critical → Urgent → Flag, including task/document references, escalation reasons, and recommended next steps.
- **Multi-Rule Coverage**: Items matching multiple rules are reported with all applicable conditions listed.
- **Read-Only Compliance Verified**: No write operations triggered under any escalation scenario.

## Business Architecture (RBA)

### End-to-End Process

Record to Report (Finance)

### Process Hierarchy

```
Record to Report (E2E)
└── Record to Report Phase
    └── Perform Accounting and Financial Close (BPS-413_002)
        └── Perform Financial Closing
        └── Perform Financial Reporting
```

### Summary

The closing escalation challenge maps directly to the "Perform Accounting and Financial Close" sub-process within the Record to Report E2E, covering financial closing task orchestration (via SAP Advanced Financial Closing) and posting error detection (via SAP S/4HANA General Ledger). Escalation logic sits as an intelligent layer on top of this standard process.

## Fit Gap Analysis

| Requirement (business) | Standard asset(s) found | API ORD ID | MCP Server ORD ID | MCP Server Version | Webhook API ORD ID | Data Product ORD ID | Gap? | Notes / assumptions |
|---|---|---|---|---|---|---|---|---|
| Detect posting errors > EUR 100,000 | SAP S/4HANA – Journal Entry Item Read | `sap.s4:apiResource:API_JOURNALENTRYITEMBASIC_SRV:v1` | — | — | — | — | Maybe | No MCP server found; agent extension will leverage the Financial Closing Assistant's built-in data access or instruct via custom tools |
| Read accounting document amounts | SAP S/4HANA – Accounting Document Read | `sap.s4:apiResource:API_OPLACCTGDOCITEMCUBE_SRV:v1` | — | — | — | — | Maybe | No MCP server found; same approach as above |
| Read closing task status and deadlines | SAP Advanced Financial Closing (AFC) | AFC Scheduling SPI (`sap.afc:apiResource:SSPIV1:v1`) — **unavailable** | — | — | — | — | Yes | AFC APIs not available in this landscape; extension will rely on the Financial Closing Assistant's existing AFC-connected capabilities and instruct escalation logic via custom instructions |
| Apply Stonebridge-specific escalation rules (3 rules) | Financial Closing Assistant (extensible) | — | — | — | — | — | No | Extension capability confirmed: custom instructions + Before Hook supported |
| Generate consolidated prioritised escalation summary | Financial Closing Assistant (extensible) | — | — | — | — | — | No | Achievable via custom instructions in the agent extension |
| Strict read-only enforcement | Financial Closing Assistant (extensible) | — | — | — | — | — | No | Read-only constraint enforced via extension instructions; no write tools added |

### Key findings

- The Financial Closing Assistant (`sap.agtcloass:agent:financial-closing-assistant:v1`) is available and supports custom instructions, tool additions, and Before/After Hooks — all required extension capabilities are present.
- AFC Scheduling APIs are marked unavailable in this landscape; the extension will delegate AFC task data retrieval to the base agent's existing AFC integration and apply escalation rules via instructions.
- No MCP servers exist for the S/4HANA Journal Entry or Accounting Document APIs; the extension instructions will leverage the Financial Closing Assistant's current tool set for data access.
- All three escalation rules (Critical – posting errors > EUR 100,000; Urgent – < 4 hrs to deadline; Flag – overdue tasks blocking dependencies) are implementable purely through custom instructions without new API integrations.
- The solution is strictly advisory: the extension adds no write tools and explicitly prohibits document posting, task completion, or schedule modification.

## Recommendations

### Company-Specific Closing Escalation Rules via Agent Extension

#### Executive Summary

Extend the existing Financial Closing Assistant with Stonebridge escalation rules via a Before Hook and custom instructions.

#### Recommended Solution

Implement an agent extension for `sap.agtcloass:agent:financial-closing-assistant:v1` that injects three company-specific escalation classification rules into the Financial Closing Assistant's reasoning context. A Before Hook pre-processes each closing query by applying:

1. **Critical – Immediate Action Required**: Posting errors with amounts exceeding EUR 100,000.
2. **Urgent – Deadline Imminent**: Incomplete closing tasks with fewer than four hours remaining before the official period-end deadline.
3. **Flag – Schedule Risk**: Overdue closing tasks that block downstream closing dependencies.

The extension generates a consolidated escalation summary ordered Critical → Urgent → Flag, including document/task references, escalation reason, and recommended next steps. Items matching multiple rules are reported with all applicable conditions. All actions remain advisory; no write operations are performed.

#### Problem Statement

Finance Controllers at Stonebridge Equipment Group spend up to two hours per period-end close manually identifying critical issues across posting errors and closing task lists. This delay increases the risk of missed deadlines and cascading schedule failures. An automated, rule-based extension to the existing Financial Closing Assistant eliminates this manual effort.

#### Affected User Roles

- Finance Controller / Accounting Manager (primary consumer of the escalation summary)

#### Important Factors

##### Preserves Existing Financial Closing Assistant Capabilities

The extension augments rather than replaces the base agent. All existing journal entry, accruals, clearing, and analytical capabilities remain fully intact.

##### No Additional API Integrations Required

The escalation rules are applied through custom instructions that operate on data the base agent already retrieves from AFC and S/4HANA. This minimises integration complexity and deployment risk.

##### Read-Only and Advisory by Design

The extension explicitly prohibits all write operations. This ensures compliance with period-end controls and audit requirements — no approvals, postings, or schedule changes can be triggered.

#### Potential Risks

##### AFC API Unavailability

AFC Scheduling APIs are not available in this landscape. The extension relies on the base agent's existing AFC integration. If the base agent's AFC data access changes, escalation accuracy may be affected.

##### Escalation Rule Precision

Threshold-based rules (EUR 100,000, 4-hour window) are fixed parameters. Changes to Stonebridge's closing policies will require extension updates.

#### Recommended solution category

Agent Extension

#### Intent fit
93%
