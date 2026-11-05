---
tur: tarif
alan: btp
kategori: baglanti
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

## Use case
SAP BTP subaccount'ta Joule AI copilot'unu, SAP Build Process Automation (SBPA) ve SAP Build Work Zone (standard edition) ile entegre ederek kullanıcıların doğal dil ile skill/workflow tetikleyebileceği bir ortam kurmak.

## Varyantlar

### Manuel BTP Cockpit Kurulumu
1. **Ön koşul:** Joule-destekli bir data center region'da subaccount olmalı; gerekli service plan'lar global account'ta mevcut olmalı.
2. **Custom Identity Provider (Cloud Identity Services):**
   - Mevcut tenant var mı kontrol et: `https://<tenant>.accounts400.ondemand.com`. Yoksa yeni oluştur.
   - Entitlement ekle: Subaccount → Entitlements → Add Service Plan → Cloud Identity Services → `additional-tenant` plan.
   - Service Marketplace → Cloud Identity Services → Create Instance.
   - SAP'den gelen mail ile tenant'ı aktive et.
3. **Subaccount'ta kullanıcı oluştur:** Security → Users → Create User (Name, Email, Identity Provider = Cloud Identity tenant); gerekli role collection'ları ata.
4. **SAP Build Process Automation kur:**
   - Security → Trust Configuration → Establish Trust → Cloud Identity tenant URL'sini gir.
   - Entitlement ekle: SAP Build Process Automation – `build-default` plan.
   - Service Marketplace → Process Automation → Create Instance.
   - Cloud Identity kullanıcısına ata: Process Automation Admin, Developer, Participant, Viewer role collection'ları.
5. **SAP Build Work Zone, standard edition kur:**
   - Entitlement ekle: SAP Build Work Zone, standard edition – `standard` plan.
   - Service Marketplace → SAP Build Work Zone → Create Instance.
   - Role collection'ları ata: `Launchpad_Admin`, `Launchpad_User`.
6. **Joule Booster'ı çalıştır:** Global Account → Boosters → "Setting Up Joule" ara ve başlat; `das-application – standard` plan, hedef subaccount, entegre edilecek ürünler (SBPA, Work Zone) seçilir.
7. **Prerequisite hatalarını çöz:** Cloud Identity tenant BTP Cockpit → Systems altında görünmüyorsa, Cloud Reporting tool'a erişim iste (`https://reporting.ondemand.com/sap/crp/cdo`), custom tenant'ı arayıp CIS Tenant ID'yi kopyala (senkronizasyon ~1 gün sürebilir), sonra Global Account → Systems → Service Owner View → Add Cloud Identity services system → tenant ID ekle.
8. **Joule rollerini ata:** "Joule Administrator" adında yeni role collection oluştur; `das-application` servisinden `end_user`, `extensibility_developer`, `tenant_admin` rollerini ekle; Cloud Identity kullanıcısına ata.
9. **Joule skill geliştirme akışı (SBPA içinde):**
   - BTP Destination oluştur (dış API endpoint, auth tipi, credentials).
   - SBPA Environment'ı bu destination'a bağla (runtime çağrı izni için).
   - Joule Action oluştur: GET/POST/PUT/DELETE metodu, request/response payload tanımla, test et.
   - Project (workflow) oluştur, Joule Action'ı workflow'a entegre et (skill mantığı burada tasarlanır).
   - Environment'ı SAP Build Work Zone veya Joule Standalone ile paylaş (ikisi aynı environment'ı kullanır).
10. **Work Zone'da Joule'u aktive et:** Site Manager → Settings → "Joule AI Copilot" seçeneğini aç; `das-application` servisinin doğru yapılandırıldığını doğrula; gerekli Joule rollerini kullanıcılara ata.

Ne zaman seçilir: BTP subaccount'ta ilk kez Joule + SBPA + Work Zone entegrasyonu kurulacağında, custom identity provider (Cloud Identity Services) gerektiğinde. ([[kaynaklar/2026-10-09-joule-sbpa-workzone-kurulum-rehberi]])

## Tuzaklar
- Custom Cloud Identity tenant'ı BTP Cockpit → Systems altında görünmeyebilir; Cloud Reporting tool (`reporting.ondemand.com/sap/crp/cdo`) üzerinden CIS Tenant ID manuel eklenmeli.
- Tenant oluşturulduktan sonra Cloud Reporting tool'da görünmesi ~1 gün sürebilir; booster bu süre içinde prerequisite hatası verebilir.
- Joule Booster çalıştırılmadan önce Process Automation ve Work Zone role collection'ları eksikse booster yarıda kalır.
- "Joule Administrator" role collection'ı booster tarafından otomatik oluşturulmaz; manuel oluşturup `end_user`, `extensibility_developer`, `tenant_admin` rollerini das-application servisinden eklemek gerekir.
- Work Zone'da Joule'u aktive etmeden önce das-application servisinin doğru yapılandırıldığından emin olunmalı, aksi halde Joule Copilot seçeneği devreye girmez.

## İlgili
- ([[araclar/joule-ai-copilot]])
