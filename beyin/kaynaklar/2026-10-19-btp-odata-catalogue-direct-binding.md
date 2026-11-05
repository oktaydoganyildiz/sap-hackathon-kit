---
tur: kaynak
alan: ai
tarih: 2026-10-19
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-connecting-agents-to-sap-odata-apis-without-an-mcp-server/ba-p/14506364
gozden_gecir: 2027-04-19
---

# Agentic AI on BTP: Connecting Agents to SAP OData APIs without an MCP Server

Link: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-connecting-agents-to-sap-odata-apis-without-an-mcp-server/ba-p/14506364

Yazı türü: arac

## Özet
- BTP üzerindeki bir agentic AI uygulamasında (btp-dynamic-multiagent-app), ajanların SAP OData servislerine erişimi artık ayrı bir MCP server üzerinden değil, uygulama içinde çalışan bir "builtin:odata" toolset üzerinden sağlanıyor.
- Gerekçe: MCP server ekstra bir uygulama/hop demek, kullanıcının JWT'si bir kez daha iletilmek zorunda, generic wrapper servisin tamamını (her entity set, her alan) modele açıyor ve entity set başına tool context'i dolduruyor.
- Admin UI'de bir katalog kuruluyor: servisler $metadata'dan import ediliyor, her servisin kendi kimliği (BTP destination + signed-in user veya technical user) var; entity set başına list/get/create/update/delete, alan başına read/filter/write izinleri tek tek işaretleniyor.
- Ajana sadece iki sabit tool veriliyor: search_operations ve execute_operation — URL, destination adı veya serbest path hiç görünmüyor; kataloğun tanımadığı isim model için yok sayılıyor.
- Kurallar prompt'ta değil kodda uygulanıyor: $select ile yalnız okunabilir alanlar döner, filtre yalnız izinli alanlarla kurulabilir, yazma için hem katalogda hem ajanda ayrı izin (iki anahtar) gerekir, her yazımdan önce/sonra audit log satırı zorunlu, model ETag'i hiç görmez (opak handle + sunucu tarafı If-Match).
- SAP API Policy (Nisan 2026) açısından: ajanlar SAP API'lerine yalnız endorsed SAP mimarisi üzerinden erişmeli; bu desen BTP alt hesabında pro-code ajan olarak çalıştığı için (SAP Architecture Center'daki referans mimariyle uyumlu) uygun görülüyor, müşteri namespace'indeki (Z) servisler serbest.
- Yazar MCP'yi tamamen reddetmiyor: aynı API birden fazla AI istemcisi (Joule, Copilot, Claude) tarafından paylaşılacaksa MCP server hâlâ doğru seçim; burada anlatılan yalnız tek tüketicili (bu uygulamanın ajanları) senaryo için.
- Kaynak kodu GitHub'da açık (lemaiwo/btp-dynamic-multiagent-app).

## Beslediği sayfalar
- [[araclar/btp-odata-catalogue-direct-binding]]
