---
tur: kaynak
alan: ai
tarih: 2026-10-26
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/joule-a2a-mcp-gateway-to-s-4hana-with-principal-propagation/ba-p/14508428
gozden_gecir: 2027-04-26
---

# Joule A2A: MCP Gateway to S/4HANA with Principal Propagation

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/joule-a2a-mcp-gateway-to-s-4hana-with-principal-propagation/ba-p/14508428

Yazı türü: tarif

Özet:
- Önceki yazıda S/4HANA'ya doğrudan API-API bağlanan custom A2A agent örneği, bu yazıda Integration Suite'in MCP Gateway'i (Integration Cell) üzerinden geçecek şekilde genişletiliyor.
- Amaç: Joule'dan gelen gerçek kullanıcı kimliğini (customer-managed Joule → A2A agent → MCP Gateway → S/4HANA) principal propagation ile sonuna kadar korumak, ayrıca API Management'ın governance/rate limiting/IP filtering kontrollerinden yararlanmak.
- Trust kurulumu bu kez Integration Suite subaccount'ının destination service sertifikası üzerinden yapılıyor (önceki yazıdaki agent subaccount'ından farklı).
- S/4'e giden OAuth2SAMLBearerAssertion destination'ında iki kritik ek alan var: `x_user_token.jwks_uri` (IAS doğrulaması, yoksa sessizce teknik kullanıcıya düşer) ve `IntegrationCell.Include=true` (yoksa destination MCP Server wizard'ında görünmez).
- MCP Server artifact'ı OpenAPI/EDMX'ten (S/4 Business Partner servisi) kuruluyor, az sayıda tool (ör. get_A_BusinessPartner) seçiliyor.
- Authentication policy varsayılan XSUAA yerine External OAuth (OIDC) ile IAS tenant'a yönlendiriliyor; Audience alanının Joule'un app-to-app exchange sonrası ürettiği Custom Agent App client ID'si olması gerektiği vurgulanıyor (yanlış ayar 401 invalidToken verir).
- Authorization policy'de IAS token'ında scope claim'i olmadığı için `ias_apis` claim'i scope key olarak kullanılıyor (yanlış ayar 403 forbidden verir).
- curl ile izole test akışı (initialize/notifications/initialized/tools/call) ve gerçekçi test token'ı elde etme yöntemleri (app-to-app exchange reprodüksiyonu veya log'dan JWT yakalama) anlatılıyor.
- Agent tarafı kod değişikliği küçük: S/4'e doğrudan bağlanan kısım yerine MCP client ile gateway'e kullanıcı JWT'si Bearer olarak iletiliyor; agent'ın kendi backend credential'ı kalmıyor.
- Monitor → Monitor Message Processing altında çağrının gerçekten MCP Gateway üzerinden geçtiği doğrulanabiliyor.

## Beslediği sayfalar
- [[ai/baglanti/joule-a2a-mcp-gateway-s4-principal-propagation]]
