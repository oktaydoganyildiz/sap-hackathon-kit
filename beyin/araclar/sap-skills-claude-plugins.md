---
tur: arac
alan: ai
urun_surumu: "2.4.0 (2026-07-21), repo son push 2026-10-05"
tarih: 2026-10-08
guven: topluluk
gozden_gecir: 2027-04-08
---

# SAP Skills for AI Coding Assistants (secondsky/sap-skills)

## Ne yapar
40 SAP development plugin'i; Claude Code ve Codex CLI marketplace'leri üzerinden kurulabilir. Her plugin context-based auto-activation ile çalışan skill(ler) içerir (örn. "Create a new CAP service" dediğinde sap-cap-capire otomatik devreye girer, manuel çağrı gerekmez). Kapsam: BTP (15 plugin — best-practices, Work Zone Advanced, BAS, CIAS, Cloud Logging, Cloud Identity Services, core, CTM, Connectivity, Developer Guide, Integration Suite, ISA, Job Scheduling, MDI, Service Manager), Core Technologies (ABAP, ABAP CDS, AI Core, CAP/Capire, Cloud SDK AI + Python, HANA ML, RPT-1, SQLScript — 9), Data & Analytics (Datasphere, BW query, SAC planning/scripting/custom-widget/test-automation, HANA Cloud Data Intelligence — 7), UI (Fiori Tools, SAPUI5, SAPUI5 CLI/Linter — 4), Tooling (API policy/style, browser automation, dependency security, HANA CLI — 5). 7 plugin MCP server, 14 plugin agent, 8 plugin hook, 1 plugin (sap-cap-capire) LSP içeriyor.

## Bende durumu
**kurulu** — Envanter'de `sap-skills` marketplace'inden (v2.4.1) 24 plugin aktif: sap-abap, sap-abap-cds, sap-ai-core, sap-api-policy, sap-api-style, sap-browser-automation, sap-btp-best-practices, sap-btp-cloud-identity-services, sap-btp-cloud-platform, sap-btp-cloud-transport-management, sap-btp-connectivity, sap-btp-integration-suite, sap-bw-query, sap-cloud-sdk-ai, sap-datasphere, sap-hana-cli, sap-hana-cloud-data-intelligence, sap-hana-ml, sap-sac-custom-widget, sap-sac-planning, sap-sac-scripting, sap-sac-test-automation, sap-sqlscript. Ayrıca 9 plugin kurulu ama kapalı (çağrılamıyor, SKILL.md dosyadan okunabilir): sap-btp-build-work-zone-advanced, sap-btp-business-application-studio, sap-btp-cias, sap-btp-cloud-logging, sap-btp-developer-guide, sap-btp-intelligent-situation-automation, sap-btp-job-scheduling, sap-btp-master-data-integration, sap-btp-service-manager.

⚠ Çakışma: `sap-datasphere` MCP server adı hem bu repodan (plugin: sap-datasphere@sap-skills, `@mariodefe/sap-datasphere-mcp@1.7.0`) hem ayrı `datasphere@sap-datasphere-cowork` marketplace'inden (farklı Python tabanlı server) aynı anda tanımlı. Hangisinin fiilen bağlandığı belirsiz; canlı bağlantı testi yapılmadan körlemesine birini kapatma (Envanter uyarısı).

## Agentic BI'a katkısı
`sap-datasphere` (5 komut, 3 agent, MCP) ve `sap-bw-query` (3 komut, MCP, parola-güvenli Eclipse/BWMT sorgu inceleme/spesifikasyon review) modelleme ve sorgu katmanını; SAC plugin'leri (sac-planning, sac-scripting, sac-custom-widget, sac-test-automation) raporlama/planlama katmanını Claude içinden doğrudan otomatikleştiriyor — her biri kendi MCP server'ını taşıdığı için ayrı entegrasyon kurulumu gerektirmiyor. sap-cap-capire (CAP) ve sap-abap-cds, BW4/Datasphere'den beslenen backend servislerin kod üretimini hızlandırıyor.

## Kurulum
```bash
# Claude Code
/plugin marketplace add secondsky/sap-skills
/plugin install sap-datasphere@sap-skills
```

## Dikkat
- Lisans: **GPL-3.0** (kopyleft) — kurumsal/ticari dağıtım veya türetilmiş çalışma durumunda lisans koşullarını kontrol et.
- Son push: 2026-10-05, aktif bakım altında (462 yıldız, v2.4.0).
- Üçüncü taraf repo; MCP server'ları (`hana-mcp-server`, `@mariodefe/sap-datasphere-mcp`, bw-automation-studio vb.) npx üzerinden çalışma anında çekiliyor. HANA/Datasphere/BW credential'larını bu plugin'lerin konfigürasyonuna girmeden önce `docs/contributor-guide/mcp-manual-connections.md` kılavuzunu ve repodaki `sap-dependency-security` plugin'inin tedarik zinciri/lockfile sertleştirme kontrollerini uygula.
- Aynı işlevi gören birden fazla plugin/MCP paralel kurulu olabilir (bkz. sap-datasphere çakışması yukarıda) — ikisini de aktif bırakmadan önce hangisinin canlı bağlandığını doğrula, körlemesine kapatma.
- `bw-automation-studio` MCP, `%LOCALAPPDATA%\BWAutomationStudio` deploy edilmediği için bağlanmıyor (bozuk değil, kurulum eksik); BW query skillerinin kendisi MCP olmadan da çalışıyor.

## Benzerleri
- `datasphere@sap-datasphere-cowork` marketplace plugin'i — Envanter'de zaten kurulu, `sap-datasphere` MCP server adını bu repodaki plugin ile paylaşıyor (yukarıdaki çakışmaya bkz.).
- `sap-cds-mcp@claude-plugins-official` — sap-cap-capire plugin'inin CAP/CDS MCP işlevine resmi (Claude official marketplace) alternatif, Envanter'de kurulu.
- `hana-cli@claude-plugins-official` — sap-hana-cli plugin'inin HANA CLI MCP işlevine resmi alternatif, Envanter'de kurulu ama kapalı.

([[kaynaklar/2026-10-08-sap-skills-claude-plugins]])
