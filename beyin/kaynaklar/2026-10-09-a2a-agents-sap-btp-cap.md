---
tur: kaynak
alan: btp
tarih: 2026-10-09
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/a2a-agents-on-sap-btp-wiring-the-agent-to-agent-protocol-into-cap/ba-p/14378591
gozden_gecir: 2027-04-09
---

# A2A Agents on SAP BTP: Wiring the Agent-to-Agent Protocol into CAP

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/a2a-agents-on-sap-btp-wiring-the-agent-to-agent-protocol-into-cap/ba-p/14378591

Yazı türü: tarif

Özet:
- Google'ın A2A (Agent-to-Agent) protokolünü CAP uygulamasına ayrı bir sidecar değil, birinci sınıf parça olarak monte eden mimari gösteriliyor (TypeScript + @a2a-js/sdk).
- CAP'in Express instance'ına cds.on("bootstrap") hook'u ile A2A JSON-RPC (Joule'nin konuştuğu transport) ve discovery endpoint'i (/.well-known/agent.json) ekleniyor; tek deployment, tek HANA binding, tek XSUAA instance.
- Task/telemetry kalıcılığı düz CDS şemasıyla çözülüyor; managed aspect audit alanlarını otomatik veriyor; telemetry entity read-only CAP servisi olarak OData üzerinden izlenebiliyor.
- A2A SDK'nın TaskStore arayüzü HanaTaskStore ile CQL SELECT/UPSERT tek satırlık metotlara indirgeniyor (connection pool/ORM yönetimi yok).
- BaseAgentExecutor soyut sınıfı A2A task lifecycle'ını (working/input-required/completed/failed), LangGraph interrupt/checkpoint akışını, timeout ve concurrency guard'ı tek yerde yönetiyor; somut ajanlar sadece mesaj metinlerini override ediyor.
- LLM erişimi BTP Destination Service + sap-ai-sdk/orchestration ile; API key kod/env'de tutulmuyor, Orchestration API model seçimi/routing/cost tracking sağlıyor.
- MCP araç keşfi agent-definition'a mcpServers + destinationName eklenerek yapılıyor; her tool call'da principal propagation destination'ı ile kullanıcı JWT'si bazlı yetkilendirme uygulanabiliyor (fetch override + AsyncLocalStorage ile JWT taşınıyor).
- Yazar Python yerine CAP/TypeScript seçiminin gerekçesini HANA/XSUAA/Destination entegrasyonunun "zaten çözülmüş" olmasına bağlıyor; yazı serinin ilk parçası, tam proje şablonu henüz yayınlanmadı.

## Beslediği sayfalar
- [[araclar/a2a-cap-agent-sablonu]]
- [[btp/baglanti/mcp-arac-kesfi-destination-uzerinden]]
