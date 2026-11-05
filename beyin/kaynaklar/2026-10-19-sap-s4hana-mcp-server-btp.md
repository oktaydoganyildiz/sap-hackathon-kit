---
tur: kaynak
alan: ai
urun_surumu: ""
tarih: 2026-10-19
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/building-an-mcp-server-for-sap-s-4hana-on-sap-btp/ba-p/14502881
gozden_gecir: 2027-04-19
---

# Building an MCP Server for SAP S/4HANA on SAP BTP

Link: https://community.sap.com/t5/technology-blog-posts-by-members/building-an-mcp-server-for-sap-s-4hana-on-sap-btp/ba-p/14502881

Yazı türü: tarif

## Özet
- SAP S/4HANA'nın released OData V2 API'lerini SAP BTP (Cloud Foundry) üzerinde resmi Python `mcp` SDK'sı (`FastMCP`) ile yazılmış küçük, rule-based (LLM'siz) bir MCP server arkasında agent/chat istemcilerine açıyor.
- Mimari: client → MCP server (Python, Cloud Foundry) → Destination service → Connectivity service + Cloud Connector → S/4HANA (OData). Kod hiçbir host adı/şifre içermiyor, bunlar Destination'da tutuluyor.
- Cloud Connector'da tek bir sistem eşlemesi yeterli: back-end type ABAP System, resource path `/sap/opu/odata/` + "Path and all sub-paths" ile yalnız OData yolu açılıyor.
- Tool tasarımı üç katman: iş-spesifik tool'lar (sales order sayısı, business partner arama, cost center detayları), generic keşif tool'ları (list-services / describe-service / query-service, metadata'dan okunan $metadata ile) ve metadata'daki alan/entity etiketlerini doğal dil ile eşleştiren bir arama tool'u.
- Governance: `/IWFND/CATALOGSERVICE` üzerinden okunan bir envanter script'i aktif/okunabilir servisleri tespit ediyor, sonuç `SAP_ALLOWED_SERVICES`/`SAP_EXTRA_SERVICES` ortam değişkenleriyle allow-list'e besleniyor; servis aktive edilince ilgili tool kod değişikliği olmadan otomatik görünüyor.
- Sayım soruları SAP'tan `$inlinecount=allpages&$top=1` ile tam sayı alıyor (satır indirip saymıyor); listeler her zaman "Total in SAP: N (showing M)" ile gerçek toplamı belirtiyor.
- Deployment adımları: BTP'de `destination`/`connectivity` service instance'ları oluşturma, `manifest.yml` ile `SAP_ALLOW_WRITES: "false"` olarak yazma kapalı başlatma, `cf set-env` ile destination adını koddan ayrı tutma, `cf push`, sonra tool listesi + gerçek veriyle doğrulama.
- Sık görülen HTTP hataları ve çözümleri: 403 (servis aktive değil/isim uyuşmazlığı), 406 (metadata JSON yerine XML istenmeli), 400 (analitik entity set'lerde zorunlu parametre eksik), 500 (backend hatası, `/IWFND/ERROR_LOG`), boş sonuç (yetki eksik), yavaş yanıt (destination her çağrıda okunuyor → cache'le).
- Production için principal propagation öneriliyor; aksi halde tüm kullanıcılar teknik kullanıcının yetkisiyle görür (row-level güvenlik yok).

## Beslediği sayfalar
- [[araclar/btp-sap-odata-to-mcp-server]]
