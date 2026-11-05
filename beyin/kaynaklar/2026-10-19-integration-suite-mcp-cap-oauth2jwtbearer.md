---
tur: kaynak
alan: ai
tarih: 2026-10-19
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/mcp-server-with-integration-suite-expose-cap-api-sci-via-oauth2jwtbearer/ba-p/14503174
gozden_gecir: 2027-04-19
---

# MCP Server with Integration Suite, expose CAP API (SCI) via OAuth2JWTBearer Principal Propagation

Link: https://community.sap.com/t5/technology-blog-posts-by-members/mcp-server-with-integration-suite-expose-cap-api-sci-via-oauth2jwtbearer/ba-p/14503174

Yazı türü: tarif

## Özet
- SAP Integration Suite'te oluşturulan bir MCP Server'ın, CAP tabanlı API servislerine OAuth2JWTBearer Principal Propagation ile güvenli eriştiği uçtan uca bir kurulum anlatılıyor.
- Amaç: API erişimini paylaşılan teknik kullanıcı yerine, her kullanıcının kendi IAS kimliği üzerinden yapmak — governance, traceability ve row-level yetkilendirme için.
- Akış: Agent (Claude/Copilot) → Integration Suite MCP Server (IAS ile authenticate) → BTP Destination (OAuth2JWTBearer) → CAP Service API (kullanıcı adına çalışır).
- Kritik kısıtlama: MCP server IAS (Cloud Identity Services) kullanmak zorunda; XSUAA ile IAS-korumalı CAP API'ye direkt erişim mümkün değil.
- Başka bir kısıtlama: BTP destination konfigürasyonu consumer client ID'yi sabitlediği için, bu yaklaşım pratikte tek bir client ID'nin MCP server'a erişimine izin veriyor.
- Adımlar: CAP projesine `cds add ams/hana/mta` ile IAS+jwt-bearer grant type ekleme, CF'ye deploy, IAS'ta consumer (MCP server) ve provider (CAP) uygulamaları arasında dependency tanımlama, BTP Destination'da OAuth2JWTBearer + tokenService.body.resource ayarı, Integration Suite'te MCP Server artifact'inde Authentication=IAS/OIDC konfigürasyonu, Developer Hub'da product+subscription oluşturma, rol koleksiyonu ile API.Invoke yetkisi verme.
- Test Postman üzerinden yapılmış; CAP tarafında oluşturulan kaydın `createdBy` alanı, principal propagation'ın gerçek kullanıcı kimliğiyle çalıştığını doğruluyor.

## Beslediği sayfalar
- [[araclar/integration-suite-mcp-cap-oauth2jwtbearer]]
