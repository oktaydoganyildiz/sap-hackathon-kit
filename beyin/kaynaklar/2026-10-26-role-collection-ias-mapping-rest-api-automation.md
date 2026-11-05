---
tur: kaynak
alan: btp
tarih: 2026-10-26
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/stop-clicking-start-scripting-automate-btp-role-collection-mapping-to-ias/ba-p/14507356
gozden_gecir: 2027-04-26
---

# Stop Clicking, Start Scripting: Automate BTP Role Collection Mapping to IAS Groups via REST APIs

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/stop-clicking-start-scripting-automate-btp-role-collection-mapping-to-ias/ba-p/14507356

Yazı türü: tarif

## Özet
- Yazar, 130 BTP role collection'ını IAS user group'larına cockpit üzerinden elle mapleme işinin (~8 saat, hata riski yüksek) SAP Authorization and Trust Management Service (XSUAA) REST API ile otomatikleştirilebileceğini anlatıyor.
- Önkoşullar: Subaccount Administrator rolü, IAS trust yapılandırılmış subaccount, IAS user group'ları hazır, BTP CLI kurulu.
- Credential alma: artık deprecated "cf create-service xsuaa apiaccess" yerine doğrudan `btp create security/api-credential` CLI komutuyla client credential (clientid/clientsecret/url/apiurl) alınıyor.
- Client credentials flow ile OAuth token alınıp `/sap/rest/authorization/v2/identity-providers/<IAS_ORIGIN_KEY>/attributes` endpoint'ine POST atılarak mapping oluşturuluyor; GET ile mevcut mapping'ler önceden kontrol edilebiliyor.
- Kritik tuzak: `attributeName` alanı tam olarak "Groups" (büyük G, case-sensitive) olmalı; yanlışsa anlamlı hata mesajı olmadan başarısız oluyor.
- Node.js script (.env + mappings.json) ile 130 mapping toplu şekilde, HTTP status koduna göre (201/409/404) loglanarak işleniyor; çoklu ortam (dev/QA/prod) için BTP CLI target değiştirip script tekrar çalıştırılıyor.
- Sonuç: 8 saatlik cockpit işi ortam başına ~2 dakikaya iniyor.

## Beslediği sayfalar
- [[btp/guvenlik/role-collection-ias-mapping-rest-api-automation]]
