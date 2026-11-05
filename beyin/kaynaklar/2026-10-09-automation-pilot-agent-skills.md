---
tur: kaynak
alan: ai
tarih: 2026-10-09
guven: resmi
kaynak: https://github.com/SAP/automation-pilot-agent-skills
gozden_gecir: 2027-04-09
---
# SAP/automation-pilot-agent-skills
https://github.com/SAP/automation-pilot-agent-skills

Yazı türü: arac

SAP Automation Pilot (BTP native otomasyon/orkestrasyon motoru) içeriği geliştirmek için Claude Code'a yönelik resmi SAP agent skill deposu.

- 10 skill: Command Generation, Catalog Explorer, Code Review, Content Management API, Executions API, Execution Debugger, Scheduled Executions API, MCP Server Generation, HTTP Executor, Script Executor.
- Doğal dilden Command (JSON schema + jq expression) üretimi; güvenlik/naming/expression sanitization için otomatik review; API ile deploy, tetikleme, izleme ve hata örüntüsü eşleştirmeli debug.
- Kapsadığı BTP servisleri: HANA Cloud lifecycle, Cloud Foundry, Kyma/Kubernetes, Service Manager, Cloud ALM, AI Core, cTMS transport, XSUAA/destination, DevOps (GitHub/Jenkins/JIRA), bildirimler.
- MCP Server Generation skill'i Command'ları AI asistan tool'u (MCP server) olarak expose edebiliyor — agentic BI/ops senaryoları için potansiyel köprü.
- Kimlik bilgileri `.env` dosyasında (gitignored) saklanıyor: AUTOPI_HOSTNAME (bölgeye özgü: emea/amer/apac/aus/ksa.autopilot.cloud.sap), AUTOPI_USERNAME, AUTOPI_PASSWORD, AUTOPI_DEFAULT_CATALOG.
- Apache-2.0 lisanslı, SAP resmi org (github.com/SAP), ama küçük/erken aşama proje: 12 yıldız, son push 2026-09-14.
- Ön koşullar: Claude Code, curl, jq, Automation Pilot tenant + API credentials.

## Beslediği sayfalar
- [[araclar/automation-pilot-agent-skills]]
