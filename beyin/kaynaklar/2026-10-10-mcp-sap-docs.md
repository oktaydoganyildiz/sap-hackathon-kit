---
tur: kaynak
alan: ai
tarih: 2026-10-10
guven: topluluk
kaynak: https://github.com/marianfoo/mcp-sap-docs
gozden_gecir: 2027-04-10
---

# marianfoo/mcp-sap-docs

https://github.com/marianfoo/mcp-sap-docs

Yazı türü: arac

Açık kaynak (Apache-2.0), topluluk destekli bir MCP server: Claude/Cursor/ChatGPT gibi ajanlara SAP dokümantasyonuna (ABAP, CAP, UI5, BTP, Cloud SDK, SAP AI Core, Terraform, Architecture Center, wdi5...) hibrit (BM25 + semantik embedding, RRF ile birleştirilmiş) arama ve tam içerik çekme erişimi sağlıyor. Yerel git-klonlanmış doküman indeksinin yanında isteğe bağlı canlı SAP Help, SAP Community ve Software Heroes sorguları da yapabiliyor.

İki varyant tek kod tabanından türetiliyor: `sap-docs` (geniş kapsam + Discovery Center araçları + ui5_version_diff) ve `abap` (ABAP'a odaklı + abap_lint statik analiz). Public hosted streamable HTTP endpoint var, kimlik doğrulama/API key gerektirmiyor; air-gapped/offline Docker kurulumu da destekleniyor.

Ek araçlar: abap_feature_matrix (ABAP sürümleri arası özellik desteği), sap_community_search (Khoros LiQL API ile SAP Community araması), sap_search_objects / sap_get_object_details (SAP released objects + clean core uyumluluk seviyesi A/B/C/D ve successor object bilgisi).

Oktay'ın notuna göre bu araç dokümantasyon erişimi için faydalı ama dönen bağlam sınırlı/az kalabiliyor; derin analitik alan (Datasphere/BW4/SAC) sorguları için envanterdeki alan-spesifik MCP'lerle tamamlanmalı.

## Beslediği sayfalar
- [[araclar/mcp-sap-docs]]
