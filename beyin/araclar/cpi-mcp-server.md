---
tur: arac
alan: btp
kategori: ajan-araci
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
gozden_gecir: 2027-04-09
---

# cpi-mcp-server — SAP Cloud Integration için MCP server

## Ne yapar
Go ile yazılmış bir MCP server; SAP Cloud Integration (Integration Suite'in bir parçası) tenant'ındaki entegrasyon paketlerini, entegrasyon akışlarını (iflow), value mapping, message mapping, script collection ve integration runtime artefaktlarını listeleme/arama araçlarını (toplam 12 tool) AI destekli uygulamalara (Claude Desktop, Claude Code vb.) MCP üzerinden sunar. OAuth client credentials flow ile SAP Cloud Integration'ın OAuth-korumalı public API'lerine bağlanır; yalnız okuma (read-only) yapar.

## Bende durumu
Yeni. Envanterde SAP Cloud Integration'a özel, canlı tenant verisine erişen bir MCP server tanımlı değil. `sap-btp-integration-suite` (sap-skills paketinde aktif bir plugin) bir **skill** — rehberlik/dokümantasyon odaklı, gerçek tenant'a API çağrısı yaparak paket/flow/mapping/runtime verisi çekmiyor. Bu araç onun tamamlayıcısı sayılabilir: CPI tenant'ındaki gerçek, güncel veriye canlı erişim sağlar. Kurulu bir CPI MCP server'ının doğrudan alternatifi değil, bu alanda envanterdeki ilk gerçek seçenek.

## Agentic BI'a katkısı
Datasphere/BW4 tarafında replication/transformation flow öncesi veya yanında CPI üzerinden kurulan orta katman entegrasyonlarını denetleyen ajanlar için faydalı: "şu an hangi iflow'lar çalışıyor, hangisi hata veriyor", "şu value/message mapping'ler hangi paketlerde tanımlı" gibi soruları ajan, Integration Suite UI'sine girmeden, canlı API üzerinden cevaplayabilir. Entegrasyon katmanının durumunu BI/veri yükleme ajan akışına (ör. veri gelmiyor şikayetinde önce CPI iflow durumunu kontrol etmek) otomatik bağlar.

## Kurulum
```bash
go install github.com/vadimklimov/cpi-mcp-server@latest
```
(Alternatif: `docker pull vadimklimov/cpi-mcp-server`. Çalıştırmadan önce `MCP_CPI_BASE_URL`, `MCP_CPI_TOKEN_URL`, `MCP_CPI_CLIENT_ID`, `MCP_CPI_CLIENT_SECRET` ortam değişkenleri zorunlu; değerler BTP Cloud Foundry'de `SAP Process Integration Runtime` servis örneği (plan: api, grant type: Client Credentials) + servis anahtarından alınır; gereken roller: WorkspacePackagesRead, MonitoringDataRead.)

## Dikkat
- MIT lisans, son push 2026-06-30, 26 yıldız — küçük/bireysel bir topluluk projesi; bakım sürekliliği garanti değil.
- **Yetkilendirme (authorization) yok**: server kendi başına erişim kısıtlaması yapmıyor; README açıkça uyarıyor — remote/HTTP modda mutlaka HTTPS ve harici bir erişim kısıtlama mekanizması (reverse proxy, network izolasyonu vb.) eklenmeli, aksi halde yetkisiz erişime açık.
- OAuth client secret ortam değişkeninde düz metin olarak tutuluyor; üçüncü taraf bir MCP server'a prod tenant kimlik bilgisi vermeden önce en az ayrıcalıklı (WorkspacePackagesRead, MonitoringDataRead ile sınırlı), ayrı bir teknik kullanıcı/service key oluşturulması önerilir.
- Sadece okuma (read) araçları var; iflow deploy/düzenleme gibi yazma işlemleri desteklenmiyor.

## Benzerleri
- `sap-btp-integration-suite` skill (sap-skills, zaten kurulu) — rehberlik/dokümantasyon odaklı, canlı tenant API erişimi sağlamıyor.

([[kaynaklar/2026-10-09-cpi-mcp-server]])
