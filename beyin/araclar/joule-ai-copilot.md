---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

## Ne yapar
Joule, SAP'nin konuşma tabanlı AI copilot'udur. SAP Build Process Automation (SBPA) ile oluşturulan skill/workflow'ları ve SAP Build Work Zone'un launchpad arayüzünü kullanarak, kullanıcıların doğal dil isteğiyle (ör. "Create a purchase request for office supplies") backend sistemlerde REST API tabanlı workflow'ları tetiklemesini sağlar. Multi-tenant mimaride (Cloud Foundry üzerinde), SAP Fiori uyumlu konuşma arayüzü sunar ve GDPR/AI ethics standartlarına uyumludur.

## Bende durumu
yeni (envanterde eşleşen bir araç bulunamadı).

## Agentic BI'a katkısı
Joule Action + SBPA Project yapısı, kullanıcı doğal dil isteğini bir workflow'a (ve oradan REST API çağrısına) dönüştürür; bu mekanizma agentic BI senaryolarında "konuşarak aksiyon tetikleme" köprüsü olarak kullanılabilir — ör. bir rapor/insight isteğinin arkasında SAC/Datasphere veya S/4 tarafında bir işlemi otomatik başlatması. Work Zone üzerinden tek bir dijital çalışma alanından erişilebilir olması, farklı agentic skill'lerin tek arayüzde toplanmasını sağlar.

## Kurulum
Global Account → Boosters → "Setting Up Joule" boosterini çalıştır (`das-application – standard` plan, hedef subaccount, SBPA + Work Zone entegrasyonlarını seç); detaylı ön koşullar ve manuel adımlar için bkz. ([[btp/baglanti/joule-sbpa-work-zone-kurulumu]]).

## Dikkat
- SAP first-party BTP servisidir (`das-application`); üçüncü taraf bir MCP/araç değildir, ancak Joule Action içinde tanımlanan dış API destination'ları gerçek credentials barındırır — bu destination'lara erişimi role collection ile sınırlı tutmak gerekir.
- Joule yalnız desteklenen data center region'larında kurulabilir; her subaccount region'ı uygun olmayabilir.
- Lisans: Joule tek başına yeterli değildir — SAP Build Process Automation (`build-default`) ve SAP Build Work Zone (`standard` plan) için ayrı entitlement/lisans gerekir.
- Sürüm notu: Kaynak blog 2026-03-12 tarihli; BTP Cockpit UI ve booster adımları zamanla değişebilir, güncelliği kontrol edilmeli.

## Benzerleri
- SAP Build Process Automation (bağımsız workflow/skill geliştirme aracı, Joule olmadan da kullanılabilir)
- SAP Build Work Zone, standard/advanced edition (launchpad/digital workspace, Joule olmadan da kullanılabilir)

([[kaynaklar/2026-10-09-joule-sbpa-workzone-kurulum-rehberi]])
