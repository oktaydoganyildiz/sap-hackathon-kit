---
tur: arac
alan: btp
urun_surumu: ""
tarih: 2026-10-10
guven: resmi
gozden_gecir: 2027-04-10
---

# SAP Integration Suite MCP Server

## Ne yapar
SAP Integration Suite içinde yeni bir artifact türü: MCP Server. API Artifacts, HTTP Endpoints ve RFC/BAPI'leri Model Context Protocol (MCP) tool'ları olarak expose ediyor; böylece AI ajanları (Claude dahil) bu kapasiteleri discover edip invoke edebiliyor. Cloud Integration'ın geniş konnektivite portföyüyle birleşince SAP ve SAP-dışı sistemler (REST/OData API'ler, iFlow/Graph kompozisyonları, SAP Build Process Automation workflow'ları, veritabanları, SFTP, Open Connector endpoint'leri, mikroservisler, SaaS platformları) için governed bir "yetenek kataloğu" oluşturuyor. En dikkat çekici yanı: RFC/BAPI desteği — ECC/S4HANA on-premise sistemlerdeki mevcut BAPI'leri yeniden yazmadan ajanlara açabiliyor.

## Bende durumu
yeni — Envanter'de SAP Integration Suite MCP Server (platform tarafı feature) kurulu değil. `sap-btp-integration-suite` skill'i (sap-skills marketplace, aktif) Integration Suite geliştirmede yardımcı olabilir ama bu, platformdaki MCP Server artifact özelliğinin kendisi değil — tamamlayıcı bir skill. `sap-btp-connectivity` skill'i Cloud Connector/Destination kurulumunda yardımcı olabilir.

## Agentic BI'a katkısı
Datasphere/BW/HANA tarafında veri modellemesi yapılırken, S/4HANA veya ECC'deki işlemsel BAPI'leri (örn. sipariş/stok/müşteri sorguları) doğrudan ajana tool olarak sunarak "agentic BI" akışına transaction-seviyesi okuma/aksiyon ekleyebilir — raporlama katmanının ötesine, operasyonel sisteme canlı erişim sağlar. Governance (auth, rate limit, IP filtering) sayesinde ajanların üretim sistemlerine kontrollü erişimi mümkün olur.

## Kurulum
SAP BTP subaccount'unda: Cloud Connector ile RFC bağlantısı kur → BTP Destination oluştur (RFC bağlantısına işaret eden) → Integration Package içinde MCP Server artifact'i oluştur, Destination'ı referansla, expose edilecek RFC/BAPI'leri ekle, Authentication+Quota (opsiyonel Spike Arrest/IP Filtering) policy'lerini ayarla, deploy et, Developer Portal'da API Product olarak publish et.

## Dikkat
- SAP'nin resmi yönü API/OData bazlı modernizasyon; RFC expose etmek **yeni** entegrasyon kurmak için önerilmiyor — sadece ERP modernizasyonu tamamlanana kadar köprü olarak düşünülmeli.
- Yazıdaki demo sadece read-oriented (GET) RFC/BAPI'ler kullanmış; yazma/değişiklik yapan BAPI'leri ajana açmadan önce ek güvenlik/onay mekanizması değerlendirilmeli.
- Üçüncü taraf bir MCP değil, SAP'nin kendi Integration Suite feature'ı — ama yine de API key/credential ajan tarafına (örn. Cline/VS Code) veriliyor, bu da kimlik bilgisi yönetimi riski taşır.
- Kaynak 2026-07-28 tarihli blog; artifact adları/adımları gelecek sürümlerde değişebilir.

## Benzerleri
- `sap-btp-integration-suite` skill (sap-skills, kurulu) — Integration Suite geliştirme genel yardımcı skill.
- `sap-datasphere` MCP server'ları (kurulu) — farklı alan (Datasphere veri modeli) için benzer MCP yaklaşımı.

([[kaynaklar/2026-10-10-sap-integration-suite-mcp-server-rfc-bapi]])
