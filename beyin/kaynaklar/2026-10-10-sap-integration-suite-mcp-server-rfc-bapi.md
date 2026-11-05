---
tur: kaynak
alan: btp
tarih: 2026-10-10
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/rfc-bapis-meet-ai-agents-why-sap-integration-suite-mcp-server-matters/ba-p/14450274
gozden_gecir: 2027-04-10
---

# RFC/BAPIs Meet AI Agents: Why SAP Integration Suite MCP Server Matters

https://community.sap.com/t5/technology-blog-posts-by-sap/rfc-bapis-meet-ai-agents-why-sap-integration-suite-mcp-server-matters/ba-p/14450274

Yazı türü: arac

- SAP Integration Suite artık MCP Server artifact'i destekliyor; API Artifacts, HTTP Endpoints ve RFC'leri MCP tool olarak expose edebiliyor.
- RFC/BAPI desteği, ECC/S4HANA on-premise sistemlerdeki mevcut iş mantığını (BAPI'ler) yeniden yazmadan ajan ekosistemine açma imkanı veriyor.
- SAP'nin resmi yönü hâlâ API/OData bazlı modernizasyon; RFC expose etmek yeni entegrasyon kurmak için önerilmiyor, sadece modernizasyon köprüsü olarak görülüyor.
- Expose edilen kapasiteler Integration Suite governance'ından (authentication, quota/rate limiting, spike arrest, IP filtering) faydalanıyor.
- MCP Server, Developer Portal üzerinden API Product olarak publish edilebiliyor; ajan geliştiricileri subscribe olup API key alıyor.
- Demo akışı: Cloud Connector → BTP Destination → MCP Server artifact → RFC/BAPI tool ekleme → policy ayarı → deploy → Developer Portal'da publish → Cline (VS Code) ile tüketim.
- Ajan, kullanıcı niyetine göre birden fazla BAPI'yi dinamik olarak orkestre edebiliyor (önceden her senaryo için ayrı custom interface gerekirdi).
- Demo'da sadece read-oriented (GET) RFC'ler kullanılmış; güvenlik için önerilen bir sınırlama.
- MCP transaction'ları Integration Suite monitoring menüsünden izlenebiliyor.

## Beslediği sayfalar
- [[araclar/sap-integration-suite-mcp-server]]
- [[btp/baglanti/rfc-bapi-mcp-server-expose]]
