---
tur: kaynak
alan: ai
tarih: 2026-10-26
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/stop-building-sap-apps-business-ai-applications-on-demand-with-an-ontology/ba-p/14508770
gozden_gecir: 2027-04-26
---

# Stop Building SAP Apps: Business AI Applications On Demand with an Ontology-Based MCP Server

Link: https://community.sap.com/t5/technology-blog-posts-by-members/stop-building-sap-apps-business-ai-applications-on-demand-with-an-ontology/ba-p/14508770

Yazı türü: arac

## Özet
- Yazar, Claude Desktop'ı Skybuffer AI MCP server'a (SAP ECC/S4HANA'ya kurulan ABAP add-on) bağlayıp, delivery-block'lu siparişleri yöneten bir sales rep uygulamasını sadece süreç tanımıyla birkaç saatte inşa ediyor.
- Temel tez: MCP tool'un OData entity wrapper'ı mı yoksa business ontology mi olduğu, uygulamanın kalitesini belirliyor. Ontology tabanlı tool'da veriler SAP içinde join edilmiş, kurallar ABAP/BAPI ile bir kez yazılmış, yetkilendirme her çağrıda kullanıcının SAP rolüne göre kontrol edilmiş gelir.
- Predefined (hazır) iş tool'ları (ör. get_blocked_sales_orders, get_material_stock, get_customers_contact_details, change_sales_order) sayesinde yeni uygulamalar için çoğu zaman yalnızca 1-2 yeni tool yazmak yeterli oluyor.
- İki mimari anlatılıyor: Architecture 1 — Claude Desktop + ABAP add-on doğrudan SAP'a SSO ile bağlanır (hızlı, middleware yok); Architecture 2 — SAP BTP Integration Suite MCP Gateway (SAP TechEd 2025'te duyuruldu) araya girer, OAuth2/OIDC, rate limiting, izlenebilirlik ve tool lifecycle governance ekler, SAP Cloud Connector ile sistem firewall arkasında kalır.
- Yazma işlemleri yalnızca kullanıcı onayından sonra yapılır, SAP'a okunup geri gösterilir (read-back); e-posta gibi dış etkiler asla otomatik gönderilmez.
- Claude artifacts üzerinden paylaşılan uygulamada her kullanıcı kendi SAP bağlantısı ve yetkisiyle veri görür, aksiyonlar kendi kullanıcı adıyla kaydedilir.
- Skybuffer AI MCP server yalnız SAP teknolojisine dayanır, Claude dışında ChatGPT, Gemini, VS Code gibi başka MCP istemcileriyle de kullanılabilir; ECC ve S/4HANA'da çalışır.

## Beslediği sayfalar
- [[araclar/mcp-server-ontology-mimarisi]]
