# 06 · MCP ve Integration Suite MCP Gateway

> **Tek cümle:** MCP, bir agent'ın dış dünyadaki araçları (tool) standart bir şekilde bulup çağırması için protokol; SAP Integration Suite'in MCP Gateway'i de S/4HANA gibi sistemlerin API'lerini güvenli, izlenen MCP tool'larına çeviren kapı.

---

## 1. Neden var?

Agent'ımız (`07-pro-code-agent.md`) LLM ile düşünür (`05-ai-core-genai-hub.md`), ama düşünmek yetmez: siparişi okuması, stoğu sorgulaması, bir kayıt açması gerekir. Bunlar SAP sistemlerinin API'lerinde durur.

MCP olmasaydı her API için agent'ın içine ayrı kod yazardık: ayrı URL, ayrı kimlik doğrulama, ayrı veri formatı. MCP ile her şey aynı kalıba girer: "Elinde hangi tool'lar var? Şunu şu parametreyle çalıştır."

**Benzetme:** MCP, aletler için **USB-C** gibi. Laptop'una hangi marka şarj aleti, monitör, disk takarsan tak, aynı girişten konuşur. Agent da hangi sisteme bağlanırsa bağlansın aynı dille tool çağırır.

---

## 2. A2A ile MCP (kısa hatırlatma)

Ayrıntılı karşılaştırma `01-a2a.md` bölüm 2'de. Kısaca: **A2A** bir agent'ın başka bir agent'a **iş devretmesi**, **MCP** bir agent'ın bir **aleti kullanması**. Karşı taraf A2A'da kendi kafasıyla plan yapar, MCP'de sadece söyleneni yapar. Bizim mimaride Joule bizim agent'a A2A ile iş verir, bizim agent da S/4'e MCP ile dokunur.

*A2A ile işi kime vereceğini seçersin, MCP ile o kişi hangi aleti kullanacağını seçer.*

---

## 3. MCP'nin temel parçaları

### 3.1 Roller: host, client, server

- **MCP server**: Tool'ları sunan taraf. Bizim senaryoda Integration Suite MCP Gateway'de çalışan "MCP Server" artifact'ı.
- **MCP client**: Server'a bağlanan küçük bileşen. Bizim agent'ın içinde yaşar.
- **Host**: Client'ı barındıran uygulama (bizim agent, Claude Code, Joule).

### 3.2 Server'ın sunabildiği üç şey

| Ne | Ne işe yarar | Kim tetikler | Örnek |
|---|---|---|---|
| **Tool** | Bir işlem yapar, sonuç döner | Model (LLM karar verir) | `get_A_BusinessPartner` |
| **Resource** | Okunacak veri / doküman | Uygulama | Bir dosya, bir tablo şeması |
| **Prompt** | Hazır prompt şablonu | Kullanıcı | "Siparişi özetle" şablonu |

Hackathonda neredeyse sadece **tool** kullanacağız. Integration Suite MCP Gateway de API'leri tool olarak sunuyor.

### 3.3 Konuşmanın sırası (lifecycle)

MCP de A2A gibi **JSON-RPC 2.0** kullanır. Her bağlantı aynı sırayla ilerler:

```
Client (agent)                                Server (MCP Gateway)
     │                                               │
     │ 1. initialize  (protokol sürümü, yetenekler)  │
     │──────────────────────────────────────────────►│
     │◄──────────────────────────────────────────────│
     │    cevap + header: Mcp-Session-Id: abc123     │
     │                                               │
     │ 2. notifications/initialized  (cevap beklenmez)
     │──────────────────────────────────────────────►│
     │                                               │
     │ 3. tools/list   "elinde ne var?"              │
     │──────────────────────────────────────────────►│
     │◄──── tool adları + açıklama + parametre şeması│
     │                                               │
     │ 4. tools/call   "get_A_BusinessPartner,       │
     │                  top=3"                       │
     │──────────────────────────────────────────────►│
     │◄──── result.content[0].text  (sonuç)          │
```

- **Session id:** `initialize` cevabının header'ında `Mcp-Session-Id` gelir. Sonraki **her** istekte bu header'ı geri göndermek zorundasın. Unutursan server seni tanımaz.
- **Discovery ≠ invocation:** `tools/list` çalışıyor diye `tools/call`'ın çalışacağı garanti değil. İkisini ayrı ayrı test et.
- **Tool açıklaması model içindir:** `tools/list`'te gelen `description` metni LLM'in "bu tool'u ne zaman çağırayım" kararını verdiği tek bilgidir. Kötü açıklama = yanlış tool seçimi.

### 3.4 Transport (taşıma)

| Transport | Nasıl | Ne zaman |
|---|---|---|
| **stdio** | Server, agent'ın yanında alt süreç olarak çalışır | Lokal araçlar (Claude Code'daki MCP'lerin çoğu) |
| **Streamable HTTP** | Tek bir HTTP adresine POST; cevap JSON ya da SSE akışı | Uzak server'lar. **MCP Gateway bunu kullanır** |
| HTTP+SSE (eski) | İki ayrı uç | Eski sürüm, yeni işte kullanma |

Streamable HTTP'de istek header'ında `Accept: application/json, text/event-stream` olmalı; yoksa bazı server'lar isteği reddeder.

---

## 4. SAP Integration Suite MCP Gateway

### 4.1 Ne yapar

Integration Suite'in içindeki bir yetenek. Var olan API'leri, entegrasyonları ve dışarıdaki MCP server'ları **tek, yönetilen (governed) bir MCP giriş noktasında** toplar. Kendi MCP server'ını yazıp barındırmak yerine bunu kullanırsın; kimlik doğrulama, rate limit, loglama hazır gelir.

```
                 ┌──────────────────────────────────────────┐
Bizim Agent ───► │      Integration Suite MCP Gateway       │
 (MCP client,    │  ┌────────────┐  ┌────────────────────┐  │
  Bearer JWT)    │  │ Policies   │  │ MCP Server artifact│  │
                 │  │ Authn/Authz│─►│ (tool listesi)     │  │
                 │  │ Rate limit │  └─────────┬──────────┘  │
                 │  └────────────┘            │             │
                 │       Integration Cell runtime           │
                 └────────────────────────────┼─────────────┘
                                              │ BTP Destination
                                              ▼
                               S/4HANA OData API, RFC, ServiceNow,
                               ya da başka bir uzak MCP server
```

**Benzetme:** Bir binanın **güvenlik masası**. Ziyaretçi (agent) kimliğini gösterir, masa hangi katlara (tool) girebileceğine bakar, girişi deftere yazar, sonra kapıyı açar. Odaların (API'lerin) her birine ayrı kilit takmana gerek kalmaz.

⚠️ **Lisans:** Integration Suite **Premium** veya **Enhanced Edition** gerekiyor; MCP özelliklerinin varlığı service plan'e bağlı. Edge Integration Cell'de MCP desteği olduğunu varsayma. Hackathon subaccount'ında Integration Suite entitlement'ının **subaccount'a atanmış** olduğunu kontrol et (global account'ta olması yetmez, bkz. `03-btp-temelleri.md`).

### 4.2 MCP Server artifact'ı nereden üretilir

Üç kaynak tipi var:

| Kaynak | Ne zaman |
|---|---|
| **API artifact / OpenAPI spesifikasyonu** | S/4 OData, REST API. En yaygın yol |
| **RFC tabanlı backend** | Eski ABAP fonksiyon modülleri (BAPI) |
| **Uzak (remote) MCP server** | Başka biri zaten MCP server yazmış, onu gateway arkasına alırsın |

### 4.3 Kurulum adımları (kısa)

1. **Integration Cell runtime'ı aç**: Integration Suite → Settings → Runtimes. Hazırlanması 30 dakikayı bulabilir, **hackathon ilk gün ilk iş**.
2. **Destination** oluştur (BTP Cockpit → Connectivity → Destinations). Ek özellik olarak `IntegrationCell.Include = true` ekle; yoksa destination wizard'da görünmez.
3. **Integration package** aç: Design → Integrations and APIs → Create.
4. **MCP Server artifact** ekle: Add → MCP Server. Kaynağı seç (ör. "HTTP Endpoint with OpenAPI Specification" veya hazır bir API artifact'ı), destination'ı ve relative URL'i ver (ör. `/sap/opu/odata/sap/API_BUSINESS_PARTNER`), bir **MCP Path** ver (ör. `/s4_bp_mcp`), runtime profile olarak **Integration Cell** seç.
5. **Tool'ları seç**: API'deki operasyonlardan sadece gerekenleri işaretle (bölüm 7).
6. **Policies** ayarla (bölüm 4.4).
7. **Deploy** et. Runtime Status `STARTED` olunca MCP URL yayında.
8. **İzle**: Monitor → Integrations and APIs → Monitor Message Processing (Integration Cell seçili). Her tool çağrısı tipi "MCP Server" olan bir satır olarak görünür. Çağrının gerçekten gateway'den geçtiğinin kanıtı bu; demoda göstermesi etkileyici.

Teknik kullanıcıyla hızlı deneme yolu da var: Developer Hub → Admin Center → Content → MCP Servers → **Create Product** → **Create New Subscription for Agent**. Bu sana client credentials (token URL, key, secret) verir. Demo öncesi denemelik iyidir ama kullanıcı kimliğini taşımaz.

### 4.4 Policies: kim girebilir, neye dokunabilir

İki ayrı kapı var. Hangisinde takıldığını hata kodu söyler.

**Authentication (kimsin?)**: Varsayılan ayar Integration Suite'in kendi XSUAA'sına bakar. Joule'den gelen kullanıcının **IAS token**'ını kabul etmesi için **External OAuth (OIDC)** olarak değiştir:

| Alan | Değer |
|---|---|
| Well-Known URL | `https://<ias-tenant>/.well-known/openid-configuration` |
| Audience | Token'ın gerçekteki `aud` değeri: **Custom Agent App'in Client ID'si** |
| ClientID Key | `${authn.oidc.jwt.azp}` |
| UserInfo Key | `${authn.oidc.jwt.mail}` |

**Authorization (neye yetkin var?)**: IAS token'ında XSUAA'daki gibi `scope` claim'i **yoktur**. Joule'nin token exchange'inden geçen token'da onun yerine `ias_apis` claim'i bulunur:

| Alan | Değer |
|---|---|
| Authorization Type | OAuth Scope OR Developer Key |
| Scope Key | `ias_apis` |
| Scope | Kendi exposed API adın (ör. `a2a_custom_agent_app_api`) |

Gerçek iş yetkisi (bu kullanıcı bu müşteriyi görebilir mi) yine S/4'ün kendi rollerinde kontrol edilir. Gateway sadece "bu token bu kapıdan geçebilir mi" der.

---

## 5. Agent gateway'i kullanıcı JWT'siyle nasıl çağırır

Bütün zincirin amacı: **S/4'te işlem, Joule'ye yazan gerçek kullanıcının yetkisiyle yapılsın** (principal propagation, bkz. `04-kimlik-ias.md`).

```
Kullanıcı ──► Joule ──(token exchange, aud = Custom Agent App)──► Bizim Agent
                                                                    │
                          Authorization: Bearer <aynı kullanıcı JWT'si>
                                                                    ▼
                                                            MCP Gateway
                                       (OIDC ile doğrular, ias_apis'e bakar)
                                                                    │
                          Destination: OAuth2SAMLBearerAssertion   │
                          (JWT'yi S/4'ün anlayacağı SAML'a çevirir) ▼
                                                              S/4HANA
                                                   (kullanıcının kendi rolleriyle)
```

Agent tarafında yapılacak iş küçük:
1. A2A isteğinin `Authorization` header'ından kullanıcı JWT'sini al.
2. MCP Gateway'e her istekte aynen `Authorization: Bearer <jwt>` olarak ilet.
3. Agent'ın kendi S/4 şifresine, client secret'ına ihtiyacı **yok**.

```python
# A2A isteğinden kullanıcının token'ını çek (a2a-sdk AgentExecutor içinde)
auth = context._call_context.state.get("headers", {}).get("authorization", "")
user_jwt = auth[len("bearer "):] if auth.lower().startswith("bearer ") else None
```

LangGraph agent'ına tool olarak bağlamak (LangChain MCP adapter'ı ile):

```python
from langchain_mcp_adapters.client import MultiServerMCPClient

async def tool_listesi(user_jwt: str):
    client = MultiServerMCPClient({
        "s4": {
            "url": MCP_URL,                                  # gateway'deki MCP Path'in tam adresi
            "transport": "streamable_http",
            "headers": {"Authorization": f"Bearer {user_jwt}"},  # her kullanıcının kendi token'ı
        }
    })
    return await client.get_tools()                          # initialize + tools/list arkada yapılır
```
(doğrulanmadı: `langchain-mcp-adapters` paketinin güncel parametre adları; resmi JS öğreticisi aynı kalıbı `@langchain/mcp-adapters` ile kullanıyor.)

⚠️ **Token'ı global değişkende tutma.** Aynı anda iki kullanıcı gelirse birinin token'ı ötekinin isteğine karışır. Token'ı her isteğin kendi bağlamında taşı.

⚠️ SAP mimari sayfası, kendi yazdığın bir MCP server'ın gelen token'ı **doğrudan** başka bir API'ye iletmemesi, önce token exchange ile daraltılmış yeni bir token alması gerektiğini söylüyor. Gateway + SAML Bearer destination bu dönüşümü bizim yerimize yapıyor.

---

## 6. curl ile test sırası

Agent koduna dokunmadan gateway'i tek başına test et. Sorun agent'ta mı gateway'de mi, buradan anlarsın.

```bash
# 1) initialize — cevap header'ından session id'yi yakala
SID=$(curl -s -o /dev/null -w '%header{mcp-session-id}' -X POST "$MCP_URL" \
  -H "Authorization: Bearer $USER_JWT" \
  -H "Accept: application/json, text/event-stream" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"curl","version":"1.0"}}}')

# 2) initialized bildirimi — cevap gelmez, ama atlanırsa bazı server'lar takılır
curl -s -o /dev/null -X POST "$MCP_URL" \
  -H "Authorization: Bearer $USER_JWT" -H "Accept: application/json, text/event-stream" \
  -H "Content-Type: application/json" -H "mcp-session-id: $SID" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'

# 3) tools/list — hangi tool'lar var, parametreleri ne
curl -s -X POST "$MCP_URL" \
  -H "Authorization: Bearer $USER_JWT" -H "Accept: application/json, text/event-stream" \
  -H "Content-Type: application/json" -H "mcp-session-id: $SID" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'

# 4) tools/call — OData seçenekleri $ işaretsiz, select bir DİZİ
curl -s -X POST "$MCP_URL" \
  -H "Authorization: Bearer $USER_JWT" -H "Accept: application/json, text/event-stream" \
  -H "Content-Type: application/json" -H "mcp-session-id: $SID" \
  -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_A_BusinessPartner","arguments":{"top":3,"select":["BusinessPartner","BusinessPartnerName"]}}}'
```

Sonucu okuma:
- `401 invalidToken` → **authentication** kapısı (issuer veya audience yanlış)
- `403 forbidden` → **authorization** kapısı (`ias_apis` / scope ayarı yanlış)
- Gerçek S/4 satırları → her şey çalışıyor

**Test token'ı nereden:** Düz IAS kullanıcı/şifre ile alınan token işe yaramaz; `aud`'u yanlış uygulamadır ve `ias_apis` taşımaz, iki kapıdan da düşer. En pratik yol: agent'ta Joule'den gelen gerçek `Authorization` header'ını **bir kere** log'la, oradan kopyala, sonra log satırını sil. Görsel test istersen `npx @modelcontextprotocol/inspector` ile MCP Inspector da açılabilir (transport: `streamable-http`, header: `Authorization`).

---

## 7. Az ve iyi tanımlanmış tool seç

OpenAPI'den MCP Server üretirken wizard bütün operasyonları işaretlemeye hazırdır. **Yapma.**

- **Az tool = doğru seçim.** LLM her istekte bütün tool açıklamalarını okur. 40 tool varsa yanlışını seçme ihtimali artar, prompt şişer, cevap yavaşlar (60 saniye kuralı, `01-a2a.md`).
- **Senaryoya göre 3–6 tool** yeterli. Ör. satış teklifi agent'ı: müşteriyi oku, son siparişleri oku, fiyat koşulunu oku, teklif oluştur.
- **Açıklamayı iş diliyle yaz.** "GET A_BusinessPartner" yerine "Müşteri numarası veya adıyla iş ortağı bilgisini getirir". Model bu cümleye bakarak karar verir.
- **Ham CRUD yerine iş sonucu.** Mümkünse `find_at_risk_suppliers` gibi bir iş sorusunu cevaplayan tool, beş ayrı ham OData çağrısından iyidir. Integration Suite'in API Composition özelliği birden çok API'yi tek tool'da birleştirebilir.
- **Okuma ve yazmayı ayır.** Yazan tool (kayıt oluşturma) varsa agent onu çağırmadan önce kullanıcıya sorsun (A2A `input-required`, Human-in-the-Loop). Jüri bunu sever.

---

## 8. Joule Studio agent'ları MCP'yi nasıl kullanır

Pro-code yerine low-code yol seçilirse (`02-joule-ve-joule-studio.md`):

- **Integration Suite'te oluşturulan MCP server'lar Joule Studio'da da erişilebilir.** Yani aynı gateway'i hem bizim Python agent'ı hem Joule Studio agent'ı kullanabilir.
- **Joule Studio, SAP iş alanları için kendisi MCP server üretebiliyor**: SAP'nin anlamsal API kataloğundan, alan bilgisiyle zenginleştirilmiş, güncellemesi ve bakımı SAP'de olan server'lar. GA durumu sayfada belirtilmiyor (doğrulanmadı).
- Joule Studio'ya kendi yazdığın bir MCP server'ı bağlarken topluluk deneyimi şunu söylüyor: server ayakta, `tools/list` dönüyor ama agent tool'u hiç çağırmıyor olabilir. Server'ın `initialize`, `notifications/initialized`, `tools/list`, `tools/call` dördünü de açıkça desteklediğinden emin ol ve katman katman test et.

---

## 9. Takılma noktaları (belirti → sebep)

| Belirti | Sebep |
|---|---|
| Destination MCP Server wizard'ında görünmüyor | Destination'da `IntegrationCell.Include=true` yok |
| Runtime seçeneği yok / deploy edilemiyor | Integration Cell runtime açılmamış veya hâlâ hazırlanıyor (30 dk) |
| Gerçek Joule token'ı ile `401 invalidToken` | Authentication policy'deki Audience, Custom Agent App Client ID'si değil |
| Authentication geçiyor ama her çağrı `403 forbidden` | Authorization policy hâlâ `scope`'a bakıyor; `ias_apis` olmalı |
| `initialize` çalışıyor, sonraki istek reddediliyor | `mcp-session-id` header'ı geri gönderilmiyor |
| `tools/call` şema hatası veriyor | OData seçeneği `$top` yazılmış (`top` olmalı) veya `select` virgüllü metin (dizi olmalı) |
| S/4'te işlem teknik kullanıcıyla yapılıyor, hata yok | Destination'da `x_user_token.jwks_uri` eksik; propagation sessizce düşüyor |
| `There is no trust between entities … in client 100` | S/4'e yanlış subaccount'ın trust sertifikası yüklenmiş |
| `tools/list` geliyor ama agent tool çağırmıyor | Tool açıklaması belirsiz, çok fazla tool var veya client `tools/call` yolunu hiç denemiyor |
| İki kullanıcının verisi karışıyor | Kullanıcı JWT'si global değişkende tutuluyor |

---

## 10. Neleri bilmen lazım (kontrol listesi)

Bunları kendi cümlenle anlatabiliyorsan bu konu tamam:

- [ ] MCP'de tool, resource ve prompt arasındaki fark nedir? Hackathonda hangisini kullanıyoruz?
- [ ] `initialize` → `notifications/initialized` → `tools/list` → `tools/call` sırasında session id ne zaman alınır, ne zaman gönderilir?
- [ ] MCP Gateway hangi transport'u kullanır, `Accept` header'ında ne olmalı?
- [ ] MCP Server artifact'ı hangi üç kaynaktan üretilebilir?
- [ ] Authentication ve authorization policy'lerinde neyi değiştiriyoruz, neden `scope` yerine `ias_apis`?
- [ ] `401` ile `403` hatası hangi kapıyı gösterir?
- [ ] Agent kullanıcı JWT'sini nereden alır, gateway'e nasıl iletir? Neden agent'ın S/4 şifresine ihtiyacı yok?
- [ ] Neden az sayıda, iyi açıklanmış tool seçmeliyiz?

---

## 11. Hackathon için hazır örnekler

- **SAP-samples/integration-mcp-gateway**: Birden çok API'yi (Business Partner, Plant, Material, risk servisi) tek bir composed API'de birleştirip MCP server olarak yayınlayan resmi hands-on öğretici. Mock API'lerle çalışır, test için MCP Inspector kullanır.
- **SAP Developers öğreticisi (ServiceNow örneği)**: Integration Cell açmaktan agent subscription almaya ve MCP Inspector ile test etmeye kadar adım adım.
- **SAP/ai-sdk-js → travel-itinerary-agent.ts**: LangGraph agent'ının MCP adapter ile tool çağırdığı resmi örnek (`05-ai-core-genai-hub.md`).

---

## Kaynaklar

- SAP Architecture Center: A2A and MCP for AI Agent Interoperability at SAP. https://architecture.learning.sap.com/docs/ref-arch/76ec36
- SAP Architecture Center: Third-Party MCP Access. https://architecture.learning.sap.com/docs/ref-arch/137800
- SAP Developers: Integration Suite MCP Gateway öğreticisi. https://developers.sap.com/tutorials/btp-integration-suite-mcp-gateway/
- SAP Help: Creating an MCP Server (Integration Suite). https://help.sap.com/docs/integration-suite/isuite-integrations-and-apis/creating-mcp-server
- MCP Specification (2025-06-18): Lifecycle ve Transports. https://modelcontextprotocol.io/specification/2025-06-18
- MCP Inspector. https://github.com/modelcontextprotocol/inspector
- GitHub: https://github.com/SAP-samples/integration-mcp-gateway
- SAP Cloud SDK for AI (JS), Getting Started with Agents (MCP adapter örneği). https://sap.github.io/ai-sdk/docs/js/tutorials/getting-started-agents
- SAP Beyni notları: `ai/baglanti/joule-a2a-mcp-gateway-s4-principal-propagation.md`, `araclar/mcp-gateway-integration-suite.md`, `araclar/sap-integration-suite-mcp-gateway.md`, `ai/kavramsal/mcp-lifecycle-discovery-vs-invocation.md`, `btp/baglanti/mcp-arac-kesfi-destination-uzerinden.md`
