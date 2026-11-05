# 08 · Joule CLI ve Capability

> **Tek cümle:** `joule` CLI, Joule'ye "bu cümleyi duyarsan şu agent'ı çağır" diyen YAML dosyalarını derleyip Joule tenant'ına yükleyen komut satırı aracıdır.

---

## 1. Neden var?

Agent'ın (Python, LangGraph) Cloud Foundry'de çalışıyor olabilir. Ama Joule onun varlığından haberdar değil. Joule'ye üç şeyi söylemen lazım:

1. **Ne zaman** çağıracak? → scenario
2. **Nasıl** çağıracak? → function içindeki `agent-request` action'ı
3. **Nereye** çağıracak? → system alias → BTP destination

Bunları YAML ile yazarsın, `joule` CLI ile derleyip yüklersin.

**Benzetme:** Joule bir **santral**. Agent'ın yeni bir dahili hat. `joule` CLI ile santrale "şu konudaki aramaları 4217'ye bağla" kuralını yazıyorsun. Hattın kendisini (agent) kurmak ayrı iş (`07-pro-code-agent.md`).

```
Kullanıcı ──► Joule
               │ scenario açıklamasına bakar: "satış teklifi optimize" → eşleşti
               ▼
            function: call_agent.yaml
               │ action: agent-request, system_alias: SALES_AGENT
               ▼
            capability.sapdas.yaml: SALES_AGENT → destination "SALES_AGENT"
               ▼
            BTP Destination "SALES_AGENT" (URL + auth)
               ▼  A2A message/send
            Senin agent'ın
```

---

## 2. Kurulum

### 2.1 Ön koşullar

- **Node.js 20.12.0 ile 24 arası** (`joule` için). Yeni Joule Studio'nun `jl` komutu ise **Node 24+** istiyor. İkisini birlikte kullanacaksan Node 24 kur.
- Windows'ta PowerShell yeterli.

### 2.2 Kur, kontrol et, güncelle

```powershell
npm install -g @sap/joule-studio-cli          # kurar: hem 'joule' hem 'jl' komutu gelir
joule -V                                       # joule sürümü (çalışmazsa: joule --version)
jl version                                     # jl sürümü
npm install -g @sap/joule-studio-cli --force   # güncelle
npm install -g @sap/joule-studio-cli@1.0.90    # belirli sürüm (örnek numara)
```

| Komut | Ne için |
|---|---|
| `joule` | Joule Studio CLI (SAP buna artık "Legacy" diyor). YAML capability derler, digital assistant deploy eder. **Bu dosyanın konusu.** |
| `jl` | Joule Work / yeni Joule Studio CLI. Solution, agent, MCP server yönetir. Claude Code ile çalışır (`02-joule-ve-joule-studio.md`). |

⚠️ Eskiden `@sap/joule-work-dev-cli-early-adopters` kurduysan önce kaldır, yoksa `jl` dosyası çakışır (`EEXIST`).

⚠️ Kaldırmadan önce `joule logout` çalıştır. Kaldırmak, saklanmış giriş bilgisini silmez.

---

## 3. `joule login`: en çok vakit yediren adım

### 3.1 Önce IAS'ta hazırlık (bir kerelik)

Joule CLI, IAS (SAP Cloud Identity Services) üzerinden kullanıcı adı + şifre ile token alır. Bunun için IAS'ta CLI'ya özel bir uygulama açman gerekir:

```
1. BTP subaccount → Security → Trust Configuration → IAS tenant adresini al
2. Adresin sonuna /admin ekle → IAS admin paneli
3. Applications & Resources → Applications → Create (OpenID Connect)
4. Yeni uygulama → Dependencies → Add
      İsim: Cli2Joule            ← TAM OLARAK bu, başka isim çalışmaz
      Joule application + API seç → Save
5. Client Authentication → Add → Client Secret üret
      Client ID ve Secret'ı bir kere görürsün, hemen güvenli yere kaydet
```

SSO ile girmek istersen IAS uygulamasına redirect URI ekle: `http://localhost:8400/login/callback?authType=ias`

### 3.2 Hangi URL hangisi?

| İstenen | Nereden alınır |
|---|---|
| **Authentication URL** | IAS tenant adresi: `https://<tenant>.accounts.ondemand.com` (veya `accounts400`) |
| **API URL** | BTP subaccount → Instances and Subscriptions → **Joule** (Standard plan) uygulamasının detay sayfası. Şekli: `https://<subdomain>.<region>.sapdas.cloud.sap` |
| **Client ID / Secret** | 3.1'de IAS'ta ürettiğin |
| **Username / Password** | IAS kullanıcın |

⚠️ API URL'yi **UAA credentials** veya **service key**'den alma. Yanlış olur.

### 3.3 Giriş yolları

```powershell
# 1) Sorulara cevap vererek (en kolay)
joule login --apiurl '<API_URL>'

# 2) SSO ile (şifre yazmadan, tarayıcı açılır)
joule login --sso-passcode --apiurl '<API_URL>'

# 3) .env dosyasından (script/CI için)
joule login --use-env .env
```

`.env` içindeki değişkenler: `JOULE_API_URL`, `JOULE_AUTH_URL`, `JOULE_CLIENT_ID`, `JOULE_CLIENT_SECRET`, `JOULE_USERNAME`, `JOULE_PASSWORD`, `JOULE_DEFAULT_IDP`, `JOULE_AUTH_NO_APP_TID`, `JOULE_AUTH_APP_TID`.

⚠️ `.env` dosyasını **asla** git'e koyma. `.gitignore`'a ekle. Secret'ı hiçbir YAML'a, koda, bu notlara yazma.

### 3.4 `--no-app-tid` meselesi

- **joule-cli 2.0.2'de** flagsiz `joule login`, `AUTH_FETCH_TOKEN_FAILED` hatası veriyordu. Çözüm `joule login --no-app-tid` idi (Şubat 2026 blog, SAP Beyni notu).
- **Güncel SAP Help'e göre** artık varsayılan davranış zaten `app_tid` göndermemek. `--no-app-tid` yazmak zararsız, script'lerde kalabilir.
- Kural: Kendi açtığın IAS uygulaması (3.1'deki) → `app_tid` **gönderilmez**. SAP'nin yönettiği bir uygulama (BTP service instance, subscription) → `--app-tid` ile **gönderilmeli**. Gereksiz gönderirsen 401 alırsın.
- Hangi sürümde düzeltildiği belgede yazmıyor (doğrulanmadı). Kurulu sürümün eskiyse güvenli yol: `--no-app-tid` ekle.

### 3.5 Windows ve şifre tuzakları

- Değerleri tek tırnakla yaz: `-a 'https://...'`
- 2FA açıksa şifre alanına `<şifre><authenticator kodu>` bitişik yaz.
- Trust Configuration'daki origin key `sap.default` ise `--default-idp` ekle (CLI varsayılan olarak `sap.custom` kullanır).
- Node 20+ ile ağ hatası alırsan: `$env:NODE_OPTIONS="--no-network-family-autoselection"`
- SAP dokümanı, secret'ta `$` varsa `\$` yazmanı söylüyor (bash için). PowerShell'de tek tırnak `$`'ı zaten korur (kendi notum, SAP Help bunu PowerShell için ayrıca belirtmiyor).
- Kullanıcıya en az `extensibility_developer` rolü atanmış olmalı, sadece `end_user` yetmez.

⚠️ "Tüm tenant'lar 1 Ocak'tan sonra yalnız IAS ile giriş yapabilecek" notu var. Hangi yılın 1 Ocak'ı olduğu belgede yazmıyor (doğrulanmadı). Hackathon tenant'ı XSUAA ise `--sso-passcode` yolunu dene.

---

## 4. Proje yapısı

```
my_assistant/                    ← çalışma klasörü
├── da.sapdas.yaml               ← digital assistant tanımı: hangi capability'ler birleşecek
└── sales_capability/
    ├── capability.sapdas.yaml   ← zorunlu: kimlik + system_aliases
    ├── scenarios/
    │   └── optimize_quote.yaml  ← "ne zaman çağrılır"
    ├── functions/
    │   └── call_agent.yaml      ← "ne yapılır"
    └── i18n/                    ← isteğe bağlı: çeviri metinleri
```

Diğer isteğe bağlı parçalar: `hooks/initialize.yaml` (sohbet başında çalışır), `capability_context.yaml`, `deployment_extension.yaml`, `agents/` (SAP'nin kendi local agent tanımları).

İsim kuralları: assistant ve capability adı en fazla 50 karakter, sadece harf, rakam ve alt çizgi. Boşluk ve art arda iki alt çizgi yasak. Dosya adları en fazla 30 karakter.

### 4.1 `capability.sapdas.yaml`: kimlik kartı

```yaml
schema_version: 3.28.0            # BYOA için en az 3.28.0 (SAP Help). Bkz. not aşağıda
metadata:
  namespace: joule.ext            # ZORUNLU. Başka bir şey yazarsan deploy 5014 hatası verir
  name: sales_capability          # harf, rakam, alt çizgi
  version: 1.0.0
  display_name: Sales Quote Agent
  description: Satış tekliflerini optimize eden agent'ı çağırır
system_aliases:
  SALES_AGENT:                    # function içinde bu isimle anılır
    destination: SALES_AGENT      # BTP'deki destination adıyla BİREBİR aynı
  JOULE_GLOBAL_DOC_GROUNDING:     # document grounding için, destination açmaya gerek yok
    destination: JOULE_GLOBAL_DOC_GROUNDING
```

⚠️ **schema_version çelişkisi:** SAP Help "code-based agents 3.28.0'dan itibaren destekleniyor" diyor. Action tablosu ise `agent-request`'i 3.18.0'dan beri listeliyor. Şubat 2026 blog'u ve `01-a2a.md` 3.27.0 diyor. Güvenli seçim **3.28.0**. Aynı assistant'taki tüm capability'lerin major sürümü aynı olmalı (3.x ile 3.x olur, 2.x ile 3.x olmaz).

### 4.2 `scenarios/optimize_quote.yaml`: ne zaman

```yaml
description: >                    # Joule bu metne bakıp seçim yapar. Net ve anahtar kelimeli yaz
  Satış teklifini (sales quote) analiz eder ve kâr marjını artıracak
  fiyat, indirim ve ürün önerileri verir.
target:
  type: function
  name: call_agent                # functions/call_agent.yaml dosyasının adı
```

Açıklama zayıfsa Joule senin scenario'nu seçmez, kendi bildiğini yapar. `joule lint` aynı açıklamanın iki scenario'da tekrar etmesini yakalar.

### 4.3 `da.sapdas.yaml`: assistant'ı birleştir

```yaml
schema_version: 1.0.0             # DA config şeması (capability şemasından ayrı)
name: oktay_sandbox               # senin test assistant'ının adı
capabilities:
  - type: local
    folder: ./sales_capability    # derlenecek capability klasörü
```

---

## 5. `agent-request` action'ı (Joule'nin A2A çağrısı)

### 5.1 En sade hali (senkron)

```yaml
# functions/call_agent.yaml
action_groups:
  - actions:
      - type: status-update              # kullanıcı beklerken görür
        message: "Teklifi analiz ediyorum..."
      - type: agent-request
        system_alias: SALES_AGENT        # remote agent için zorunlu
        agent_type: remote               # yazmazsan 'local' sayılır, BYOA çalışmaz
        result_variable: apiResponse     # agent'ın cevabı buraya düşer
      - type: message
        message:
          type: text
          content: "<? apiResponse.body.artifacts[0].parts[0].text ?>"
```

Joule kullanıcının cümlesini A2A `message/send` ile (JSON-RPC, A2A 0.3.0) agent'a gönderir. Sadece `text` gider. Cevabı **60 saniye** bekler.

Joule cevabı doğrulamaz. Yapı neyse `result_variable` odur. Yolu yanlış yazarsan kullanıcı boş mesaj görür.

### 5.2 Tüm alanlar

| Alan | Zorunlu mu | Ne işe yarar |
|---|---|---|
| `type: agent-request` | Evet | Action tipi |
| `system_alias` | Remote'ta evet | `capability.sapdas.yaml`'daki alias |
| `agent_type` | Hayır (varsayılan `local`) | BYOA için `remote` |
| `path` | Hayır | Destination URL'sinin arkasına eklenir, belirli bir agent endpoint'i için |
| `body.Message` | Hayır | Kullanıcı cümlesi yerine kendi metnini göndermek için |
| `body.contextId`, `body.taskId` | Hayır | Çok turlu konuşmada önceki görevi devam ettirmek için |
| `body.configurations.pushNotifications` | Hayır | `true` → asenkron mod (uzun işler) |
| `name` | Local'de evet | SAP'nin kendi local agent'ı için yol |
| `result_variable` | Pratikte evet | Cevabın saklanacağı değişken |

### 5.3 Çok turlu konuşma ve Human-in-the-Loop

Agent "Hangi teklif?" diye geri sorarsa (`input-required`), bir sonraki turda aynı `contextId` ve `taskId`'yi geri göndermen lazım. Yoksa agent konuyu unutur.

```yaml
action_groups:
  - actions:
      - type: agent-request
        system_alias: SALES_AGENT
        agent_type: remote
        body: >
          {
            "contextId": "<? ctx_id ?>",
            "taskId": "<? task_id ?>"
          }
        result_variable: apiResponse
      - type: set-variables              # agent'ın verdiği ID'leri sakla
        variables:
          - name: ctx_id
            value: "<? apiResponse.body.contextId ?>"
          - name: task_id
            value: "<? apiResponse.body.id ?>"
  - condition: "apiResponse.body.status.state == 'input-required'"   # agent soru soruyorsa
    actions:
      - type: message
        message:
          type: text
          content: "<? apiResponse.body.status.message.parts[0].text ?>"
  - condition: "apiResponse.body.status.state == 'completed'"        # iş bittiyse
    actions:
      - type: message
        message:
          type: text
          content: "<? apiResponse.body.artifacts[0].parts[0].text ?>"
```

İlk çağrıda ID'ler boştur. SAP Help'e göre bu boşluğu Joule kendisi yönetir, ayrıca kontrol yazmana gerek yok.

⚠️ `body` sözdizimi (tırnaklı JSON), `apiResponse.body.contextId` / `.id` / `.status.state` / `.status.message` yolları A2A 0.3.0 Task yapısından türetildi. SAP örneği bu yolları göstermiyor (doğrulanmadı). İlk denemede `result_variable`'ın tamamını mesajla bas: `content: "<? apiResponse ?>"` ve gerçek yapıyı gör.

### 5.4 Asenkron mod (60 saniyeyi aşan işler)

```yaml
body: >
  {
    "configurations": { "pushNotifications": true }
  }
```

Joule kendi webhook adresini agent'a verir. Agent iş bitince oraya haber atar. Bunun için Joule ile agent arasında **IAS App2App trust** kurulmuş olmalı (`04-kimlik-ias.md`). Joule booster bunu otomatik kurabiliyor.

---

## 6. Dialog function'da scripting

İki dil var:

| Dil | Sözdizimi | Nerede çalışır |
|---|---|---|
| **SpEL** (varsayılan) | `<? ifade ?>` | Her yerde: condition, body, path, headers, message, result |
| **Handlebars** | `{{ ifade }}` | Sadece `message` ve `set-variables` action'larında, `scripting_type: handlebars` yazarak |

Condition'lar **sadece SpEL** ile yazılır ve tırnak içinde, `<? ?>` olmadan:

```yaml
action_groups:
  - condition: "apiResponse.status_code == 200"    # başarılıysa
    actions:
      - type: message
        message:
          type: text
          content: "Tamam: <? apiResponse.body.artifacts[0].parts[0].text ?>"
  - condition: "apiResponse.status_code != 200"    # hata varsa
    actions:
      - type: message
        message:
          type: text
          content: "Agent şu an cevap vermiyor, birazdan tekrar dene."
```

Action group'lar yazıldığı sırayla çalışır. Condition'ı olmayan grup her zaman çalışır.

### 6.1 İşine yarayacak diğer action'lar

| Action | Ne yapar |
|---|---|
| `api-request` | Destination üzerinden HTTP çağrısı. Cevap en fazla 1 MB. Asenkron modda en fazla 5 dk |
| `set-variables` | Değişken atar |
| `message` | Kullanıcıya mesaj. Text dışında card, buttons, list, quick replies vb. |
| `status-update` | Uzun işte "çalışıyorum..." mesajı |
| `user-confirmation` | API'yi göndermeden önce kullanıcıdan onay al (jüri sever) |
| `dialog-function` | Başka bir function'ı çağırır, sonucu `result_variable`'a koyar |
| `file-upload` | Kullanıcıdan dosya ister (en fazla 10 dosya, dosya başı 10 MB) |
| `streamed-message` | SSE ile parça parça cevap akıtır |

Function'ın en altına `result:` bloğu yazarak çağıran tarafa ne döneceğini belirleyebilirsin:

```yaml
result:
  ozet: "<? apiResponse.body.artifacts[0].parts[0].text ?>"
```

---

## 7. Destination ve system alias

```
capability.sapdas.yaml                 BTP Cockpit → Connectivity → Destinations
──────────────────────                 ────────────────────────────────────────
system_aliases:                        Name:        SALES_AGENT      ← aynı
  SALES_AGENT:                         Type:        HTTP
    destination: SALES_AGENT  ───────► URL:         https://sales-agent.cfapps.eu10.hana.ondemand.com
                                       Proxy Type:  Internet
                                       Auth:        NoAuthentication (sadece demo!)
```

- Alias adı ile destination adı **büyük-küçük harf dahil** aynı olmalı.
- URL agent'ın kök adresi. Agent Card `/.well-known/agent-card.json` altında yayınlanır (`01-a2a.md`).
- `NoAuthentication` agent'ı internete açık bırakır. Demo dışında `OAuth2` / IAS kullan (`04-kimlik-ias.md`).
- Destination, Joule'nin bulunduğu subaccount'ta olmalı (doğrulanmadı, mantıksal çıkarım).

---

## 8. Derle, yükle, dene

### 8.1 Sandbox ile üretim farkı

| | Sandbox (kendi assistant'ın) | `sap_digital_assistant` |
|---|---|---|
| Ne | Senin adını verdiğin ayrı bir Joule kopyası | Tenant'ın asıl Joule'si, herkesin gördüğü |
| Nasıl yüklenir | `joule deploy -c -n oktay_sandbox` | `joule update sap_digital_assistant --capability-file ...` |
| Nasıl denenir | `joule launch oktay_sandbox` (web client açılır) | S/4, BTP cockpit vb. içindeki normal Joule penceresi |
| Kim yapabilir | `extensibility_developer` rolü | Extensibility developer bu isimle **deploy** edemez. Update için gereken rol belgede net değil (doğrulanmadı) |

**Benzetme:** Sandbox, mutfakta deneme tabağı. `sap_digital_assistant` ise menüye konan yemek.

### 8.2 Komutlar

```powershell
cd my_assistant                            # da.sapdas.yaml'ın olduğu klasör

joule lint                                 # YAML hatalarını deploy'dan önce yakala
joule compile                              # DTA → .daar dosyası (RTA) üretir
joule deploy -c -n oktay_sandbox           # derle + yükle tek adımda (-c = --compile)
joule launch oktay_sandbox                 # tarayıcıda test sohbeti açar
joule get oktay_sandbox                    # yüklü sürümü ve custom capability'leri gösterir

# Üretimdeki Joule'ye ekle (yetki gerekir)
joule update sap_digital_assistant --capability-file ./sales_capability/capability.sapdas.yaml

joule delete oktay_sandbox                 # test assistant'ını sil
```

Ek bilgi:
- `-d` (debug) eklersen ayrıntılı log görürsün.
- Aynı isimle tekrar deploy edersen yeni sürüm olur. Açık sohbetler eski sürümle biter, yeniler yenisiyle başlar.
- Tenant başına en fazla **30** assistant. `.daar` en fazla **50 MB**. Deploy 60 dakikada zaman aşımına düşer. Aynı assistant'a paralel deploy yapılamaz.
- `joule get` yalnız `joule.ext` namespace'li capability'leri gösterir.

### 8.3 Uçtan uca sıra (hackathon günü)

```
1. Agent CF'de çalışıyor mu?        curl https://<agent>/.well-known/agent-card.json
2. Destination açık mı?             BTP Cockpit → Destinations → "Check Connection"
3. joule login                       (bir kere)
4. joule lint
5. joule deploy -c -n <sandbox>
6. joule launch <sandbox>           → scenario'yu tetikleyen cümleyi yaz
7. Cevap boşsa                       content: "<? apiResponse ?>" ile ham cevabı gör
8. Çalışınca                         joule update sap_digital_assistant ... (izin varsa)
```

---

## 9. Takılma noktaları (belirti → sebep)

| Belirti | Sebep |
|---|---|
| `User is not authorized to deploy sap capabilities (5014)` | `namespace` `joule.ext` değil |
| `agent-request` tanınmıyor / derleme hatası | `schema_version` düşük, 3.28.0 yap |
| `AUTH_FETCH_TOKEN_FAILED` | Eski CLI'da `app_tid` hatası (`--no-app-tid` ekle) ya da SAP-managed uygulamada `--app-tid` eksik |
| 401 Unauthorized login'de | `app_tid` gereksiz yere gönderildi |
| `AUTH_LOAD_FAILED` | Auth URL veya API URL yanlış. API URL'yi UAA key'den almışsın |
| `Invalid URL format` | URL'de `https://` eksik veya tırnak hatası |
| `Request failed with status code 400` (IAS) | Kullanıcı adı veya şifre yanlış. 2FA varsa şifre+kod bitişik |
| `Client authentication failed` | Client ID/Secret yanlış veya IAS Dependency adı `Cli2Joule` değil |
| `FF_RETRIEVE_STATUS_ERROR` (403) | Kullanıcıda geliştirici rolü yok, sadece `end_user` |
| `AUTH_KEYTAR_UNAVAILABLE` | Linux/WSL'de keyring yok. Geçici: `--unsecure-storage` (önerilmez) |
| Login rastgele ağ hatası veriyor | Node 20+ IPv4/IPv6 seçimi, `NODE_OPTIONS=--no-network-family-autoselection` |
| `EEXIST ... bin/jl` kurulumda | Eski early-adopters paketi duruyor, önce kaldır |
| Deploy `sap_digital_assistant` adını reddediyor | Extensibility developer bu adla deploy edemez, `joule update` kullan |
| Assistant adı reddediliyor | 3-50 karakter, harf/rakam/alt çizgi, art arda `__` yok |
| Joule senin scenario'nu seçmiyor | Scenario `description`'ı zayıf veya başka scenario ile çakışıyor |
| Joule agent'ı bulamıyor | Destination adı ile `system_alias` birebir aynı değil |
| Joule cevabı boş gösteriyor | `artifacts[0].parts[0].text` yolu agent'ın cevabıyla uyuşmuyor, ya da task `input-required` döndü |
| "Zaman aşımı" | 60 sn senkron sınırı aşıldı, asenkron yap veya agent'ı hızlandır |
| Deploy "farklı major version" hatası | Aynı assistant'ta 2.x ve 3.x capability karışık |

---

## 10. Neleri bilmen lazım (kontrol listesi)

Bunları kendi cümlenle anlatabiliyorsan bu konu tamam:

- [ ] `@sap/joule-studio-cli` kurunca hangi iki komut gelir, farkları ne?
- [ ] `joule login` için IAS'ta ne açılır, Dependency adı ne olmalı?
- [ ] API URL nereden alınır, nereden alınmaz?
- [ ] `--no-app-tid` neden vardı, bugün hâlâ gerekli mi?
- [ ] Capability, scenario ve function ne işe yarar, hangisi "ne zaman", hangisi "ne"?
- [ ] `agent-request` action'ında hangi alanlar zorunlu, `agent_type` yazmazsan ne olur?
- [ ] Çok turlu konuşmada `contextId` ve `taskId` neden geri gönderilir?
- [ ] Sandbox assistant ile `sap_digital_assistant` arasındaki fark nedir, hangisine hangi komutla yüklenir?

---

## Kaynaklar

- SAP Help, Joule Development Guide: Install and Update the Joule Studio CLI. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/5270f042bdb2459fa2875e241ebae2e7.html
- SAP Help: joule login. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/39df3bfcaef74aefa2d274f3ad7c4b1d.html
- SAP Help: Authentication Backend Requirements (Cli2Joule, app_tid). https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/5853b3509b8747a3ad832d94e55507fd.html
- SAP Help: Login Error Examples and Steps to Fix Them. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/272d76d9b3e244ab94c5d2c0122d7e0d.html
- SAP Help: Design Time Artifact (DTA) Specification. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/c14658b5ed344cc0bf48736b1a45cf7b.html
- SAP Help: Code-Based Agents (Bring Your Own Agent). https://help.sap.com/docs/joule/joule-development-guide-ba88d1ec6a1b442098863d577c19b0c0/code-based-agents-bring-your-own-agent
- SAP Help: Action Group (tüm action tipleri). https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/70e471d4234b41e6b9b2b049fb0b514a.html
- SAP Help: Scripting (SpEL, Handlebars). https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/4d2675edb26049dc96900df2a10b9a9b.html
- SAP Help: joule compile. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/cb5f337e58df4335a71125106d8e7eb6.html
- SAP Help: joule deploy. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/58d63b66e82444d7a4c2bfd698fe838b.html
- SAP Help: Deploy the Runtime Artifact (limitler). https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/592582fab4bf4cd582342c7fb7aa099f.html
- SAP Help: joule launch. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/05d337b494a34615ab3142f80e1e49b7.html
- SAP Help: joule update. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/3d821b4ba9c34fb890f83fc51a8b2ba6.html
- SAP Help: Using an API Request Action for Document Retrieval. https://help.sap.com/docs/JOULE/ba88d1ec6a1b442098863d577c19b0c0/e204050912284ca698f3fc6634cf6b20.html
- SAP Architecture Center: Integrating AI Agents with Joule (Outbound A2A). https://architecture.learning.sap.com/docs/ref-arch/ae6821
- A2A Protocol 0.3.0 Specification. https://a2a-protocol.org/v0.3.0/specification/
- GitHub: https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent
- GitHub: https://github.com/SAP-samples/joule-a2a-agent-toolkit
- SAP Beyni notları: `ai/baglanti/joule-cli-login-sorunlari.md`, `ai/baglanti/custom-agent-joule-a2a-entegrasyonu.md`, `araclar/joule-pro-code-a2a.md`
