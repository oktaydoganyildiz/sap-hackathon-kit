---
tur: kaynak
alan: ai
tarih: 2026-10-09
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/from-sap-rap-amp-odata-to-ai-powered-dashboards-with-joule-desktop-and-mcp/ba-p/14491244
gozden_gecir: 2027-04-09
---

# From SAP RAP & OData to AI-Powered Dashboards with Joule Desktop and MCP

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/from-sap-rap-amp-odata-to-ai-powered-dashboards-with-joule-desktop-and-mcp/ba-p/14491244

Yazı türü: arac

Özet:
- Joule Desktop'ı özel bir MCP server üzerinden SAP BTP'de barındırılan RAP/OData V4 servisine bağlayan uçtan uca bir mimari gösteriliyor (basit Fruit Management örneği).
- Mimari zinciri: Joule Desktop → MCP Server → BTP Destination → OData V4 → RAP CDS/Behavior Definition.
- MCP server, topluluk projesi github.com/lemaiwo/btp-sap-odata-to-mcp-server temel alınarak özelleştiriliyor ve Cloud Foundry'ye deploy ediliyor.
- MCP server üç araç (tool) sunuyor: servis keşfi, entity retrieval, business-data sorgu/operasyon.
- Kimlik doğrulama/yetkilendirme zinciri açık: Joule → MCP Connector → MCP Server → Authentication → BTP Destination → OData → Authorization → Business Data; yazı MCP'nin SAP'nin mevcut güvenlik modelinin yerine geçmediğini, sadece arayüz sağladığını vurguluyor.
- Doğal dil sorgusu ("Show me all the fruits") adım adım izleniyor: NL yorumlama → tool discovery → MCP invocation → auth → OData GET isteği → sonuç → Joule'un bu veriyle dashboard üretmesi.
- Ön koşullar: Joule Desktop (Extensions/Connectors erişimi), BTP subaccount + ABAP ortamı + Destination service + Cloud Foundry, Eclipse ADT, temel RAP bilgisi (CDS view, behavior definition, service binding).

## Beslediği sayfalar
- [[araclar/joule-desktop-mcp-odata-connector]]
