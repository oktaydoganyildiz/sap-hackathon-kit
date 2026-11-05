---
tur: konu
alan: ai
kategori: baglanti
urun_surumu: "joule-cli 2.0.2+"
tarih: 2026-10-10
guven: resmi
gozden_gecir: 2027-04-10
---

# Joule CLI login sorunları ve IAS client credentials kurulumu

## Özet
Joule, Cloud Identity Services (IAS) tabanlı login akışını kullanır; `joule-cli` ile bağlanmak için IAS tarafında ek bir application + "Cli2Joule" dependency + client secret oluşturmak gerekir. joule-cli 2.0.2 sürümünde varsayılan `joule login` komutu `app_tid` parametresi yüzünden başarısız olur; `--no-app-tid` flag'i geçici çözümdür.

## Ne zaman kullanılır
Joule pro-code extensibility (capability/scenario/function) geliştirip CLI üzerinden derleyip deploy etmeden önce; CI/CD pipeline'larında otomatik/scriptli login gerektiğinde.

## Tuzaklar
- Flagsiz `joule login`, joule-cli 2.0.2'de `session expired - refresh token is missing or invalid (AUTH_FETCH_TOKEN_FAILED)` hatası verir — ilk denemede doğrudan 401, bir sonraki komutta 400 olarak da görülebilir.
- IAS admin panelinde oluşturulan Dependency'nin adı tam olarak `Cli2Joule` olmalı; farklı bir isimle CLI eşleşmeyi bulamaz.
- Kullanıcıya yalnızca `end_user` rolü atanmışsa pro-code geliştirme için yetersizdir; `capability_admin` ve `extensibility_developer` rolleri de BTP subaccount'ta atanmalı.
- Capability namespace `joule.ext` değilse (ör. kendi şirket namespace'i) deploy sırasında "Tenant Administration Worker - 5014" yetkilendirme hatası alınır — tüm diğer namespace'ler "sap namespace" sayılır.

## Çözümler
- Her `joule login` çağrısına `--no-app-tid` flag'i ekleyin (IAS login sırasında `app_tid` parametresini atlar, akışı düzeltir):
```
joule login --no-app-tid
```
- Scripted/CI login için tüm parametreleri tek satırda flag olarak geçin:
```
joule login \
  -a https://<tenant-id>.accounts.ondemand.com \
  --apiurl https://<subdomain>.<region>.sapdas.cloud.sap \
  -c '<client-id>' \
  -s '<client-secret>' \
  -u felix.lastname@company.com \
  -p '<password>' \
  --store-password \
  --no-app-tid
```
- IAS tarafında adımlar: BTP subaccount'taki Trust Configuration'dan IAS tenant URL'sini al, sonuna `/admin` ekleyerek admin panele gir → Application & Resources > Applications > Create (OpenID Connect) → yeni app üzerinde Dependencies > Add, isim `Cli2Joule`, Joule application + API seç, Save → Client Authentication > Add ile Client Secret oluştur.
- BTP subaccount'ta kullanıcıya `end_user` rolüne ek olarak `capability_admin` ve `extensibility_developer` rollerini atayın.
- Multifactor/OTP kullanılan kullanıcılar için SAP Note 0003055323'e bakın.

## Tarifler
[[ai/baglanti/custom-agent-joule-a2a-entegrasyonu|Özel LangGraph ajanını A2A ile Joule'ye bağlama]]

## Sürüm notu
2026-02-16 tarihli kaynağa göre bu davranış joule-cli 2.0.2'de geçerli; CLI'nin varsayılan davranışı düzeltilene kadar `--no-app-tid` flag'i her login'de gereklidir. Daha yeni joule-cli sürümlerinde bu bug'ın giderilip giderilmediğini kontrol edin.

([[kaynaklar/2026-10-10-joule-a2a-connect-code-based-agents]])
