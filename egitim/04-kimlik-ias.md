# 04 · Kimlik: IAS, App2App ve Principal Propagation

> **Tek cümle:** IAS, SAP dünyasının nüfus müdürlüğüdür. Joule ile agent'ımız birbirine IAS'ın verdiği "kimlik kartlarıyla" (token) güvenir, ve doğru kurulursa agent S/4'e giderken kartın üstünde hâlâ gerçek kullanıcının adı yazar.

---

## 1. Neden var?

`01-a2a.md`'de akış basitti: kullanıcı Joule'ye yazar, Joule agent'ı çağırır, agent S/4'ü çağırır. Ama üç güvenlik sorusu cevapsız kaldı:

1. Agent, gelen isteğin **gerçekten Joule'den** geldiğini nereden bilecek?
2. Agent S/4'e gittiğinde S/4, işlemi **kimin adına** yapacak? Agent'ın kendi adına mı, Ayşe'nin adına mı?
3. Ayşe'nin S/4'te görme yetkisi olmayan veriyi agent ona gösterebilir mi?

Bu üç sorunun cevabı IAS, App2App trust ve principal propagation. Hackathonda en çok vaktin **burada** gidecek.

**Benzetme:** Bir otel düşün. Resepsiyon (IAS) sana kart verir. Kartın sadece **senin** odanı açar (`aud`). Oda servisine (agent) bir şey sipariş edersin, garson mutfağa (S/4) giderken senin kartının **kopyasını** değil, "bu sipariş 304'teki misafir için" yazan **yeni bir fiş** alır (token exchange). Mutfak fişe bakıp sadece senin hakkın olan menüyü hazırlar (principal propagation).

---

## 2. Oyuncular: IAS, XSUAA, IPS

SAP Cloud Identity Services bir şemsiye ad. Altında bize lazım olan iki servis var, bir de BTP'nin eski kimlik servisi:

| | **IAS** (Identity Authentication) | **XSUAA** (Authorization and Trust Management) | **IPS** (Identity Provisioning) |
|---|---|---|---|
| Ne yapar | Kimlik doğrular: "Bu Ayşe mi?" | Kimlik + yetki: "Ayşe kim, neye yetkisi var?" | Kullanıcıları sistemler arası kopyalar |
| Kapsam | Tenant (birden çok subaccount ve SAP ürünü paylaşır) | Tek subaccount | Kaynak → hedef senkron |
| Protokol | OpenID Connect (OIDC), SAML | OAuth 2.0 | SCIM |
| Token'da yetki | **`scope` yok.** Yerine `ias_apis` (App2App için) | **`scope` var** (örn. `myapp.Read`) | Token vermez |
| Joule ile ilişkisi | **Joule IAS kullanır.** App2App burada kurulur | Eski CF app'lerinde, CAP'te sık görülür | Hackathonda dokunmayız |

**Akılda tutma cümlesi:** *IAS "kimsin" der, XSUAA "kimsin ve ne yapabilirsin" der.* Joule tarafı IAS dünyasında yaşıyor, o yüzden agent'ımızın da IAS token'ını anlaması gerekiyor.

**IPS ne zaman lazım:** Şirketin kullanıcıları Azure AD'de duruyorsa ve SAP sistemlerine otomatik kopyalanması gerekiyorsa. Hackathonda hazır kullanıcılarla çalışacağımız için IPS'e ihtiyaç yok (doğrulanmadı).

---

## 3. Subaccount ile IAS arasında trust

Subaccount varsayılan olarak SAP'nin kendi kimlik sağlayıcısını (SAP ID Service, `accounts.sap.com`) kullanır. Joule ve App2App için subaccount'u **kendi IAS tenant'ına** bağlaman gerekir:

```
BTP Cockpit → Subaccount → Security → Trust Configuration
      → "Establish Trust" → IAS tenant'ını seç
      → BTP arkada IAS'ta bir OIDC application oluşturur
```

Bundan sonra:
- Kullanıcılar subaccount'a IAS üzerinden girer.
- IAS admin konsolu adresi: `https://<tenant>.accounts.ondemand.com/admin`
- Subaccount'taki **role collection**'lar IAS kullanıcılarına veya IAS gruplarına atanabilir.

⚠️ IAS tenant'ı ile global account aynı müşteri numarasına bağlı olmalı, yoksa listede çıkmaz (doğrulanmadı).

---

## 4. OIDC application: IAS'taki "uygulama kaydı"

IAS'ın tanıdığı her uygulama, admin konsolunda bir **application** olarak kayıtlıdır. OIDC application'ın üç temel parçası:

- **Client ID:** Uygulamanın kimlik numarası. Token'daki `aud` ve `azp` alanlarında bu görünür.
- **Client Authentication:** Uygulamanın IAS'a "ben gerçekten benim" demesi. Secret veya sertifika (sertifika daha güvenli).
- **Provided APIs / Dependencies:** App2App için (bölüm 5).

Hackathonda IAS'ta en az iki application göreceksin:

| Application | Ne için |
|---|---|
| **Joule** | Joule'yü kurunca otomatik oluşur |
| **Bizim agent** ("Custom Agent App") | Agent'ın kimliği. Joule'nin token'ı **bunun** client ID'sine göre üretilir |
| **CLI uygulaması** | `joule` CLI'ın login olabilmesi için. Dependency adı tam olarak `Cli2Joule` olmalı (bkz. `08-joule-cli-capability.md`) |

---

## 5. App2App trust: iki uygulamanın el sıkışması

**App2App**, bir uygulamanın (consumer) diğerinin (provider) API'sini IAS üzerinden güvenli çağırması. İki tarafın da yapacağı bir iş var:

```
PROVIDER (çağrılan: bizim agent)          CONSUMER (çağıran: Joule)
┌──────────────────────────────┐          ┌──────────────────────────────┐
│ Provided APIs                │          │ Dependencies                 │
│  └ "a2a_custom_agent_app_api"│ ◄─────── │  └ ad: "myAgentDep"          │
│    (API permission group)    │  bağlar  │    hedef: Agent App          │
└──────────────────────────────┘          │    API: a2a_custom_agent_... │
                                          └──────────────────────────────┘
```

1. **Provider** bir **API permission group** tanımlar (IAS konsolunda *Provided APIs*). "Benim şu API'm var, adı bu."
2. **Consumer** bir **dependency** ekler: "Şu uygulamanın şu API'sine bağımlıyım, bu bağlantıya `myAgentDep` diyorum."
3. Consumer token isterken `resource` parametresine dependency adını yazar:
   `resource=urn:sap:identity:application:provider:name:myAgentDep`
4. IAS'ın verdiği token'da:
   - `aud` = **provider'ın client ID'si** (token sadece agent için geçerli)
   - `ias_apis` = izin verilen API grupları listesi, örn. `["a2a_custom_agent_app_api"]`

```json
{
  "sub": "P123456",                       // kullanıcı
  "mail": "ayse@firma.com",
  "aud": "<agent-app-client-id>",         // bu token kimin için
  "azp": "<joule-client-id>",             // bu token'ı kim istedi
  "ias_apis": ["a2a_custom_agent_app_api"] // hangi API'ye izin var
}
```

### 5.1 Joule ↔ agent

SAP'nin Joule dokümanı açıkça diyor: Joule ile agent arasında **IAS App2App trust** kurulmalı. Özellikle asenkron modda agent'ın Joule webhook'una gönderdiği güncellemelerin doğrulanması için şart. Bu kurulum **Joule booster** ile otomatik yapılabiliyor, elle yapmak için IAS'ın *Consuming APIs from Other Applications* adımları izleniyor.

Saha notu (SAP Beyni): Joule'nin agent'a gönderdiği token'ın `aud` değeri **Custom Agent App'in client ID'si**, `ias_apis` da agent'ın açtığı API grubunun adı. Agent bu ikisini kontrol eder.

---

## 6. Token exchange: bir kartı başka kapı için değiştirmek

Kullanıcı Joule'ye girdiğinde aldığı token'ın `aud`'u Joule'dür. Bu token'la agent'a giderse agent "bu benim için değil" der. Çözüm: **token exchange**. Eski token'ı IAS'a ver, hedefi değiştirilmiş yenisini al.

```
1. Kullanıcı ──login──► IAS ──token (aud=Joule)──► Joule
2. Joule ──"bunu agent için değiştir"──► IAS /oauth2/token
         grant_type = urn:ietf:params:oauth:grant-type:jwt-bearer
         assertion  = <kullanıcının token'ı>
         resource   = urn:sap:identity:application:provider:name:<dependency>
3. IAS ──yeni token (aud=Agent, sub=aynı kullanıcı, ias_apis=[...])──► Joule
4. Joule ──A2A message/send + Authorization: Bearer <yeni token>──► Agent
5. Agent aynı işi tekrar yapar: kendi token'ını S/4 veya MCP Gateway için değiştirir
```

İsteğin alanları:

| Alan | Ne | Not |
|---|---|---|
| `grant_type` | `urn:ietf:params:oauth:grant-type:jwt-bearer` | "Elimde bir JWT var, bunu değiştir" |
| `assertion` | Gelen kullanıcı token'ı | Değiştirilecek kart |
| `resource` | `urn:sap:identity:application:provider:name:<ad>` | Hedef. Yeni token'ın `aud`'u buradan çıkar |
| `client_id` + kimlik | Exchange'i isteyen uygulama | Secret, sertifika (mTLS) veya client assertion |
| `app_tid` | Uygulamanın tenant ID'si | Çok kiracılı (multi-tenant) senaryoda hangi tenant için |

**Değişmeyenler:** `sub`, `sap_id_type`, `sap_user_type`. Yani kullanıcı kimliği zincir boyunca korunur. **Değişenler:** `aud` ve `app_tid`, `resource`'a göre yeniden hesaplanır.

Kod örneği (agent içinde, Python, şifre ortam değişkeninden):

```python
import os
import requests

def exchange_token(user_jwt: str, dependency: str) -> str:
    response = requests.post(
        f"{os.environ['IAS_URL']}/oauth2/token",
        data={
            "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
            "assertion": user_jwt,                       # Joule'den gelen token
            "resource": f"urn:sap:identity:application:provider:name:{dependency}",
            "client_id": os.environ["IAS_CLIENT_ID"],    # agent'ın kendi kimliği
            "client_secret": os.environ["IAS_CLIENT_SECRET"],  # koda YAZMA, binding/env'den
        },
        timeout=10,
    )
    response.raise_for_status()
    return response.json()["access_token"]               # aud artık hedef sistem
```

⚠️ `app_tid` ile ilgili bilinen hata: joule-cli 2.0.2'de `joule login` `app_tid` yüzünden `AUTH_FETCH_TOKEN_FAILED` veriyor, çözüm `joule login --no-app-tid` (bkz. `01-a2a.md` takılma tablosu).

---

## 7. Principal propagation: "kimin adına?"

**Principal propagation**, zincirin sonundaki sistemin (S/4, Datasphere) işlemi **gerçek kullanıcının yetkisiyle** yapmasıdır. Agent'ın kendi süper-kullanıcısıyla değil.

Neden önemli: Ayşe S/4'te sadece kendi şirket kodunu görebiliyorsa, agent da Ayşe adına sadece onu görmeli. Aksi halde agent bir **yetki deliği** olur: herkes Joule'ye sorarak her şeyi görür.

SAP'nin agent kimlik modeli iki durum tanımlıyor:

| | **Kullanıcı bağlamında agent** | **Otonom agent** |
|---|---|---|
| Kimin adına | Joule'de yazan gerçek kullanıcı | Agent'ın kendi kimliği |
| `sap_user_type` | `user` (veya uygulama ise `techUser`) | `agentUser` |
| Token nasıl alınır | Kullanıcı token'ı exchange edilir | Client credentials + `impersonate_assigned_user=true` |
| Etkin yetki | Kullanıcının yetkisi **ile** agent'ın yetkisinin **kesişimi** | Agent kullanıcısına verilen yetki |
| Örnek | "Benim açık siparişlerimi göster" | Gece çalışan, kimse yazmadan stok kontrol eden agent |

Ek olarak SAP mimarisi, kullanıcının bir agent'ı çağırabilmesi için `authZ` claim'inde `access@agent` izni olmasını, agent'tan hedefe de `read` / `write` / `access` izinleri tanımlıyor. Bu politika katmanının bir kısmı **H2/2026'da yayınlanacak** diye geçiyor, hackathonda hazır olmayabilir (doğrulanmadı).

**Hackathon için pratik yol:** Kullanıcı bağlamı. Agent, Joule'den gelen token'ı alır ve:
- **(a)** MCP Gateway'e olduğu gibi iletir (bkz. `06-mcp-ve-mcp-gateway.md`), ya da
- **(b)** `OAuth2SAMLBearerAssertion` destination'ı ile S/4'e gider (bkz. `03-btp-temelleri.md` bölüm 6.3).

---

## 8. IAS token'ında neden `scope` yok?

XSUAA'dan gelen biri bunu ilk gün yaşar: token'ı açarsın, `scope` alanını ararsın, yok.

**Sebep:** IAS'ın işi **kimlik doğrulamak**, yetki dağıtmak değil. Yetki ya hedef sistemde (S/4 rolleri, business catalog) ya da ayrı bir politika servisinde kontrol edilir. App2App çağrılarında "bu uygulamanın bu API'ye izni var mı" bilgisi `scope` yerine **`ias_apis`** claim'inde gelir.

**Pratik sonucu:** XSUAA zihniyetiyle yazılmış bir yetki kontrolü (örn. API Management'ta "OAuth Scope" politikası, CAP'te `@requires: 'Read'`) IAS token'ıyla **her zaman reddeder**. Kontrolü `ias_apis`'e çevirmen gerekir:

| Alan | XSUAA token | IAS App2App token |
|---|---|---|
| Kim | `user_name`, `email` | `sub`, `mail` |
| Kimin için | `aud` (xsappname'ler) | `aud` (provider client ID) |
| Ne yapabilir | `scope` | `ias_apis` |

---

## 9. Demo kısayolu: `NoAuthentication` ve neden tehlikeli

Zaman daraldığında Joule → agent destination'ını `NoAuthentication` yapıp agent'ı token kontrolsüz çalıştırmak cazip. SAP'nin toolkit'i de demo için böyle başlıyor.

**Ne kaybedersin:**
- Agent'ın URL'i (`https://...cfapps...`) **internetten herkese açık** olur. URL'i bilen herkes agent'ı çağırır, senin LLM kotanı yakar.
- Agent'a token gelmediği için **kim çağırdığını bilmez**. Principal propagation imkânsız, S/4'e teknik kullanıcıyla gidersin.
- Jüri "güvenlik nasıl?" diye sorduğunda cevabın yok.

**Orta yol (hackathon için önerim):**
1. İlk gün `NoAuthentication` ile uçtan uca çalıştır. Önce akış çalışsın.
2. İkinci gün agent'a **token doğrulaması** ekle: `iss` = IAS tenant, `aud` = agent client ID, `ias_apis` içinde kendi API adın.
3. Vakit kalırsa principal propagation'ı S/4 veya MCP Gateway'e kadar taşı. Sunumda bunu göstermek jüride büyük artı.

---

## 10. 401 mi 403 mü? Teşhis

İki hata kodu farklı katmanı gösterir. Karıştırma, yanlış yeri düzeltirsin.

```
İstek geldi
   │
   ▼
Token geçerli mi? (imza, süre, iss, aud)
   │ hayır ──► 401 Unauthorized   "Seni tanımıyorum"
   │ evet
   ▼
Bu işe yetkisi var mı? (ias_apis, scope, backend rolü)
   │ hayır ──► 403 Forbidden      "Tanıyorum ama izin yok"
   │ evet
   ▼
200 OK + veri
```

| Kod | Katman | İlk bakılacak yer |
|---|---|---|
| **401** | Authentication | `aud` doğru client ID mi? `iss` doğru IAS tenant'ı mı? Token süresi doldu mu? Token hiç gelmiyor mu? |
| **403** | Authorization | Kontrol `scope` mu arıyor (IAS'ta yok)? `ias_apis`'te doğru API adı var mı? Kullanıcının S/4'te rolü var mı? |

**Token'ı okumak:** JWT üç parçadır, ortadaki parça base64 JSON'dur. Yerel bir araçla çöz, `aud`, `iss`, `ias_apis`, `sub`'a bak. Gerçek token'ı herkese açık web sitelerine yapıştırma.

---

## 11. Takılma noktaları (belirti → sebep)

| Belirti | Sebep |
|---|---|
| Gerçek Joule token'ı bile `401 invalidToken` | Doğrulamadaki audience yanlış; login/test app'inin değil, **Custom Agent App'in client ID'si** olmalı |
| Authentication geçiyor, her çağrı `403 forbidden` | Yetki kontrolü `scope` arıyor; IAS token'ında yok, `ias_apis`'e çevir |
| Test token'ıyla her şey başarısız ama Joule'den gelen çalışıyor | Düz IAS password grant ile alınan token'da doğru `aud` ve `ias_apis` yok; exchange'i taklit et veya gerçek header'ı bir kez logla |
| S/4'te işlem hep teknik kullanıcıyla görünüyor | Destination'da `x_user_token.jwks_uri` eksik, propagation sessizce düşmüş |
| `joule login` → `AUTH_FETCH_TOKEN_FAILED` | joule-cli 2.0.2 `app_tid` hatası; `--no-app-tid` |
| `joule` CLI dependency'yi bulamıyor | IAS'taki dependency adı tam olarak `Cli2Joule` değil |
| Subaccount Trust Configuration'da IAS tenant'ı listede yok | IAS tenant'ı global account ile aynı müşteriye bağlı değil (doğrulanmadı) |
| S/4: "There is no trust between entities … in client 100" | S/4'e yanlış subaccount'ın destination sertifikası yüklenmiş; mesaj hangi subaccount ID'sini gördüğünü söyler |

---

## 12. Neleri bilmen lazım (kontrol listesi)

Bunları kendi cümlenle anlatabiliyorsan bu konu tamam:

- [ ] IAS ile XSUAA farkı nedir? Joule hangisini kullanır?
- [ ] App2App'te provider ve consumer tarafında ne tanımlanır (Provided APIs, Dependency)?
- [ ] Token exchange isteğinde `grant_type`, `assertion` ve `resource` ne işe yarar?
- [ ] Exchange sonrası token'da `aud` ve `ias_apis` neyi gösterir?
- [ ] Principal propagation nedir, olmazsa ne tür bir güvenlik açığı oluşur?
- [ ] Kullanıcı bağlamındaki agent ile otonom agent (`agentUser`) arasındaki fark nedir?
- [ ] IAS token'ında neden `scope` yok, yetki kontrolü neye göre yapılır?
- [ ] 401 ile 403 arasındaki fark nedir, her biri için ilk nereye bakarsın?

---

## Kaynaklar

- SAP Architecture Center: Third-Party A2A & Token Exchange (jwt-bearer, `resource`, `app_tid`, `agentUser`). https://architecture.learning.sap.com/docs/ref-arch/f4a2c8
- SAP Architecture Center: Agent Identity. https://architecture.learning.sap.com/docs/ref-arch/140bdb
- SAP Architecture Center: Non-SAP Agent Principal Propagation. https://architecture.learning.sap.com/docs/ref-arch/07cfe4
- SAP Architecture Center: Integrating AI Agents with Joule (IAS App2App trust şartı). https://architecture.learning.sap.com/docs/ref-arch/ae6821
- Joule Development Guide: Code-Based Agents (Bring Your Own Agent). https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/2f9701e60fd24e948c2c74fe9e55ce23.html
- SAP Cloud Identity Services: Consume an API from a Provider Application (`resource`, `ias_apis` örnek token'ları). https://github.com/SAP-docs/btp-cloud-identity-services/blob/main/docs/Development/consume-an-api-from-a-provider-application-9675b64.md
- SAP Cloud Identity Services: Consuming APIs from Other Applications. https://help.sap.com/docs/cloud-identity-services/cloud-identity-services/consume-apis-from-other-applications
- SAP Cloud Identity Services: Provided APIs. https://github.com/SAP-docs/btp-cloud-identity-services/blob/main/docs/Operation-Guide/provided-apis-0251c56.md
- SAP Help: Managing Trust from SAP BTP to an SAP Cloud Identity Services Tenant. https://help.sap.com/docs/btp/sap-business-technology-platform/managing-trust-from-sap-btp-to-sap-cloud-identity-services-tenant
- SAP Connectivity: Configure Principal Propagation via IAS Token. https://github.com/SAP-docs/btp-connectivity/blob/main/docs/1-connectivity-documentation/configure-principal-propagation-via-ias-token-47a3cff.md
- SAP Beyni notları: `ai/baglanti/joule-a2a-mcp-gateway-s4-principal-propagation.md`, `ai/baglanti/joule-cli-login-sorunlari.md`, `ai/baglanti/custom-agent-joule-a2a-entegrasyonu.md`
