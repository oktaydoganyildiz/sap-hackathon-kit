---
tur: tarif
alan: btp
kategori: guvenlik
urun_surumu: "CAP 9.6, BTP Trial"
tarih: 2026-10-19
guven: topluluk
gozden_gecir: 2027-04-19
---

# CAP servisine XSUAA ile rol bazlı güvenlik ve role collection kurulumu

## Use case
Varsayılan olarak `"auth": "none"` ile açık (kimliği doğrulanmamış herkese açık) bir CAP Node.js servisini, CDS modeli üzerinden tanımlanan rollerle (Viewer/Admin gibi) XSUAA'ya bağlayıp, approuter ve BTP Cockpit role collection'ları ile uçtan uca güvenli hale getirmek.

## Varyantlar

### cds add xsuaa + @restrict/@requires + approuter + cockpit role collection
Adımlar:
1. CF'e login ol ve org/space hedefle:
```bash
cf login -a https://api.cf.us10-001.hana.ondemand.com --sso
cf target -o <trial-org> -s dev
```
2. XSUAA desteğini ekle:
```bash
cds add xsuaa
```
   Bu komut üç şeyi değiştirir: boş bir `xs-security.json`, `mta.yaml`'a bir xsuaa resource, ve `package.json`'da bir production profili:
```json
"[production]": { "auth": "xsuaa" }
```
   Local `cds watch` login'siz çalışmaya devam eder; CF'de `NODE_ENV=production` token kontrolünü devreye sokar.
3. CDS modelinde rolleri tanımla (`srv/logistics-service.cds` örneği):
```cds
service LogisticsService @(path: '/logistics') {

    // Viewer okuyabilir, Admin her şeyi yapabilir
    @restrict: [
        { grant: 'READ', to: 'Viewer' },
        { grant: '*',    to: 'Admin'  }
    ]
    entity Shipments as projection on my.Shipments;

    // salt-okunur entity, her iki rol de görebilir
    @readonly
    @requires: ['Viewer', 'Admin']
    entity Packages as projection on my.Packages;
}
```
4. Rol şablonlarını modelden üret:
```bash
cds compile srv --to xsuaa > xs-security.json
```
   İki scope (`$XSAPPNAME.Viewer`, `$XSAPPNAME.Admin`) ve iki role template oluşur; `$XSAPPNAME` deploy anında gerçek değerle değiştirilir.
5. Approuter ekle:
```bash
cds add approuter
```
   `app/router/` klasörü oluşur. Approuter olmadan tarayıcı sadece 401 alır — servis zaten token taşıyan isteklere izin verir. Approuter login akışını yürütüp token'ı iletir (`forwardAuthToken: true`).
6. `mta.yaml` kullanmadan `cf push` ile deploy edilecekse, xsappname ve redirect-uri'ler `xs-security.json`'ın başına elle eklenmeli:
```json
"xsappname": "c-cpe-dev",
"tenant-mode": "dedicated",
"oauth2-configuration": {
  "redirect-uris": ["https://*.cfapps.us10-001.hana.ondemand.com/**"]
},
```
7. XSUAA instance oluştur:
```bash
cf create-service xsuaa application c-cpe-auth -c xs-security.json
```
8. Servisi build edip bind et ve mevcut route/HDI binding'i koruyarak üzerine push et:
```bash
npx cds build --production
cf bind-service <srv-app> c-cpe-auth
cf push <srv-app> -p gen/srv -b nodejs_buildpack -m 256M
```
9. Token olmadan çağrı 401 döner (kontrol):
```bash
curl -s -o /dev/null -w "%{http_code}\n" https://<srv-route>/logistics/Shipments
# 401
```
10. Approuter'ı deploy et. `default-env.json` lokal çalışma için `localhost:4004`'e işaret ettiğinden yüklemeye dahil edilmemeli:
```bash
cd app/router
printf 'default-env.json\nnode_modules\n' > .cfignore
cf push cpe-router -b nodejs_buildpack -m 256M --random-route --no-start
cf bind-service cpe-router c-cpe-auth
# approuter'ın yönlendireceği destination - CAP servis route'u
cf set-env cpe-router destinations '[{"name":"srv-api","url":"https://<srv-route>","forwardAuthToken":true}]'
cf start cpe-router
```
11. BTP Cockpit'te Subaccount > Security > Roles altında `c-cpe` ile ara; `c-cpe-dev` uygulaması altında `Admin` ve `Viewer` rolleri (CAP'ten üretilmiş, açıklaması "generated") görünür.
12. Security > Role Collections > Create ile iki role collection oluştur (ör. `CPE Viewer`, `CPE Admin`).
13. Her collection'ı aç, Edit > Roles > value help'te Application Identifier'ı `c-cpe-dev!t<id>` ile filtrele (BTP rol adına `!t` suffix'i ekler), ilgili rolü işaretle, Add.
14. Users sekmesinde kullanıcının e-postasını hem ID hem E-Mail alanına gir, Default identity provider'ı seç, Save.
15. Sonuç: `CPE Viewer` collection'ı Viewer rolü ve bir kullanıcıyla, `CPE Admin` collection'ı Admin rolü ve başka bir kullanıcıyla eşleşir; approuter üzerinden giriş yapan kullanıcı rolüne göre yetkilendirilir.

Ne zaman seçilir: BTP trial veya herhangi bir CF ortamında, mta.yaml kullanmadan düz `cf push` ile CAP servisine XSUAA tabanlı rol/scope güvenliği ve approuter akışı tek seferde kurulacağında; rolleri elle xs-security.json'da yazmak yerine CDS modelinden (`@restrict`/`@requires`) otomatik türetmek istendiğinde.

([[kaynaklar/2026-10-19-cap-xsuaa-trial-security]])

## Tuzaklar
- `xs-security.json`'daki `xsappname` mta.yaml kullanılmadığında elle eklenmezse, deploy sonrası scope/role adları `$XSAPPNAME` placeholder'ı ile eşleşmez ve rol ataması çalışmaz.
- `redirect-uris` approuter'ın gerçek route'uyla (wildcard dahil) eşleşmezse login sonrası yönlendirme başarısız olur.
- BTP Cockpit'te Role Collections > Roles value help'inde Application Identifier aranırken BTP'nin otomatik eklediği `!t<id>` suffix'i unutulursa (sadece `c-cpe-dev` aranırsa) rol bulunamaz; suffix'i içeren tam adla (`c-cpe-dev!t<id>`) filtrelemek gerekir.
- `app/router/default-env.json` dosyası CF'e push edilirken `.cfignore` ile hariç tutulmazsa, production'da yanlışlıkla `localhost:4004` hedefine işaret ederek approuter'ın servise ulaşmasını engelleyebilir.
- Approuter olmadan servise direkt tarayıcıdan gidilirse sadece 401 alınır; approuter login akışını ve token forward etmeyi (`forwardAuthToken: true`) üstlenir, bu adım atlanamaz.
- Local `cds watch` ile test ederken `NODE_ENV=production` set edilmediği için auth kontrolü devre dışıdır; bu, güvenliğin gerçekten çalıştığının yanlış bir izlenimine yol açabilir — gerçek test CF'de yapılmalı.

## Cevapladığı sorular
- CAP uygulamasına BTP'de CDS rol tanımı ve XSUAA ile kimlik doğrulaması nasıl uygulanır?

## İlgili
- ([[btp/baglanti/cap-nodejs-mcp-ile-dis-api-acma|CAP Node.js servisini hem OData hem MCP ile dış SAP API'sine bağlama]])
- ([[btp/baglanti/joule-sbpa-work-zone-kurulumu|Joule, SBPA ve Work Zone entegrasyon kurulumu]])
