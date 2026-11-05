---
tur: arac
alan: btp
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
gozden_gecir: 2027-04-09
---

## Ne yapar
odata-mcp-proxy, bir `api-config.json` dosyasına göre OData (V2) veya REST entity set'lerini otomatik olarak MCP tool'larına ($list/$get/$create/$update/$delete + navigasyon özellik tool'ları) çeviren bir Node.js/TypeScript MCP sunucusu. Varsayılan konfigürasyonda SAP Integration Suite (Cloud Integration) Admin API'lerini kapsar: entegrasyon paketleri/iFlow'lar, message processing log'lar, data store/variable/number range, log dosyaları, keystore/sertifika/OAuth2 client gibi security content, partner directory. Bağlantı, SAP BTP Destination Service üzerinden OAuth2 token'ları otomatik yenileyerek kurulur (Cloud Connector değil, Destination + Connectivity servisi). Hem BTP Cloud Foundry'de Streamable HTTP transport ile hem de yerelde Claude Desktop için stdio transport ile çalışır. Kendi `api-config.json`'ını yazarak proxy'yi SAP Integration Suite dışındaki herhangi bir OData/REST API'ye (örn. kendi S/4 OData servisin) yöneltmek de mümkün — paket npm'den bağımlılık olarak kurulup build adımı olmadan tüketilebiliyor (SAP Application Router'a benzer model).

Ayrıca iki ek yetenek var:
- **mcp-ui entegrasyonu:** config'e `ui` bloğu eklenerek, birden çok OData kaynağından paralel veri çeken ve self-contained HTML döndüren etkileşimli "view" tool'ları tanımlanabiliyor (sayfalama, `select` ile payload küçültme, `{$monthsAgo(N):yyyymm}` gibi kapalı placeholder seti ile raporlama pencereleri).
- **Progressive tool discovery:** `discovery` bloğu ile 100+ ayrı entity tool'u yerine `search_operations` (katalog+inceleme) ve `execute_operation` (genel yürütücü) adlı iki sabit meta-tool'a geçilebiliyor — tool listesi konuşma boyunca değişmediği için prompt cache bozulmuyor; MCP istemci en iyi pratikleri (context'in %1-5'ini aşan tool tanımlarında discovery'ye geçiş) referans gösteriliyor.

## Bende durumu
yeni — envanterde SAP Cloud Integration/Integration Suite OData Admin API'lerine yönelik bir MCP server veya skill yok (`sap-btp-integration-suite` skill'i var ama bu bir çağrılabilir skill, canlı CI tenant'ına OData ile bağlanan bir MCP server değil). `cds-mcp` (CAP) ve `hana-mcp-server` farklı katmanları hedefliyor; doğrudan alternatif değil.

## Agentic BI'a katkısı
BW/Datasphere/HANA tarafında zaten agentic erişim varken, entegrasyon katmanı (Cloud Integration iFlow durumu, message processing log'ları, hata ayıklama, keystore/partner directory yönetimi) için doğal dil üzerinden sorgulama/yönetim imkânı sağlıyor — veri yükleme zincirinde entegrasyon ayağının (örn. replication flow'un arkasındaki CI iFlow'un) sorunlarını ajan üzerinden teşhis etmek için kullanılabilir. Genel OData proxy iskeleti olarak, kendi S/4 veya BW OData servislerini de MCP tool'una çevirip agentic BI akışına katabilir.

## Kurulum
```bash
git clone https://github.com/lemaiwo/odata-mcp-proxy && cd odata-mcp-proxy && npm install && cp .env.example .env && npm run build && npm run start:stdio
```
(Önkoşul: BTP hesabında Cloud Foundry ortamı, Integration Suite tenant'ı, Cloud Integration OData API'sine OAuth2 ile bağlı bir BTP Destination tanımlı olmalı.)

## Dikkat
- MIT lisanslı, son push 2026-10-01, 32 yıldız — küçük/genç bir topluluk projesi, bakım sürekliliği garanti değil.
- Üçüncü taraf bir MCP server olduğundan, BTP Destination/Connectivity kimlik bilgilerini (OAuth2 client secret vb.) bu sunucuya vermeden önce kod tabanını ve dağıtım modelini (kendi BTP alt hesabında mı çalıştırılıyor) gözden geçir.
- Varsayılan config SAP Cloud Integration'a özel; farklı bir OData/REST API'ye bağlamak için kendi `api-config.json`'ını yazmak gerekiyor.
- Progressive discovery ve mcp-ui özellikleri MCP'nin 2026-07-28 revizyonundaki spesifikasyon değişikliklerine (sabit tool listesi, `ttlMs`/`cacheScope` resource hint'leri) dayanıyor — MCP istemci sürümüne göre davranış farkı olabilir.

## Benzerleri
- `cds-mcp` (@cap-js/mcp-server) — CAP/CDS odaklı, OData Admin API değil model/servis geliştirme katmanını hedefler.
- `hana-mcp-server` — HANA veritabanı katmanına yönelik, entegrasyon/iFlow yönetimiyle ilgisiz.

([[kaynaklar/2026-10-09-odata-mcp-proxy]])
