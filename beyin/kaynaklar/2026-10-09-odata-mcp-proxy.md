---
tur: kaynak
alan: btp
kategori: baglanti
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
kaynak: https://github.com/lemaiwo/odata-mcp-proxy
gozden_gecir: 2027-04-09
---

# lemaiwo/odata-mcp-proxy

https://github.com/lemaiwo/odata-mcp-proxy

Yazı türü: arac

config-driven bir MCP sunucusu; SAP Integration Suite (Cloud Integration) OData Admin API'lerini (iFlow'lar, message processing log'lar, data store, keystore, partner directory vb. — 32 entity set, 6 kategori) MCP tool'ları olarak dışa açıyor. BTP Destination Service üzerinden OAuth2 token yönetimini otomatik yapıyor, Cloud Foundry'de HTTP transport, Claude Desktop ile yerelde stdio transport destekliyor. npm paketi olarak tüketilip kendi api-config.json'ınla farklı OData/REST API'leri de (Products örneği gibi) bağlayabiliyorsun — yani CI'ye özel değil, genel bir OData→MCP proxy iskeleti. Dikkat çeken iki özellik: mcp-ui ile etkileşimli HTML görünümler (data kaynaklarını paralel çekip şablona gömme, sayfalama, $now/$monthsAgo gibi kapalı placeholder seti) ve "progressive tool discovery" — 100+ tool yerine search_operations/execute_operation adlı iki sabit meta-tool'a toplama (tool listesi sabit kalınca prompt cache bozulmuyor, MCP 2026-07-28 spesifikasyonuna referans veriliyor). MIT lisanslı, son push 2026-10-01, 32 yıldız.

## Beslediği sayfalar
- [[araclar/odata-mcp-proxy]]
