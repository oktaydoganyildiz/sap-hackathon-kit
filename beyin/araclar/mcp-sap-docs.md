---
tur: arac
alan: ai
tarih: 2026-10-10
guven: topluluk
gozden_gecir: 2027-04-10
---

# mcp-sap-docs (SAP Docs MCP Server)

## Ne yapar
Hibrit arama (BM25 + semantik embedding, Reciprocal Rank Fusion ile birleştirilmiş) sunan bir MCP server: yerel git-klonlanmış SAP doküman kümeleri (ABAP Keyword Documentation — standard/cloud, abap-cheat-sheets, RAP showcase/openSAP örnekleri, Clean ABAP style guide, BTP Cloud Platform, SAP AI Core/Launchpad, UI5, CAP, Cloud SDK, Terraform Provider for BTP, Architecture Center, wdi5) üzerinde `search`/`fetch` tool'ları ile çalışır. İsteğe bağlı olarak SAP Help Portal, SAP Community ve Software Heroes'a canlı sorgu da atabilir (`includeOnline=true`).

İki varyant paylaşılan kod tabanından `.mcp-variant`/`MCP_VARIANT` ile ayrılıyor:
- `sap-docs`: geniş kapsam + `sap_discovery_center_search`, `sap_discovery_center_service`, `ui5_version_diff`.
- `abap`: ABAP odaklı + `abap_lint` (abaplint ile statik kod analizi).

Her iki varyantta ortak: `search`, `fetch`, `abap_feature_matrix` (7.40–LATEST sürüm özellik desteği), `sap_community_search` (Khoros LiQL API), `sap_search_objects` ve `sap_get_object_details` (SAP/abap-atc-cr-cv-s4hc üzerinden released object'lerin clean core seviyesi A/B/C/D ve successor object bilgisi — clean core uyumluluk keşfi için kullanışlı).

Public hosted streamable HTTP endpoint: `https://mcp-sap-docs.marianzeis.de/mcp` (sap-docs) ve `https://mcp-abap.marianzeis.de/mcp` (abap). Kimlik/API key gerektirmiyor, read-only. Offline-only mod ve Docker (`--network none` ile air-gapped) desteği var.

## Bende durumu
kurulu — ENVANTER'de `mcp-sap-docs` server'ı `~/.claude.json` (kullanıcı seviyesi) altında zaten aktif tanımlı, komut tam olarak bu yazıdaki hosted endpoint (`https://mcp-sap-docs.marianzeis.de/mcp`). Ayrıca kapsadığı bazı alanlar (ABAP, BTP, AI Core) için envanterde `sap-skills` marketplace'inden ayrı skill'ler de var (örn. `sap-abap`, `sap-ai-core`, `sap-btp-cloud-platform`) — bunlar skill, bu ise canlı doküman arama MCP'si; birbirini tamamlıyor, çakışmıyor.

## Agentic BI'a katkısı
Doğrudan BI/analitik odaklı değil; genel SAP geliştirici dokümantasyonuna (özellikle ABAP/CAP/BTP/UI5) erişim sağlıyor. Agentic BI akışlarında kod önerilerini resmi dokümana dayandırmak, clean core uyumluluğunu (`sap_search_objects`/`sap_get_object_details`) kontrol etmek ve hata/arıza durumlarında SAP Community'yi canlı taramak için faydalı. Ancak Oktay'ın notuna göre dönen bağlam sınırlı kalabiliyor — Datasphere/BW4/SAC gibi analitik derinlik gerektiren konularda envanterdeki alan-spesifik MCP'lerle (sap-datasphere, sap-bw-query, sac-mcp) birlikte kullanılmalı, tek başına yeterli olmayabilir.

## Kurulum
```json
{"mcpServers": {"sap-docs": {"type": "http", "url": "https://mcp-sap-docs.marianzeis.de/mcp"}}}
```
(ABAP varyantı için `url`'i `https://mcp-abap.marianzeis.de/mcp` yap.)

## Dikkat
- Apache-2.0 lisans, aktif bakım (son push 2026-09-23, 238 yıldız) — sağlıklı proje.
- Public, kimlik bilgisi istemiyor; ancak üçüncü taraf barındırılan bir servis olduğu için arama sorgularında hassas/müşteriye özel proje bilgisi paylaşılmamalı (sorgu metni harici sunucuya gidiyor).
- Offline-only mod ve air-gapped Docker (`--network none`) seçeneği mevcut; kurumsal/izole ortamlarda hosted endpoint yerine bu tercih edilebilir.
- `sap-docs` ve `abap` varyantları ayrı port/endpoint kullanıyor; doğru varyantı (ABAP odaklı iş için `abap`) seçmek arama kalitesini ve `abap_lint` erişimini etkiliyor.
- Bağlam derinliği sınırlı olabilir (Oktay notu) — kritik kararlarda `sap_community_search` gibi ek araçlarla veya resmi SAP Help ile çapraz doğrulama öner.

## Benzerleri
Envanterdeki alan-spesifik SAP MCP/skill'leri: sap-datasphere MCP (Datasphere), sap-bw-query/BW Automation Studio (BW4), sac-mcp (SAC), hana-mcp-server (HANA), sap-skills marketplace'teki ABAP/BTP/AI Core skill'leri. Bu araç bunların yerine değil, genel doküman arama katmanı olarak yanlarında kullanılıyor.

([[kaynaklar/2026-10-10-mcp-sap-docs]])
