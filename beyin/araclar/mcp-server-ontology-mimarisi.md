---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-26
guven: topluluk
gozden_gecir: 2027-04-26
---

# MCP Server Ontology Mimarisi (Skybuffer AI) — SAP için agentic BI uygulaması geliştirme

## Ne yapar
Skybuffer AI MCP server, SAP ECC ve SAP S/4HANA içine kurulan bir ABAP add-on'dur; MCP (Model Context Protocol) üzerinden Claude (veya ChatGPT, Gemini, VS Code gibi başka MCP istemcileri) için "business ontology" tabanlı tool'lar yayınlar. OData wrapper'ının aksine her tool ham entity/tablo alanı değil, iş sürecini temsil eden hazır (predefined) iş yeteneğini döner: veriler SAP içinde (ABAP/BAPI ile) join edilmiş, kurallar (onay akışı, birim çevrimi, red nedeni gibi) ABAP'ta bir kez yazılmış, yetkilendirme her tool çağrısında kullanıcının SAP rolüne göre kontrol edilmiş olarak gelir. Örnek: delivery-block'lu siparişleri çözen bir sales rep masası, get_blocked_sales_orders, get_material_stock, get_customers_contact_details, change_sales_order gibi tool'larla birkaç saatte (hafta değil) Claude Desktop'ta inşa edilmiştir; yeni gereken sadece 2 tool'dur, gerisi hazır içerikten gelmiştir. ([[kaynaklar/2026-10-26-skybuffer-ai-mcp-server-ontology]])

## Bende durumu
yeni — envanterde eşleniği belirtilmemiş; OData tabanlı özel MCP wrapper'larına alternatif olarak değerlendirilebilir. ([[kaynaklar/2026-10-26-skybuffer-ai-mcp-server-ontology]])

## Agentic BI'a katkısı
- Ontology tabanlı tool tasarımı, agentic BI/ajan uygulamalarında modelin "join ve iş kuralı" yükünü taşımasını engeller; model sadece süreç adımlarını MCP tool'larına eşler.
- Yetkilendirme per-tool/per-kayıt olduğu için ajan uygulamalarında satır bazlı güvenlik (kullanıcının SAP rolü) doğal olarak korunur — her SAP kullanıcısı kendi SSO'su ile bağlanır, ortak teknik kullanıcı yoktur.
- Yazma (write) işlemleri yalnızca kullanıcı onayından sonra (confirm dialog + read-back) gerçekleşir; e-posta gibi dış etkiler asla otomatik gönderilmez — agentic BI'da "insan onaylı aksiyon" deseni için referans.
- İki mimari (Architecture 1: Claude Desktop + ABAP add-on; Architecture 2: SAP BTP + MCP Gateway) agentic BI uygulamalarının pilot/basit kurulumdan kurumsal governance'a nasıl taşınacağını gösterir. ([[kaynaklar/2026-10-26-skybuffer-ai-mcp-server-ontology]])

## Kurulum
Architecture 1 (en basit): Skybuffer AI ABAP add-on'u SAP ECC/S/4HANA sistemine transport et, ICF node'u reverse proxy veya güvenli tünel ile dışa aç, Claude Desktop'ta Settings > Connectors altından Skybuffer AI connector'ını ekleyip kendi SAP SSO kullanıcınla bağlan. ([[kaynaklar/2026-10-26-skybuffer-ai-mcp-server-ontology]])

## Dikkat
- Üçüncü taraf bir ABAP add-on'dur (Skybuffer, SAP değil); kurulum öncesi lisans, bakım ve son güncelleme tarihini kontrol et.
- Mimari 1'de ICF node doğrudan dışa (Claude'un bulut bağlantı noktalarına) açılır; reverse proxy/tünel güvenliği kurulum sorumluluğundadır.
- Kurumsal rollout'ta (Architecture 2) SAP BTP Integration Suite MCP Gateway (SAP TechEd 2025'te duyuruldu) önerilir: OAuth2/OIDC, rate limiting, izlenebilirlik ve tool lifecycle yönetimi ekler; SAP Cloud Connector ile sistem firewall arkasında kalır (inbound port gerekmez).
- Gateway'in mevcut API/iFlow'ları otomatik MCP tool'a çevirme özelliği basit okumalar için uygundur, ama bu durumda OData-wrapper sorunu geri gelir (join ve iş kuralı yükü modelin üzerine biner) — ontology mantığı add-on tarafında kalmalı, gateway sadece governance katmanı olmalı.
- Claude artifacts ile paylaşılan sayfalarda her kullanıcı kendi SAP bağlantısı/yetkisiyle veri görür; paylaşım ve retention Claude'un organizasyon politikalarına (audit log, Compliance API) tabidir. ([[kaynaklar/2026-10-26-skybuffer-ai-mcp-server-ontology]])

## Benzerleri
- OData servisleri üzerine kurulan genel amaçlı MCP wrapper'ları (join ve iş kuralı yükü modelde kalır).
- SAP BTP Integration Suite MCP Gateway'in kendi başına (ontology olmadan) API/iFlow'ları tool'a çevirme özelliği (basit okuma senaryoları için). ([[kaynaklar/2026-10-26-skybuffer-ai-mcp-server-ontology]])
