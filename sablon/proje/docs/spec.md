# Spec — <PROJE ADI>

## Problem
<Who suffers, how much (person-days, error rate, volume). One paragraph.>

## Persona
<Role, what they do today, where they leave SAP (Excel, email…).>

## KPI
<From X to Y> · volume: <n per month> · baseline: <source or "assumption">.

## Demo story (5 min)
1. <Persona + pain number>
2. <Happy-path case: agent proposes with confidence + rationale>
3. <Exception case: low confidence → routed to human>
4. <Human approves → action executed>
5. <Trace / eval pass rate on screen>
6. <KPI delta + path to production>

## Architecture
```
Joule (Work) ──A2A / managed──► Agent ──MCP──► Tools ──► <SAP source>
                                  │
                                  └── HITL approval ──► <write action>
```
- Path: <A: jl managed runtime | B: own agent on BTP + A2A>
- LLM: Generative AI Hub (orchestration, masking, filtering)
- Data source: <S/4 API | Datasphere view | HANA Cloud>
- Tools: see `contract.md`
- Identity: <user-context / principal propagation | technical user (read only)>

## Out of scope
- <…>

## Risks
- <access / data / time>
