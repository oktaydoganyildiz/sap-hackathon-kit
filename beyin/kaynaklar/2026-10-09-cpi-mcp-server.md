---
tur: kaynak
alan: btp
tarih: 2026-10-09
guven: topluluk
kaynak: https://github.com/vadimklimov/cpi-mcp-server
gozden_gecir: 2027-04-09
---

# vadimklimov/cpi-mcp-server — MCP server for SAP Cloud Integration

Link: https://github.com/vadimklimov/cpi-mcp-server

Yazı türü: arac

Özet:
- Go ile yazılmış, SAP Cloud Integration (Integration Suite'in bir parçası) tenant'ındaki entegrasyon paketleri ve artefaktlarına erişim sağlayan MCP server.
- 12 araç sunuyor: integration package/flow, value mapping, message mapping, script collection listeleme/arama ve integration runtime artifact listeleme/arama.
- Standalone binary (go install / go build / GoReleaser) veya Docker container (image pull veya Docker Bake ile build) olarak kurulabilir; stdio veya HTTP transport destekliyor.
- Kimlik doğrulama: BTP Cloud Foundry'de `SAP Process Integration Runtime` servis örneği (plan: api, grant type: Client Credentials) + servis anahtarı üzerinden OAuth client credentials flow.
- Gerekli roller: WorkspacePackagesRead (paket/flow/mapping/script sorguları), MonitoringDataRead (runtime artifact sorguları).
- Claude Desktop (lokal mod) ve Claude Code (remote, HTTP mod, `claude mcp add`) için somut yapılandırma örnekleri veriyor.
- ÖNEMLİ UYARI: mevcut implementasyon yetkilendirme (authorization) sağlamıyor — remote modda mutlaka HTTPS ve ayrı bir erişim kısıtlama mekanizması gerekiyor; aksi halde yetkisiz erişime açık kalıyor.
- MIT lisanslı, 26 yıldız, son push 2026-06-30 — küçük/bireysel bakımlı proje.

## Beslediği sayfalar
- [[araclar/cpi-mcp-server]]
