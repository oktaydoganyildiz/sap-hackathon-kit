---
tur: kaynak
alan: ai
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/sap-joule-studio-mcp-setup-guide/ba-p/14384568
gozden_gecir: 2027-04-09
---

# SAP Joule Studio MCP Setup Guide

Link: https://community.sap.com/t5/technology-blog-posts-by-members/sap-joule-studio-mcp-setup-guide/ba-p/14384568

Yazı türü: deneyim

Özet:
- Node.js tabanlı custom bir MCP server'ın SAP BTP/Cloud Foundry üzerinde Joule Studio'ya bağlanma deneyimi anlatılıyor.
- Önce geçici /test route'larıyla backend servis çağrıları MCP transport'tan bağımsız doğrulandı; bu, MCP sorunlarıyla destination/auth sorunlarını ayırmayı hızlandırdı.
- Destination modeli: MCP server thin kalır, backend'e named destination + relative path ile erişir; ayrı Joule-facing MCP destination MCP server'ın kendisine point eder; /mcp yalnızca Joule Studio advanced path ayarında kalmalı, destination URL'sine eklenmemeli.
- Authentication: MCP server incoming bearer token'a bağımlı olmaktan çıkarılıp Joule-facing destination raw Node.js app'e taşındı; backend destination'lar kendi technical OAuth'unu yönetti.
- cf services / cf env <app> / cf logs --recent komutları sadece troubleshooting değil, implementasyonun ayrılmaz parçası oldu.
- MCP lifecycle: notifications/initialized explicit handle edilmeden tool discovery (tools/list) düzgün ilerlemedi; initialize→notifications/initialized→tools/list çalıştı ama tools/call'a geçilemedi.
- Zod-schema ile plain-schema paralel implementasyonları karşılaştırıldı; ikisi de aynı noktada takıldı, yani sorun schema stili değil muhtemelen Joule-side invocation path.

## Beslediği sayfalar
- [[ai/baglanti/joule-studio-custom-mcp-destination-auth]]
- [[ai/kavramsal/mcp-lifecycle-discovery-vs-invocation]]
