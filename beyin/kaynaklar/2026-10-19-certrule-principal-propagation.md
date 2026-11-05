---
tur: kaynak
alan: btp
tarih: 2026-10-19
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/several-e-mail-addresses-one-sap-user-certrule-instead-of-the-gateway/ba-p/14500734
gozden_gecir: 2027-04-19
---

# Several e-mail addresses, one SAP user: CERTRULE instead of the gateway mapping table for BTP apps

Link: https://community.sap.com/t5/technology-blog-posts-by-members/several-e-mail-addresses-one-sap-user-certrule-instead-of-the-gateway/ba-p/14500734

Yazı türü: tarif

## Özet
ECC→S/4HANA geçişinde, BTP uygulamalarından gateway üzerinden gelen principal propagation çağrılarını SAP kullanıcısına eşleyen USREXTID tablosu yerine ABAP'ta CERTRULE (rule-based certificate mapping) kullanılabileceğini kanıtlıyor. Tek bir kural (CN=e-posta → SU01'deki e-posta alanı) kullanıcı master'ında adresi olan herkesi otomatik eşler; ikinci bir adrese sahip kişiler veya master'da olmayan adresler için CERTRULE'ün explicit mapping (istisna) listesi kullanılır — bakım yükü kullanıcı×uygulama sayısı değil, yalnızca istisna sayısıdır. Hangi uygulamanın çağırdığı ABAP tarafında görünmez; sertifika sadece e-postayı taşır, bu yüzden aynı Cloud Connector'dan geçen her BTP uygulaması aynı kural ve istisnalara tabi olur. İki testle doğrulanmış: (1) iki farklı kullanıcı → iki farklı SAP kullanıcısı (biri kural, biri istisna ile), (2) aynı kişi iki farklı BTP uygulamasına iki farklı e-posta ile girip her ikisi de aynı SAP kullanıcısına düşüyor. Yazı ayrıca üç gerçek hatayı (Invalid server certificate / host adı uyuşmazlığı, 401 password popup / trusted_reverse_proxy ve tarayıcı oturumu zehirlenmesi, yanlış kullanıcı eşlemesi) log bazında (Cloud Connector trace, ICM trace, HTTP log, work process trace) teşhis ediyor.

## Beslediği sayfalar
- [[btp/baglanti/principal-propagation-cloud-connector]]
