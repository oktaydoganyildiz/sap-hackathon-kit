---
tur: kaynak
alan: btp
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-your-own-joule-for-consultants-connected-to-your-own/ba-p/14485024
gozden_gecir: 2027-04-09
---
# Agentic AI on BTP: Your Own Joule for Consultants, Connected to Your Own System

Link: https://community.sap.com/t5/technology-blog-posts-by-members/agentic-ai-on-btp-your-own-joule-for-consultants-connected-to-your-own/ba-p/14485024

Yazı türü: tarif

Özet: Yazar, önceki yazısında tanıttığı "dynamic multi-agent app" (BTP/Cloud Foundry üzerinde runtime'da reload edilen orkestratör + specialist agent mimarisi) için yeni bir specialist agent konfigüre ediyor: "ABAP Development Agent". Bu agent iki MCP server'a bağlanıyor: Marian Zeis'in genel SAP dokümantasyon MCP server'ı (auth: none) ve ARC-1 (auth: oauth2 + Dynamic Client Registration/RFC 7591), ABAP sistemine ADT REST API üzerinden bağlanan salt-okunur bir MCP proxy. Sonuç, Joule for Consultants'a benzeyen ama kendi ABAP sisteminize bağlı, kullanıcı kimliğiyle (per-user OAuth token) çalışan, kullanıcı başına lisans ücreti olmayan bir asistan. Yazıda agent konfigürasyonu (admin UI, JSON export/import), auth modları (jwt/oauth2/none), MCP_URL_ALLOWLIST kısıtlaması (varsayılan yalnız *.hana.ondemand.com) ve maliyet modeli (token bazlı, BTP kontratı kapsamında) anlatılıyor.

## Beslediği sayfalar
- [[araclar/arc-1-adt-mcp-server]]
- [[araclar/btp-dynamic-multiagent-app]]
- [[btp/kavramsal/mcp-agent-auth-modlari]]
