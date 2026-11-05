---
tur: tarif
alan: btp
kategori: baglanti
urun_surumu: ""
tarih: 2026-10-19
guven: topluluk
gozden_gecir: 2027-04-19
---

# BTP → ABAP Principal Propagation: Cloud Connector Sertifika + CERTRULE ile Çoklu E-posta Eşlemesi

## Use case
BTP'de bir approuter/CAP uygulaması, Cloud Connector üzerinden on-premise ABAP sistemine principal propagation ile bağlanıyor (teknik kullanıcı/ikinci şifre yok). Aynı kişi farklı BTP uygulamalarına farklı e-posta adresleriyle girebiliyor; hepsi ABAP tarafında aynı tek SAP kullanıcısına düşmeli. USREXTID/gateway mapping tablosu yerine ABAP CERTRULE (rule-based certificate mapping) ile, SU01'deki e-posta eşleşen herkes otomatik, geri kalanlar istisna listesiyle eşlenir.

## Varyantlar

### Cloud Connector sertifika (subject pattern + CA) + ABAP CERTRULE kuralı

**1. BTP tarafı (subaccount + destination)**
- Subaccount → Security → Trust Configuration → Establish Trust (Identity Authentication tenant'ını custom IdP olarak ekle).
- Üç servis instance: XSUAA (plan `application`), Destination (`lite`), Connectivity (`lite`).
- Destination: tip `HTTP`, proxy type `OnPremise`, authentication `PrincipalPropagation`, URL = Cloud Connector'ın expose edeceği virtual host:port (`http://` ile).

**2. ABAP tarafı — test servisi (ICF handler, sy-uname döner)**
```abap
CLASS zcl_poc_whoami DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_extension.
ENDCLASS.
CLASS zcl_poc_whoami IMPLEMENTATION.
  METHOD if_http_extension~handle_request.
    server->response->set_content_type( 'application/json' ).
    server->response->set_cdata(
      |\{ "abapUser": "{ sy-uname }", "client": "{ sy-mandt }" \}| ).
    server->response->set_status( code = 200 reason = 'OK' ).
  ENDMETHOD.
ENDCLASS.
```
SICF'te `/default_host/sap/bc/zpoc_whoami` node'u, bu class handler olarak, servis aktif — logon verisi saklanmaz, her çağrı authenticate olmak zorunda.

**3. Cloud Connector — sistem mapping + resource**
| Alan | Değer |
|---|---|
| Back-end type | ABAP System |
| Protocol | HTTPS |
| Internal host:port | ICM'in gerçek sunucu sertifikasındaki **tam** host adı (örn. `vhcala4hci.dummy.nodomain:50001`) |
| Virtual host:port | Destination'ın işaret ettiği değer |
| Principal type | X.509 Certificate |
| Resource | `/sap/bc/zpoc_whoami`, path+sub-paths |

- Principal Propagation sekmesinde **Synchronize**: subaccount'un trust config'indeki IdP'leri (token servisi + Identity Authentication) okur ve güvenir.
- **System certificate** (Cloud Connector'ın kendi kimliği, TLS handshake'te sunulur) ve **CA certificate** (kullanıcı başına kısa ömürlü sertifikaları imzalar) — test için self-signed, prod'da kurumsal PKI.
- **Subject pattern**: `CN=${email},O=POC,C=AU`, geçerlilik 60 dk. `${email}` token'daki e-posta attribute'undan doldurulur.
- Backend Trust Store'a ABAP ICM'in SSL server (Standard) PSE sertifikası eklenir (STRUST → export Base64 → Cloud Connector'a import).

**4. ABAP tarafı — Cloud Connector'a güven**
- STRUST: Cloud Connector'ın system certificate'ı, SSL server Standard PSE'nin **Certificate List**'ine eklenir (Add to Certificate List + save; ICM otomatik re-read eder, restart gerekmez).
- `icm/trusted_reverse_proxy_0` (RZ11'de doğrudan değiştirilemez, SMICM → Parameter Changes üzerinden; profile'a da yazılmalı — aksi halde ICM restart'ında kaybolur):
```
icm/trusted_reverse_proxy_0 = SUBJECT="CN=SCC-A4H-SYSTEM, O=POC, C=AU", ISSUER="CN=SCC-A4H-SYSTEM, O=POC, C=AU"
```
STRUST'ta gösterilen subject/issuer'ı virgülden sonraki boşluklar dahil **birebir** kopyala.
- `login/certificate_mapping_rulebased = 1` (dynamic parametre, RZ11; kalıcı olması için profile'a da yaz).

**5. CERTRULE — kural ve istisna**
1. SU01'de JSMITH gibi bir kullanıcının Address sekmesine e-posta gir (şifresiz dialog user mümkün — "Password deactivated", yalnız SSO ile giriş).
2. CERTRULE change mode → sample sertifika import et (Cloud Connector'da "create sample certificate" ile üretilebilir) → **Rule**: certificate attribute = CN, Login As = E-Mail; Subject Filter alanı serbest metin değildir, önerilen `O,C` değerleriyle bırak (örn. sonuç: subject filter `CN=*,O=POC,C=AU`, issuer filter `CN=SCC-A4H-CA,O=POC,C=AU`). Save — status alanı yalnız kayıttan sonra günceli gösterir.
3. Master'da e-postası olmayan kişiler için (ör. ikinci adres veya dış kullanıcı): aynı sample sertifika üzerinden **Explicit Mapping** seç, hedef ABAP kullanıcıyı gir. Kuralla zaten eşleşen bir adrese istisna eklenmeye çalışılırsa CERTRULE "You do not have to create an exception" uyarısı verir.
4. Explicit mapping, kuralın önüne geçer (öncelik sırası: önce istisna, sonra kural).

**Doğrulanan senaryolar:**
- İki farklı kullanıcı, iki farklı e-posta → biri kuralla, biri istisnayla → iki farklı SAP kullanıcısı.
- Aynı kişi, iki BTP uygulaması, iki e-posta (biri SU01'de, diğeri istisna ile aynı SAP kullanıcısına eşlenmiş) → her iki çağrı da aynı SAP kullanıcısı olarak ABAP'a düşer; uygulama tarafında ek bir şey yapılmaz, ABAP'ta sadece bir istisna satırı eklenir.

**Ne zaman seçilir:** Birden fazla BTP uygulaması ve kullanıcı başına birden fazla e-posta/identity olan landscape'lerde; bakım yükünü "kullanıcı × uygulama" yerine yalnız istisna sayısına indirmek istendiğinde. Tek uygulama / tek e-posta senaryosunda klasik gateway + USREXTID/EXTID_DN mapping tablosu da yeterli olabilir.

([[kaynaklar/2026-10-19-certrule-principal-propagation]])

## Tuzaklar
- **Sertifika subject/host uyumsuzluğu**: Cloud Connector'daki "internal host" ABAP sunucu sertifikasındaki host adıyla **tam** eşleşmeli; eşleşmezse tarayıcıda yalnız düz metin "Invalid server certificate" görülür (ABAP tarafında hiçbir iz yok) — SAP KBA 3084008.
- `icm/trusted_reverse_proxy_0` değeri STRUST'taki subject/issuer ile virgül sonrası boşluklar dahil birebir aynı olmalı; yanlışsa ICM trace'inde "intermediary is NOT trusted" / "Reject untrusted forwarded certificate" görülür (SAP KBA 3017609).
- **Tarayıcı oturumu zehirlenmesi**: başarısız bir sertifika logonu sonrası ABAP `sap-ssolist` cookie'si ile "bu client için sertifika zaten reddedildi" bilgisini saklar; aynı sekmede/reload ile tekrar denemek sorunu çözse bile hep 401 döner — her testi **yeni bir private/incognito pencerede** yapın.
- CERTRULE Subject Filter alanı serbest metin değil, input help'ten seçilen kalan attribute listesidir (`CN=*` elle yazılamaz); yine de yalnız CN'li bir subject ile kural çalışır, O/C eklemek kuralı yalnızca daraltır.
- CERTRULE ekranı "persistence"e dayalı durum gösterir — kural/istisna değerlendirmesini **Save**'den sonra yap.
- Dinamik parametreler (`login/certificate_mapping_rulebased`, `icm/trusted_reverse_proxy_0`) SMICM/RZ11 üzerinden set edilirse ICM restart'ında kaybolur; kalıcılık için profile parametresi olarak da girilmeli.
- Sistem saati geride kalan test ortamlarında (ör. uyku modundan çıkan Docker sistemi) yeni oluşturulan kısa ömürlü sertifikalar "not yet valid" sayılabilir — work process trace'de timestamp-check hataları arayın.

## Cevapladığı sorular
- BTP uygulamasından on-premise ABAP sistemine principal propagation kurarken Cloud Connector sertifika ve CERTRULE ile çoklu e-mail adresiyle tek SAP kullanıcı eşlemesi nasıl yapılır?
- ABAP'ta USREXTID/gateway mapping tablosu yerine rule-based certificate mapping (CERTRULE) nasıl kurulur?
- Principal propagation'da "Invalid server certificate" ve 401 password popup hataları nasıl teşhis edilir?
- Bir kişinin birden fazla e-posta adresi/identity'si tek bir SAP kullanıcısına nasıl eşlenir?

## İlgili
- SAP KBA 3084008 — Cloud Connector "Invalid server certificate" (internal host uyumsuzluğu)
- SAP KBA 3017609 — principal propagation "intermediary is NOT trusted"
- SAP Help Portal: Cloud Connector "Configuring Principal Propagation"
- SAP Help Portal: ABAP Platform "Rule-Based Certificate Mapping" (CERTRULE)
