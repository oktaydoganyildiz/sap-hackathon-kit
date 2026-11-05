---
tur: kaynak
alan: datasphere
tarih: 2026-10-10
guven: topluluk
kaynak: https://github.com/lemaiwo/btp-sap-odata-to-mcp-server
gozden_gecir: 2027-04-10
---

# lemaiwo/btp-sap-odata-to-mcp-server

https://github.com/lemaiwo/btp-sap-odata-to-mcp-server

Yazı türü: arac

BTP Cloud Foundry üzerinde çalışan Node.js/TypeScript bir MCP server; SAP S/4HANA veya ECC sistemindeki OData servislerini dinamik olarak MCP tool'larına çeviriyor. Yüzlerce entity için ayrı tool üretmek yerine 3 seviyeli progresif keşif mimarisi kullanıyor: Seviye 1 `discover-sap-data` (hafif servis/entity arama), Seviye 2 `get-entity-metadata` (seçilen entity için tam şema), Seviye 3 `execute-sap-operation` (read/create/update/delete CRUD). Bu sayede LLM context'ine 200+ tool yerine sadece 3 tool düşüyor, token tüketimi azalıyor. Kimlik doğrulama BTP Destination/Connectivity/XSUAA servisleri üzerinden yapılıyor, Principal Propagation ve OAuth2 destekleniyor. MCP protokol sürümü 2025-06-18, Streamable HTTP ve stdio transport destekleniyor, session yönetimi ve DNS rebinding koruması mevcut. MIT lisanslı, 136 star, son push 2026-05-22. Doğal dil → OData sorgu çevirisi örnekleri ("Show me 10 banks" → $top=10 gibi) README'de detaylı anlatılmış.

## Beslediği sayfalar
- [[araclar/btp-sap-odata-to-mcp-server]]
