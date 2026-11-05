---
tur: konu
alan: btp
kategori: kavramsal
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
gozden_gecir: 2027-04-09
---
# Bir Agent'a Birden Fazla MCP Server Bağlama ve Auth Modları

## Özet
Dynamic multi-agent uygulamalarında bir specialist agent'a birden fazla MCP server bağlanabilir, her biri jwt, oauth2 veya none auth modlarından biriyle çalışır. jwt modu BTP-hosted (*.hana.ondemand.com) server'lar için kullanılır ve uygulamanın XSUAA JWT'sini iletir. oauth2 modu kendi authorization server'ı olan sistemler (ör. ARC-1 arkasındaki ABAP sistemi) için kullanılır; Dynamic Client Registration (RFC 7591) ile ilk kullanımda otomatik client kaydı yapılır ve kullanıcı bir kez Authorize linkiyle giriş yapar, token kullanıcı başına saklanır. none modu herhangi bir kimlik doğrulama gerektirmeyen public server'lar içindir.

## Ne zaman kullanılır
Kendi sisteminize (ABAP, vb.) bağlı, kullanıcı kimliğiyle çalışan (per-user yetkilendirme/audit korunan) bir asistan/agent kurarken; birden fazla bilgi kaynağını (resmi dokümantasyon + canlı sistem) tek bir specialist agent'ta birleştirirken.

## Tuzaklar
- Varsayılan olarak yalnızca *.hana.ondemand.com üzerindeki HTTPS URL'ler jwt/oauth2 modunda register edilebilir; kendi barındırdığınız (bu domain dışındaki) MCP server'lar allowlist'e eklenmeden reddedilir.
- none auth modu herhangi bir public server için kısıtlama getirmez — hassas olmayan server'lar için uygundur ama dikkatli seçilmelidir.
- Tek bir agent'a çok sayıda MCP server (ör. 3 server) bağlamak tool listesini uzatır; büyüdükçe yönetimi zorlaşabilir.

## Çözümler
- Kendi MCP server'ınızı (ör. ARC-1) allowlist'e eklemek için host uygulamanın MCP_URL_ALLOWLIST ortam değişkenine URL'yi ekleyin.
- Per-user audit/yetki gereken sistemlerde oauth2 + Dynamic Client Registration kullanın; paylaşılan service account yerine kullanıcı kendi oturumunu bir kez açar, her istek kullanıcının kendi token'ıyla yapılır.
- Hassas sistemlere (ör. ABAP) bağlanan MCP server'ı varsayılan read-only başlatın; yazma, veri önizleme ve serbest SQL'i ayrı bayraklarla ve paket allowlist'iyle sınırlayın.
- Tool listesi çok büyürse agent'ı ileride ayrı specialist'lere bölün (agent tanımı veritabanında satır olduğundan maliyetsiz bir değişiklik).

## Tarifler
- [[araclar/arc-1-adt-mcp-server|ARC-1 ADT MCP server]]
- [[araclar/btp-dynamic-multiagent-app|BTP Dynamic Multi-Agent App]]

## Sürüm notu
Topluluk kaynaklı bir desen, belirli bir SAP ürün sürümüne bağlı değil; RFC 7591 (Dynamic Client Registration) genel bir OAuth2 standardıdır.

([[kaynaklar/2026-10-09-agentic-ai-btp-joule-for-consultants]])
