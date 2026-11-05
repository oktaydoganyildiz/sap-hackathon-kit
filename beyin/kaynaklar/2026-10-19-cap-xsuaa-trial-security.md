---
tur: kaynak
alan: btp
urun_surumu: "CAP 9.6, BTP Trial"
tarih: 2026-10-19
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/adding-xsuaa-security-to-a-cap-service-on-the-btp-trial/ba-p/14506224
gozden_gecir: 2027-04-19
---

# Adding XSUAA Security to a CAP Service on the BTP Trial

Link: https://community.sap.com/t5/technology-blog-posts-by-members/adding-xsuaa-security-to-a-cap-service-on-the-btp-trial/ba-p/14506224

Yazı türü: tarif

## Özet
- Bir CAP Node.js servisi varsayılan olarak "auth": "none" ile açık; BTP trial'da XSUAA ile kilitlenmesi adım adım gösteriliyor.
- `cds add xsuaa` komutu boş bir xs-security.json, mta.yaml'a xsuaa resource ve package.json'da production profili (`"auth": "xsuaa"`) ekliyor; local `cds watch` yine token kontrolsüz çalışıyor, CF'de `NODE_ENV=production` token kontrolünü açıyor.
- CDS modelinde `@restrict` ile rol bazlı READ/* yetkileri ve `@requires` ile salt-okunur entity tanımlanıyor; `cds compile srv --to xsuaa > xs-security.json` komutu bu modelden scope/role template'leri otomatik üretiyor ($XSAPPNAME deploy anında değişiyor).
- `cds add approuter` ile bir approuter eklenip `forwardAuthToken: true` ayarıyla token servise iletiliyor; approuter olmadan tarayıcı direkt 401 alıyor.
- mta.yaml kullanılmadan düz `cf push` ile deploy edilirken xsappname, tenant-mode ve redirect-uris xs-security.json'a elle eklenmesi gerekiyor; `cf create-service xsuaa application ... -c xs-security.json` ile instance oluşturulup servise bind ediliyor.
- Approuter ayrı CF app olarak push edilip aynı XSUAA instance'a bind ediliyor, `cf set-env` ile hedef servis route'u destination olarak tanımlanıyor.
- BTP Cockpit'te Security > Roles altında CAP'ten üretilen roller görülüyor; Security > Role Collections altında iki role collection oluşturulup, value help'te uygulama tanımlayıcısının BTP'nin eklediği `!t<id>` suffix'iyle arandığı, role'ün tıklanıp eklendiği ve kullanıcıların e-posta ile atandığı anlatılıyor.

## Beslediği sayfalar
- [[btp/guvenlik/cap-xsuaa-role-collection-kurulum]]
