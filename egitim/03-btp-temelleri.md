# 03 · BTP Temelleri

> **Tek cümle:** BTP, agent'ımızın oturacağı "kiralık bina"dır. Subaccount daire, entitlement kira sözleşmesindeki hak listesi, Cloud Foundry ya da Kyma odadaki mobilya, destination da kapıdaki adres levhasıdır.

---

## 1. Neden var?

Agent'ı yazdık diyelim (detay `07-pro-code-agent.md`'de). Bir yerde 7/24 çalışması, LLM'e (AI Core) erişmesi ve Joule'nin onu bulabilmesi lazım. BTP bu üçünü tek çatı altında veriyor:

- **Çalıştırma yeri:** Cloud Foundry veya Kyma
- **Hazır servisler:** AI Core, Destination, HANA Cloud, IAS vb.
- **Adres defteri:** Destination service. Joule agent'ı buradan bulur.

**Benzetme:** BTP bir **iş merkezi**. Global account binanın tamamı, subaccount senin kiraladığın ofis, entitlement da sözleşmende "şu kadar toplantı odası, şu kadar otopark" diye yazan haklar. Hakkın yoksa servis menüde bile görünmez.

---

## 2. Hesap yapısı: global account → directory → subaccount

```
Global Account  (şirketin BTP sözleşmesi, faturanın geldiği yer)
   │
   ├── Directory "Hackathon"   (opsiyonel klasör, subaccount'ları gruplar)
   │      │
   │      ├── Subaccount "dev"   ── region: eu10 ── Cloud Foundry org + space
   │      └── Subaccount "demo"  ── region: us10 ── Kyma cluster
   │
   └── Subaccount "trial"   (trial hesabında genelde tek bir tane hazır gelir)
```

| Katman | Ne işe yarar | Hackathonda dokunur musun |
|---|---|---|
| **Global account** | Sözleşme, kota havuzu, fatura | Sadece entitlement dağıtmak için |
| **Directory** | Subaccount'ları gruplar, ortak kota/yetki verir | Muhtemelen hayır |
| **Subaccount** | Asıl çalışma alanı: region, runtime, servis, kullanıcı, trust | **Evet, her şey burada** |

**Kritik kural:** Subaccount bir **region**'a bağlıdır ve bu sonradan değişmez. Region, uygulamanın fiziksel olarak hangi veri merkezinde koşacağını belirler (`eu10` = Frankfurt, `us10` = ABD Doğu). Joule, AI Core ve agent'ın aynı region'da olması gecikmeyi ve sürprizleri azaltır. Bazı servisler (özellikle AI ile ilgili olanlar) her region'da yoktur; subaccount açmadan önce SAP Discovery Center'dan bak.

---

## 3. Entitlement ve quota: "hakkın var mı?"

- **Entitlement:** Global account'un hangi servisi, hangi **plan**la kullanabileceği. Örnek: `aicore` servisi, `extended` planı.
- **Quota:** O plandan kaç birim. Örnek: Cloud Foundry Runtime için 4 GB bellek.

Akış hep aynı:

```
Global account'ta entitlement var mı?
        │ evet
        ▼
Subaccount'a ATA (assign)  ──►  Service Marketplace'te görünür
        │                              │
        │                              ▼
        │                     Service instance oluştur
        ▼
   hayır ise: önce global account'a almak (satın almak / trial'da hazır olanlardan seçmek) gerekir
```

⚠️ **En sık hata:** "Marketplace'te AI Core yok." Sebep neredeyse her zaman entitlement'ın subaccount'a atanmamış olması. Servis kaybolmadı, sadece hakkı verilmedi.

---

## 4. Service Marketplace, instance, key, binding

Dört terim, sırayla birbirinin üstüne kurulur:

| Terim | Ne demek | Benzetme |
|---|---|---|
| **Service Marketplace** | Subaccount'ta kullanabileceğin servislerin vitrini | Menü |
| **Service instance** | O servisten senin için açılmış bir kopya | Sipariş ettiğin yemek |
| **Service key** | Instance'a dışarıdan (laptop'tan, script'ten) bağlanmak için kimlik bilgisi (URL, client ID, secret) | Garsonun verdiği masa numarası ve fiş |
| **Binding** | Instance'ın bir uygulamaya bağlanması. Kimlik bilgisi uygulamanın ortam değişkenine (`VCAP_SERVICES`) otomatik konur | Yemeğin doğrudan senin masana gelmesi |

**Ne zaman hangisi:**
- Agent **BTP'de** koşuyorsa → **binding**. Kod şifreyi ortam değişkeninden okur, kimse kopyalamaz.
- Agent'ı **laptop'ta** test ediyorsan → **service key**. JSON'u indirir, `.env`'e koyarsın. Asla repoya commit etme.

---

## 5. Cloud Foundry mi Kyma mı?

BTP'de uygulama çalıştırmanın iki ana yolu var. SAP'nin pro-code agent mimarisi ikisini de destekliyor.

| | **Cloud Foundry (CF)** | **Kyma** |
|---|---|---|
| Ne | Hazır platform: kodu ver, gerisini o halleder | Yönetilen Kubernetes |
| Deploy | `cf push` (tek app) veya `cf deploy` (MTA) | `kubectl apply -f` ile YAML'lar |
| Paketleme | Kod + `manifest.yml` (buildpack ile build edilir) | Container image (Podman/Docker ile build) |
| Öğrenme eğrisi | Düşük | Yüksek |
| Esneklik | Orta | Çok yüksek |
| Trial süresi | Trial hesabıyla aynı (90 gün) | **30 gün**, sonra cluster silinir |
| Hackathon için | ⭐ **Varsayılan seçim** | Ekipte Kubernetes bilen varsa |

**Akılda tutma cümlesi:** *CF'de uygulamayı verirsin, Kyma'da uygulamanın kutusunu (container) verirsin.*

SAP'nin referans örneği (`btp-joule-a2a-pro-code-agent`) CF'ye deploy ediyor. Checklist'te Podman ve kubectl olması Kyma seçeneğinin de açık tutulduğunu gösteriyor.

### 5.1 Cloud Foundry: org, space, app

```
Subaccount
   └── CF org  (subaccount'ta CF'yi açınca bir tane oluşur)
          ├── space "dev"    ── app: currency-agent, service instance: aicore
          └── space "prod"
```

- **Org:** Subaccount başına bir tane. Kotalar burada.
- **Space:** Org içindeki çalışma odası. App ve service instance'lar space'e aittir. Binding sadece **aynı space**'teki app ile instance arasında yapılır.

### 5.2 `manifest.yml`: tek app için

`cf push` bu dosyayı okur. Agent için tipik hali:

```yaml
---
applications:
- name: currency-agent           # route'un başı da bu olur
  memory: 512M                   # trial'da toplam 4 GB var, cömert olma
  buildpacks:
  - python_buildpack
  command: python -m app         # agent'ı başlatan komut
  health-check-type: http
  health-check-http-endpoint: /.well-known/agent-card.json   # agent ayaktaysa kart döner
  services:
  - aicore                       # bu instance'a otomatik binding yapılır
  env:
    LOG_LEVEL: info              # şifre KOYMA, şifreler binding'den gelir
```

### 5.3 MTA ve `mbt`: birden çok parça için

Agent + webhook sunucusu + birkaç servis instance'ı varsa tek tek `cf push` yerine hepsini tek pakette tarif edersin:

- **`mta.yaml`**: modüller (app'ler) ve kaynaklar (servisler) listesi
- **`mbt build`**: bunu `.mtar` arşivine paketler
- **`cf deploy`**: arşivi kurar, eksik servisleri de açar (multiapps plugin'i gerekir)

CAP ile yazılmış agent'lar genelde MTA ile gelir. Python + LangGraph tek app ise `manifest.yml` yeter.

### 5.4 Kyma: Kubernetes

Kyma'da agent bir **container image** olur. Podman ile build edip bir registry'ye itersin, sonra Kubernetes'e "bunu çalıştır" dersin:

```bash
podman build -t <registry>/currency-agent:1.0 .     # image'ı oluştur
podman push <registry>/currency-agent:1.0           # registry'ye gönder
kubectl apply -f deployment.yaml                    # Deployment + Service + APIRule
kubectl get pods                                    # ayakta mı
kubectl logs deploy/currency-agent                  # log
```

Kubeconfig dosyası Kyma dashboard'undan indirilir (doğrulanmadı: trial'da OIDC login için `kubelogin` eklentisi gerekebilir). Dışarıya açmak için Kyma'nın `APIRule` kaynağı kullanılır.

---

## 6. Destination service: Joule'nin adres defteri

**Destination**, bir hedef sistemin **adresi + nasıl giriş yapılacağı** bilgisinin tek bir isim altında saklanmasıdır. Kod "şu URL'e şu şifreyle bağlan" demez, "`CURRENCY_AGENT` destination'ına git" der.

**Benzetme:** Telefon rehberindeki kayıt. Numarayı ezberlemezsin, "Annem"e basarsın. Numara değişirse rehberi güncellersin, kodu değil.

Bizim senaryoda en önemli destination, **Joule'nin agent'ımızı bulduğu** destination'dır (bkz. `01-a2a.md`, bölüm 4.1):

```
Joule  ──► system_alias: CURRENCY_AGENT
              │
              ▼
       BTP Destination "CURRENCY_AGENT"
       URL = https://currency-agent.cfapps.eu10.hana.ondemand.com
       ProxyType = Internet
       Authentication = ...   (bkz. 6.2)
              │
              ▼
       Bizim agent (CF'de)
```

### 6.1 Temel alanlar

| Alan | Ne | Örnek |
|---|---|---|
| `Name` | Destination adı. Joule'deki `system_aliases.<X>.destination` ile **birebir** aynı | `CURRENCY_AGENT` |
| `Type` | Protokol türü. Agent için hep `HTTP` | `HTTP` |
| `URL` | Hedef adres | `https://...cfapps.eu10.hana.ondemand.com` |
| `ProxyType` | Trafik nereden geçecek | `Internet` |
| `Authentication` | Nasıl giriş yapılacak | `NoAuthentication` |

**ProxyType üç değer alır:**
- **`Internet`**: Hedef internette (bizim CF agent'ı, S/4HANA Cloud). Varsayılan.
- **`OnPremise`**: Hedef şirketin içinde, Cloud Connector üzerinden gidilir.
- **`PrivateLink`**: Hedef, müşterinin kendi hyperscaler hesabında, özel bağlantıyla.

### 6.2 Authentication türleri (hackathon için önemli olanlar)

Destination service on beşten fazla tür destekliyor. Bize lazım olan dördü:

| Tür | Ne yapar | Ne zaman |
|---|---|---|
| **`NoAuthentication`** | Hiç token göndermez | Sadece demo. Agent'ın URL'ini bilen herkes çağırabilir |
| **`OAuth2ClientCredentials`** | Teknik kullanıcıyla (client ID + secret) token alır, onu gönderir | "Joule'den gelen her istek aynı teknik kullanıcı" yeterliyse |
| **`OAuth2SAMLBearerAssertion`** | Gerçek kullanıcının kimliğini SAML assertion'a çevirip hedef sistemden token alır | Agent → S/4HANA çağrısında **principal propagation** için |
| **`OAuth2JWTBearer`** / **`OAuth2TokenExchange`** | Gelen kullanıcı token'ını hedef için yeni token'la değiştirir | Kullanıcı bağlamını IAS üzerinden taşımak için |

SAP Beyni'ndeki saha notu: Joule → agent destination'ı için örneklerde `NoAuthentication` veya `OAuth2ClientCredentials` kullanılıyor. Kullanıcı kimliğinin agent'a nasıl taşındığı (App2App, token exchange) `04-kimlik-ias.md`'de.

### 6.3 Örnek: Agent → S/4HANA, kullanıcı kimliğiyle

```
Name=S4_API
Type=HTTP
ProxyType=Internet
Authentication=OAuth2SAMLBearerAssertion
URL=https://my3xxxxx-api.s4hana.cloud.sap
Audience=https://my3xxxxx.s4hana.cloud.sap
Token Service URL=https://my3xxxxx-api.s4hana.cloud.sap/sap/bc/sec/oauth2/token
# Token Service User / Password: S/4 communication user. Burada YAZMA, cockpit'e gir.

# Ek özellik: IAS token'ını doğrulamak için zorunlu
x_user_token.jwks_uri=https://<ias-tenant>.accounts.ondemand.com/oauth2/certs
```

⚠️ `x_user_token.jwks_uri` eksikse destination **hata vermeden** teknik kullanıcıya düşer. Yani çağrı çalışır ama yanlış kişi adına çalışır. Demoda fark etmezsin, jüri "bu kimin yetkisiyle?" diye sorunca fark edersin.

---

## 7. Cloud Connector (tek paragraf)

**Cloud Connector**, şirket içindeki (on-premise) bir sisteme, örneğin BW/4HANA'ya veya on-prem S/4'e, BTP'den güvenli erişim sağlayan küçük bir yazılımdır. Şirket ağının içine kurulur ve BTP'ye **içeriden dışarıya** bir tünel açar; dışarıdan şirkete port açmak gerekmez. Destination'da `ProxyType=OnPremise` dediğinde trafik bu tünelden geçer, hedef adres de Cloud Connector'da tanımlanan **sanal host** olur. Trial hesapta 2 on-premise sistem bağlanabiliyor. Hackathonda büyük ihtimalle cloud sistemlerle (S/4HANA Cloud, Datasphere) çalışacağız, yani Cloud Connector'a gerek kalmaz.

---

## 8. BTP trial: limitler

Checklist'teki trial hesap (`account.hanatrial.ondemand.com`) ücretsiz ama kısıtlı. Bilmen gerekenler:

- **Süre:** 90 gün. 30 gün giriş yapmazsan hesap askıya alınır, sonra silinir.
- **Kyma trial:** Ayrıca **30 gün**. Süre bitince cluster ve içindeki veri silinir, uzatılamaz.
- **Bellek:** Uygulamalar için toplam **4 GB**.
- **Limitler:** Toplam 10 route ve 40 servis instance'ı.
- **Gece durdurma:** Uygulamalar her gece, region saatine göre gece yarısı **otomatik durur**. Sabah `cf start` gerekir. ABD region'ında açtıysan bu Avrupa'da gündüze denk gelebilir.
- **SLA yok**, ticari kullanım yasak, takım geliştirmesi için değil.
- Trial'da bir **SAP Cloud Identity Services trial tenant'ı** alınabiliyor.
- Joule ve AI Core'un trial'da hangi planla açık olduğu belli değil (doğrulanmadı). Hackathonda büyük ihtimalle organizatörün verdiği hazır subaccount'lar kullanılacak (doğrulanmadı).

⚠️ **Demo günü kuralı:** Sunumdan önce `cf apps` ile agent'ın `started` olduğunu kontrol et. Gece durdurma demoyu öldürebilir.

---

## 9. CLI komutları: agent geliştiricisinin bilmesi gerekenler

İki CLI var, işleri bölüşmüşler:
- **`btp` CLI**: global account ve subaccount işleri (entitlement, subaccount, servis instance, rol).
- **`cf` CLI**: Cloud Foundry org/space içi işler (push, log, binding).

### 9.1 `btp` CLI

```bash
# Giriş: tarayıcıda SSO açılır. Subdomain'i cockpit'te global account sayfasında görürsün.
btp login --sso --url https://cli.btp.cloud.sap --subdomain <global-account-subdomain>

btp list accounts/subaccount                       # subaccount'ları listele
btp target --subaccount <subaccount-id>            # bundan sonraki komutlar bu subaccount'a gitsin

btp list accounts/entitlement                      # global account'taki haklar ve kotalar
btp list accounts/entitlement --subaccount <id>    # bu subaccount'a ne atanmış

# Subaccount'a hak ata (örn. AI Core extended planı)
btp assign accounts/entitlement --to-subaccount <id> --for-service aicore --plan extended --amount 1

btp list services/offering                         # marketplace'te ne var
btp list services/instance                         # açılmış instance'lar
btp list accounts/subscription --subaccount <id>   # abone olunan SaaS'lar (Joule, Build vb.)

# CF'yi subaccount'ta aç (CF org oluşur)
btp create accounts/environment-instance --subaccount <id> --display-name dev --environment cloudfoundry

# Kullanıcıya rol koleksiyonu ver
btp assign security/role-collection "Subaccount Administrator" --to-user <mail> --create-user-if-missing
```

`btp create services/instance` ile CLI'dan instance da açılabilir. Parametreler (`--offering-name`, `--plan-name`, `--name`) için `btp create services/instance --help` (doğrulanmadı). CF içinde çalışıyorsan `cf create-service` daha pratik.

### 9.2 `cf` CLI

```bash
# Giriş. API adresi region'a göre değişir, cockpit'te subaccount Overview'da yazar.
cf login -a https://api.cf.eu10.hana.ondemand.com --sso
cf target -o <org> -s dev                     # hangi org ve space'te çalışacağız

cf marketplace                                # bu space'te açılabilen servisler
cf marketplace -e aicore                      # aicore'un planları

cf create-service aicore extended aicore      # instance aç: servis, plan, ad
cf create-service-key aicore aicore-key       # laptop'tan test için key üret
cf service-key aicore aicore-key              # key'i göster (çıktıyı repoya KOYMA)

cf push                                       # manifest.yml'deki app'i deploy et
cf push -f manifest.yml --vars-file vars.yml  # değişkenli manifest

cf bind-service currency-agent aicore         # manifest'te yoksa elle bağla
cf restage currency-agent                     # bağlamadan sonra şart

cf apps                                       # app'ler ve durumları
cf logs currency-agent --recent               # son loglar, ilk bakılacak yer
cf logs currency-agent                        # canlı log akışı (demo sırasında açık tut)
cf env currency-agent                         # VCAP_SERVICES dahil ortam değişkenleri

# MTA ile
mbt build
cf deploy mta_archives/<app>_1.0.0.mtar
```

---

## 10. Takılma noktaları (hata → sebep)

| Belirti | Sebep |
|---|---|
| Servis Marketplace'te görünmüyor | Entitlement subaccount'a atanmamış |
| `cf create-service` → `service plan not available` | Plan entitle edilmemiş veya org kotası yok |
| `cf push` → bellek hatası | Trial'da toplam 4 GB doldu; `memory` değerini düşür veya eski app'i sil |
| Sabah agent cevap vermiyor | Trial gece durdurması; `cf start <app>` |
| Joule "agent'a ulaşılamadı" | Destination URL yanlış, app durmuş veya destination adı `system_alias` ile aynı değil |
| Agent S/4'ü çağırıyor ama hep aynı kullanıcı görünüyor | `OAuth2SAMLBearerAssertion` destination'ında `x_user_token.jwks_uri` eksik, teknik kullanıcıya düşmüş |
| `bind-service` sonrası app hâlâ credential bulamıyor | `cf restage` yapılmadı |
| `cf deploy` → `unknown command` | multiapps plugin'i kurulu değil |
| `btp` → `Unknown session` | Oturum düştü; `btp login --sso` ile tekrar gir |
| Kyma cluster birden yok oldu | Kyma trial 30 günü doldu |

---

## 11. Neleri bilmen lazım (kontrol listesi)

Bunları kendi cümlenle anlatabiliyorsan bu konu tamam:

- [ ] Global account, directory ve subaccount farkı nedir? Region hangisine bağlı?
- [ ] Entitlement ile quota farkı nedir? Servis marketplace'te görünmüyorsa ilk neye bakarsın?
- [ ] Service key ile binding ne zaman kullanılır?
- [ ] Cloud Foundry ile Kyma arasındaki temel fark nedir? Hackathonda neden CF varsayılan?
- [ ] `manifest.yml` ile `mta.yaml` arasındaki fark nedir?
- [ ] Destination nedir, Joule tarafındaki hangi alanla eşleşmek zorunda?
- [ ] `NoAuthentication`, `OAuth2ClientCredentials` ve `OAuth2SAMLBearerAssertion` ne zaman kullanılır?
- [ ] Trial hesabın demo gününü bozabilecek iki limiti hangisi?

---

## Kaynaklar

- SAP Help: Trial Accounts and Free Tier (trial limitleri). https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/046f127f2a614438b616ccfc575fdb16.html
- SAP Help: Setting Up a Trial Account From the Command Line (btp + cf komut sırası). https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/a21360fa19714751a7c49c796d39ac3d.html
- SAP Help: About the Trial Kyma Instance (30 gün). https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/c4fff0f58f90424f8e0af28975ac7f0f.html
- SAP Help: Working with Resources of the SAP Service Manager Using the btp CLI. https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/fe6a53bfe48e4831b2f5ae7f06d4f07d.html
- btp CLI Command Reference. https://help.sap.com/docs/BTP/btp-cli/intro.html
- SAP Connectivity: HTTP Destinations (ProxyType, authentication türleri). https://github.com/SAP-docs/btp-connectivity/blob/main/docs/1-connectivity-documentation/http-destinations-42a0e6b.md
- SAP Connectivity: Destination Examples (OAuth2SAMLBearerAssertion). https://github.com/SAP-docs/btp-connectivity/blob/main/docs/1-connectivity-documentation/destination-examples-3a2d575.md
- SAP Architecture Center: Custom Pro-Code AI Agents on a Customer-Managed Subaccount. https://architecture.learning.sap.com/docs/ref-arch/7b6426
- Cloud Foundry CLI v8. https://github.com/cloudfoundry/cli/wiki/V8-CLI-Installation-Guide
- GitHub: https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent (Terraform ile subaccount, CF, IAS trust, AI Core kurulumu)
- SAP Beyni notları: `ai/baglanti/joule-a2a-mcp-gateway-s4-principal-propagation.md`, `ai/baglanti/custom-agent-joule-a2a-entegrasyonu.md`, `dersler/2026-10-16-btp-cli-sso-giris-ile-subaccount-ve-integration-suite-entitl.md`, `araclar/btp-joule-a2a-pro-code-agent.md`
