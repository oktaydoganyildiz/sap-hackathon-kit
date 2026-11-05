---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-19
guven: topluluk
gozden_gecir: 2027-04-19
---

# Integration Suite MCP Server + CAP API (OAuth2JWTBearer Principal Propagation)

## Ne yapar
SAP Integration Suite içinde oluşturulan bir MCP Server artifact'inin, CAP (Cloud Application Programming) tabanlı API servislerine **OAuth2JWTBearer Assertion** (Principal Propagation) ile erişmesini sağlıyor. Amaç: AI ajanının CAP API'yi paylaşılan bir teknik/API kullanıcısı yerine, isteği yapan **gerçek kullanıcının kimliğiyle** çağırması — böylece CAP tarafındaki role/authorization kontrolleri (örn. yalnızca 'Admin' policy'sine sahip kullanıcı admin servisini çağırabilir) ajan üzerinden de korunur. Kimlik doğrulama sağlayıcısı olarak MCP server'da **XSUAA yerine SAP Cloud Identity Services (IAS)** kullanılıyor, çünkü hedef CAP API da IAS ile korunuyor ve XSUAA'dan IAS-korumalı kaynağa direkt geçiş mümkün değil.

Uçtan uca akış: Agent (Claude/Copilot/herhangi bir AI agent) → Integration Suite MCP Server (IAS ile authenticate) → BTP Destination Service (OAuth2JWTBearer) → CAP Service API'ler (authenticate olan kullanıcı adına çalıştırılır).

## Bende durumu
yeni — Envanterde bu spesifik OAuth2JWTBearer + IAS principal propagation kurulumunu otomatikleştiren bir araç yok. İlgili parçalar zaten kurulu: `sap-btp-integration-suite` (sap-skills, aktif) MCP Server/Integration Suite geliştirmede danışman olarak kullanılabilir; `sap-btp-cloud-identity-services` (sap-skills, aktif) IAS dependency/consumer-provider konfigürasyonunda yardımcı olur; `cds-mcp` (@cap-js/mcp-server, claude-plugins-official, aktif) CAP projesi geliştirirken (cds add ams/hana/mta adımlarında) kullanılabilir. [[araclar/sap-integration-suite-mcp-server|SAP Integration Suite MCP Server]] sayfası aynı platform özelliğini RFC/BAPI expose açısından anlatıyor; bu sayfa ise aynı özelliğin CAP API + OAuth2JWTBearer güvenlik deseni açısından tamamlayıcısıdır.

## Agentic BI'a katkısı
Agentic BI senaryolarında ajanın CAP tabanlı bir iş/veri servisine (örn. SAC Planning backend'i, özel bir CAP analitik API'si) erişirken, kullanıcı bazlı yetkilendirmeyi (row-level/policy bazlı) koruması kritik. Bu desen sayesinde ajan, kullanıcı adına çalışır — kullanıcının görmeye yetkili olmadığı veriyi göremez, oluşturduğu/değiştirdiği kayıtlarda `createdBy` gerçek kullanıcı olur. Bu, paylaşılan API/teknik kullanıcıyla çalışan ajan mimarilerine kıyasla governance ve audit açısından önemli bir fark yaratır; agentic BI'da veri güvenliği ve izlenebilirlik için referans alınabilecek bir mimari.

## Kurulum
Tek komutla kurulamaz; temel adım zinciri:
1. CAP projesine ekle: `cds add ams`, `cds add hana`, `cds add mta`; `cds build --for ams`.
2. MTA dosyasına IAS servis kaynağı ekle, `grant-types` listesine `urn:ietf:params:oauth:grant-type:jwt-bearer` dahil et; `mbt build && cf deploy`.
3. SAP Cloud Identity Services'te ayrı bir consumer instance (Integration Suite MCP Server için, `public-client: true`) ve provider (CAP app) arasında **dependency** tanımla (Application + provided-apis adı ile).
4. BTP Destination oluştur: Authentication=OAuth2JWTBearer, Client ID/Secret=consumer, Token Service URL=IAS `/oauth2/token`, Additional Properties: `x_user_token.jwks_uri` ve `tokenService.body.resource=urn:sap:identity:application:provider:name:<dependency>`.
5. Integration Suite'te MCP Server artifact'i oluştur, metadata'dan (OData→OpenAPI) tool'ları ekle, Authentication=SAP IAS (Well-known URL, ClientID Key=`${authn.oidc.jwt.azp}`, User Info Key=`${authn.oidc.jwt.email}`), deploy et.
6. Developer Hub'da Product + Subscription oluştur (consumer client ID ile), rol koleksiyonuna `API.Invoke` ekleyip kullanıcıya ata.

## Dikkat
- Topluluk kaynağı (resmi SAP dokümantasyonu değil); blog yazarının kendi demo ortamında doğruladığı adımlar, sürüm/ekran değişikliklerine karşı güncelliği kontrol edilmeli.
- **Önemli kısıt:** BTP destination konfigürasyonu consumer client ID'yi sabitlediği için bu yaklaşım pratikte **tek bir client ID**'nin MCP server'a erişimine izin verir — çoklu ajan/consumer senaryosunda ek tasarım gerekir.
- MCP server authentication'ı zorunlu olarak IAS olmalı; XSUAA ile IAS-korumalı CAP API'ye doğrudan erişim mümkün değil.
- Integration Suite MCP Server başına en fazla 30 tool sınırı var (SAP Help referansı).
- OAuth2SAMLBearerAssertion alternatifi var ama bu akış tipik olarak Cloud Foundry uygulamaları arası iletişim için tasarlanmış, bu senaryoya tam uymuyor.
- Client secret/credential'lar BTP Destination ve IAS service key'lerinde tutuluyor; ajan tarafına (Claude/Copilot/VS Code) yalnızca OAuth yetkilendirme akışı (callback URL) veriliyor olsa da, destination/IAS tarafı erişim bilgisi yönetimi dikkat ister.

## Benzerleri
- [[araclar/sap-integration-suite-mcp-server|SAP Integration Suite MCP Server (RFC/BAPI expose)]] — aynı platform özelliği, farklı use case (RFC/BAPI).
- [[araclar/sap-integration-suite-mcp-gateway|SAP Integration Suite MCP Gateway (composed API)]] — birden fazla backend API'yi tek MCP server'da birleştirme.
- `cds-mcp` (@cap-js/mcp-server, kurulu) — CAP proje geliştirme sırasında kullanılan yerel MCP server.

([[kaynaklar/2026-10-19-integration-suite-mcp-cap-oauth2jwtbearer]])
