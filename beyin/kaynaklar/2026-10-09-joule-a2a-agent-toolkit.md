---
tur: kaynak
alan: ai
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
kaynak: https://github.com/SAP-samples/joule-a2a-agent-toolkit
gozden_gecir: 2027-04-09
---

# SAP-samples/joule-a2a-agent-toolkit

https://github.com/SAP-samples/joule-a2a-agent-toolkit

Yazı türü: arac

SAP'nin resmi Claude Code plugin'i: A2A (Agent-to-Agent) protokolü ile SAP Joule'a bağlanan agent'ları doğrudan Claude Code içinden iskelet olarak oluşturup (scaffold), BTP Cloud Foundry'ye deploy eden araç seti. TypeScript (Express veya CAP) ve Python (LangGraph) desteği var; LLM tarafı SAP GenAI Hub (AI Core) üzerinden OrchestrationClient ile sağlanıyor. 4 skill içeriyor: joule-a2a-agent (agent scaffold), btp-cli, cf-cli, joule-cli. 3 komut içeriyor: create-agent, create-destination, deploy-agent — tek komutla CF push/MTA deploy + BTP destination + Joule capability oluşturma yapılabiliyor. Ön koşullar: cf CLI v8, Joule CLI, AI Core + Destination servisli BTP subaccount, Node 24.x, CAP için mbt + multiapps plugin. Apache-2.0 lisanslı, 38 yıldız, son push 2026-04-21 — küçük ölçekli resmi SAP-samples deposu.

## Beslediği sayfalar
- [[araclar/joule-a2a-agent-toolkit]]
