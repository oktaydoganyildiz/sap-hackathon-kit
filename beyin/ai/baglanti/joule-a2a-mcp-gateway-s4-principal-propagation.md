---
tur: tarif
alan: ai
kategori: baglanti
urun_surumu: "Integration Suite Enhanced Edition; S/4HANA Public Cloud"
tarih: 2026-10-26
guven: resmi
gozden_gecir: 2027-04-26
---

# Joule A2A agent'ını Integration Suite MCP Gateway üzerinden S/4HANA'ya principal propagation ile bağlama

## Use case
Customer-managed Joule'den gelen bir A2A agent'ının, S/4HANA Public Cloud'a doğrudan API-API bağlanmak yerine Integration Suite'in MCP Gateway'i üzerinden, gerçek kullanıcı kimliğini (principal propagation) koruyarak erişmesi gerektiğinde kullanılır; aynı zamanda governance, rate limiting, IP filtering gibi API Management kontrollerini de devreye sokar.

## Varyantlar

### Integration Suite MCP Gateway + OAuth2SAMLBearerAssertion + External OAuth (IAS)

Adımlar:

1. **Trust kurulumu (S/4 tarafı)**: Integration Suite subaccount'ında Connectivity → Destinations → Download Trust ile destination service'in self-signed sertifikasını (.pem, subject `cfapps.<region>.hana.ondemand.com/<subaccount-id>`, OU=CP Destination Configuration) indir. S/4'te SAP_COM_0008 (Business Partner) için communication user/system/arrangement kur, bu sertifikayı communication system'in OAuth 2.0 Identity Provider alanına yükle, CN'ini Provider Name'e kopyala.
   - Tuzak: yanlış/eksik trust → "There is no trust between entities … in client 100" hatası; mesaj hangi subaccount ID'sinin görüldüğünü söyler, teşhis kolaylaşır.

2. **S/4HANA SAML Bearer destination'ı** Integration Suite subaccount'ında oluştur (OAuth2SAMLBearerAssertion):
```
Name=S4_MCP_GATEWAY_TEST
Type=HTTP
ProxyType=Internet
Authentication=OAuth2SAMLBearerAssertion
URL=https://my3xxxxx-api.s4hana.cloud.sap
Audience=https://my3xxxxx.s4hana.cloud.sap
Token Service URL=https://my3xxxxx-api.s4hana.cloud.sap/sap/bc/sec/oauth2/token
Client Key / Token Service User=<comm user>
authnContextClassRef=urn:oasis:names:tc:SAML:2.0:ac:classes:X509
userIdSource=mail
nameIdFormat=urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress

# ek özellikler — ikisi de zorunlu
x_user_token.jwks_uri=https://<ias-tenant>/oauth2/certs
IntegrationCell.Include=true
```
   - Tuzak: `x_user_token.jwks_uri` eksikse destination sessizce teknik kullanıcı assertion'ına düşer, propagation kırılır (hata vermez, yanlış kullanıcı propagate olur).
   - Tuzak: `IntegrationCell.Include=true` yoksa destination MCP Server wizard'ının dropdown'ında hiç görünmez.

3. **MCP Server artifact'ı** oluştur: Design → Integrations and APIs → yeni integration package → MCP Server artifact ekle. Kaynak tipi "HTTP Endpoint with OpenAPI Specification" seç, S4_MCP_GATEWAY_TEST destination'ını relative URL `/sap/opu/odata/sap/API_BUSINESS_PARTNER` ile göster, MCP Path ver (ör. `/s4_bp_mcp`), runtime profile Integration Cell. AI spec generation'ı atla; MCP Configuration → Source → Edit API Specification'dan OpenAPI/EDMX'i (SAP Business Accelerator Hub'dan veya canlı `$metadata`'dan) import et. Tools sekmesinde az sayıda, iyi tanımlı operation seç (ör. `GET A_BusinessPartner` → `get_A_BusinessPartner`) — az ve net tool, model routing'ini iyileştirir.

4. **Policies → Authentication** (zorunlu): varsayılan, Integration Suite subaccount'ının kendi XSUAA/IdP'sine karşı doğrular — bu Joule Work Desktop connector gibi senaryolar için yeterli. A2A agent'ın Joule'dan forward ettiği IAS token'ı için bunu **External OAuth (OIDC)** olarak değiştirip IAS tenant'a yönlendirmek gerekir:

| Alan | Değer |
|---|---|
| Well-Known URL | `https://<ias-tenant>/.well-known/openid-configuration` |
| Audience | client'in gerçekte gönderdiği token'ın `aud`'u (bkz tuzak) |
| ClientID Key | `${authn.oidc.jwt.azp}` |
| UserInfo Key | `${authn.oidc.jwt.mail}` |

   - Tuzak: Audience, Joule'un app-to-app exchange'i sonrası token'ın `aud`'udur — yani **Custom Agent App'in Client ID'si**, test için kullandığın login app'in ID'si değil (IAS admin → Applications → Custom Agent App → Client ID; agent'ın zaten `IAS_AUDIENCE` olarak doğruladığı değerle aynı). Yanlış audience → gerçek Joule token'ı bile `401 invalidToken` ile reddedilir. Debug için audience boş bırakılabilir (doğrulama atlanır) veya virgülle çoklu değer verilebilir.

5. **Policies → Authorization** (zorunlu): IAS token'ında XSUAA'daki gibi `scope` claim'i YOKTUR — IAS yalnız kimlik söyler, yetki değil; yetki backend'de (S/4 rolleri) enforce edilir. Joule'un app-to-app exchange'inden geçen token `ias_apis` claim'i taşır (exposed API listesi, ör. `["a2a_custom_agent_app_api"]`). Authorization policy'yi şu şekilde ayarla:

| Alan | Değer |
|---|---|
| Authorization Type | OAuth Scope OR Developer Key |
| Scope Key | `ias_apis` |
| Scope | `a2a_custom_agent_app_api` (kendi exposed API adın) |

   - Tuzak: policy hâlâ `scope` claim'ini kontrol ediyorsa, authentication geçer ama her çağrı `403 forbidden` ("User doesn't have the authorization to perform this operation") ile döner.

6. **Deploy MCP Server** → Integration Cell runtime'a; Runtime Status STARTED olunca MCP URL yayındadır.

7. **curl ile izole test** (agent koduna dokunmadan): initialize (yanıt header'ından `mcp-session-id` al) → notifications/initialized → tools/call. Hata ayrımı: `401 invalidToken` = authentication (issuer/audience), `403 forbidden` = authorization (scope/ias_apis), gerçek OData satırları = başarı.
```bash
SID=$(curl -s -o /dev/null -w '%header{mcp-session-id}' -X POST "$MCP_URL" \
  -H "Authorization: Bearer $USER_JWT" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"curl","version":"1.0"}}}')

curl -s -o /dev/null -X POST "$MCP_URL" -H "Authorization: Bearer $USER_JWT" \
  -H "Accept: application/json, text/event-stream" -H "mcp-session-id: $SID" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'

curl -s -X POST "$MCP_URL" -H "Authorization: Bearer $USER_JWT" \
  -H "Accept: application/json, text/event-stream" -H "mcp-session-id: $SID" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_A_BusinessPartner","arguments":{"top":3,"select":["BusinessPartner","BusinessPartnerName"]}}}'
```
   - Test token elde etmek için düz IAS password grant YETERLİ DEĞİL (login app'e audience'lı, `ias_apis` yok → hem audience hem authorization başarısız olur). İki yol: (a) app-to-app exchange'i kendin reprodüksiyon et (jwt-bearer grant, proxy app client credentials + proxy-to-target dependency), (b) agent'ta forward edilen gerçek Authorization header'ı bir defalık log'layıp JWT'yi oradan kopyala.

8. **Agent tarafı kod değişikliği** (Python, LangGraph): önceden destination service'e/S/4'e doğrudan bağlanan kısım, küçük bir MCP client ile değiştirilir. Agent, Joule'dan aldığı kullanıcı JWT'sini olduğu gibi MCP Gateway'e `Authorization: Bearer <user_jwt>` olarak iletir; agent'ın kendi backend credential'ı (client secret, destination binding) gerekmez.
```python
# mcp_client.py (kısaltılmış)
def call_business_partner_api(user_jwt, top=10, select=None, ...):
    session_id = _open_session(user_jwt)  # initialize -> mcp-session-id
    r = requests.post(
        MCP_URL,
        headers={
            "Authorization": f"Bearer {user_jwt}",
            "Accept": "application/json, text/event-stream",
            "mcp-session-id": session_id,
        },
        json={
            "jsonrpc": "2.0", "id": 2, "method": "tools/call",
            "params": {
                "name": "get_A_BusinessPartner",
                "arguments": {"top": top, "select": [...]},  # OData options `$` olmadan, select dizi
            },
        },
    )
    # sonuç result.content[0].text içinde JSON string olarak döner
```
```python
# agent_executor.py — token doğrudan A2A isteğinin Authorization header'ından alınır
auth = context._call_context.state.get("headers", {}).get("authorization", "")
user_jwt = auth[len("bearer "):] if auth.lower().startswith("bearer ") else None
```
   - Tuzak: handshake session bazlıdır — `initialize`'dan sonraki her istekte `mcp-session-id` header'ını echo etmek gerekir.
   - Tuzak: üretilen tool şeması OData opsiyonlarını `$` olmadan (`top`, `select`, `filter`, `orderby`) bekler ve `select`/`expand`/`orderby` dizi (array) olmalıdır; virgülle ayrılmış string göndermek şema doğrulamasını başarısız kılar.

9. **Doğrulama**: Monitor → Integrations and APIs → Monitor Message Processing (Integration Cell runtime seçili) altında her prompt, tipi "MCP Server" olan bir `BusinessPartnerMCP` girdisi (status Completed) olarak görünür — çağrının gerçekten gateway üzerinden geçtiğinin kanıtıdır.

Ne zaman seçilir: Birden çok API'yi tek tek agent'a bağlamak yerine merkezi bir MCP katmanında governance/rate limiting/IP filtering ile yönetmek istendiğinde; endorsed mimariyle sınırlı API policy'si olan kurumlarda; önceki (destination-tabanlı doğrudan) yaklaşımın ölçeklenmediği durumlarda.

Kaynak: ([[kaynaklar/2026-10-26-joule-a2a-mcp-gateway-s4-principal-propagation]])

## Tuzaklar
- Yanlış subaccount'ın trust sertifikası yüklenmesi → "There is no trust between entities … in client 100" (hata mesajı hangi subaccount ID'sinin görüldüğünü söyler, teşhis kolaylaşır).
- `x_user_token.jwks_uri` destination'da eksikse propagation sessizce teknik kullanıcıya düşer — hata vermez, yanlış davranış sonucu doğurur.
- `IntegrationCell.Include=true` eksikse destination MCP Server wizard dropdown'ında görünmez.
- Authentication policy'de Audience yanlış uygulamaya ayarlanmışsa (login app yerine Custom Agent App client ID olmalı) → gerçek Joule token'ı bile 401 invalidToken.
- Authorization policy'de hâlâ `scope` claim kontrolü varsa (IAS token'ında scope yok) → 403 forbidden, authentication geçmesine rağmen.
- Düz IAS password grant ile alınan test token'ı hem audience hem `ias_apis` açısından gerçekçi değildir, gerçek davranışı test etmez.
- MCP tool şemasında OData parametreleri `$` önekisiz ve select/expand/orderby dizi (array) formatında olmalı; string geçirmek şema hatası verir.

## Cevapladığı sorular
- Joule A2A agent'ını Integration Suite MCP Gateway üzerinden S/4HANA'ya principal propagation ile nasıl bağlarım?
- IAS token'ında scope claim'i yokken MCP Gateway'de authorization nasıl yapılır?
- MCP Gateway destination'ında principal propagation neden sessizce teknik kullanıcıya düşer?
- MCP Server wizard'ında destination neden dropdown'da görünmüyor?

## İlgili
- [[ai/baglanti/joule-cli-login-sorunlari|Joule CLI login sorunları ve IAS client credentials kurulumu]]
- [[araclar/joule-pro-code-a2a|Joule Pro-Code Extensibility + A2A]]
- [[araclar/joule-a2a-agent-toolkit|Joule A2A Agent Toolkit (Claude Code plugin)]]
