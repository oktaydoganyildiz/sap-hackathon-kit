---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-19
guven: topluluk
gozden_gecir: 2027-04-19
---

# btp-sap-odata-to-mcp-server

## Ne yapar
SAP BTP Cloud Foundry üzerinde çalışan Node.js/TypeScript MCP server; S/4HANA veya ECC sistemindeki herhangi bir OData servisini dinamik olarak MCP tool'una dönüştürüyor. Yüzlerce entity-bazlı tool yerine 3 seviyeli progresif keşif modeli kullanıyor:

- **Seviye 1 — `discover-sap-data`**: hafif arama, yalnızca serviceId/entityName/entityCount döner (token tasarruflu).
- **Seviye 2 — `get-entity-metadata`**: seçilen entity için tam şema (property, tip, key, capability).
- **Seviye 3 — `execute-sap-operation`**: read / read-single / create / update / delete CRUD işlemleri, Seviye 2'deki metadata ile.

Kimlik doğrulama BTP Destination + Connectivity + XSUAA servisleri üzerinden; Principal Propagation ve OAuth2 destekleniyor. MCP protokolü 2025-06-18, Streamable HTTP (önerilen) ve stdio transport mevcut, session yönetimi + DNS rebinding koruması var.

Aynı hedefe (S/4HANA'nın released OData API'lerini BTP üzerinde MCP server olarak agent/chat istemcilerine açma) ulaşan alternatif, daha sade bir desen de yaygın: hazır paket kurmak yerine resmi Python `mcp` SDK'sı (`FastMCP`) ile küçük, **rule-based (LLM kullanmayan)** bir sunucu sıfırdan yazılıp Cloud Foundry'ye deploy ediliyor. Burada tool sayısı kasıtlı küçük ve iş-odaklı tutuluyor: birkaç iş-spesifik tool (`count_sales_orders`, business partner arama, cost center detayları), üç generic keşif tool'u (list-services / describe-service / query-service) ve `$metadata` üzerinden okunan SAP'ın kendi entity/field etiketleriyle doğal dil sorularını eşleştiren bir arama tool'u. Sayım soruları satır indirip saymıyor, SAP'tan `$inlinecount=allpages&$top=1` ile tam toplamı alıyor; her liste yanıtı "Total in SAP: N (showing M)" ile gerçek toplamı belirtiyor, kısaltılmış liste asla tam sonuçla karıştırılmıyor.

## Bende durumu
Yeni. Envanterde (bkz. ENVANTER §4-5) S/4HANA/ECC OData servislerini generic şekilde MCP tool'u olarak sunan bir araç bulunmuyor. En yakın aday `cds-mcp` (`@cap-js/mcp-server`, plugin: sap-cds-mcp@claude-plugins-official) ama o CAP/CDS tabanlı uygulamalar için; bu araç ise doğrudan BTP Destination üzerinden OData servislerine (S/4HANA/ECC) bağlanıyor ve CRUD'u (create/update/delete dahil) destekliyor — kurulu olan `sap-datasphere` MCP server'ları veya `hana-mcp-server` ile kapsam örtüşmüyor, farklı bir veri katmanını (operasyonel S/4 OData) hedefliyor.

Python/rule-based varyant envanterde ayrıca yok; bu bir "hazır paket kur" aracı değil, "kendi MCP server'ını governance'lı yaz" deseni — LLM/agent katmanına bağlanmadan önce bile deterministik, read-only bir API yüzeyi kurmak isteyenler için referans olarak değerli. İkisi de aynı problemi (S/4 OData → MCP) farklı olgunluk/risk seviyelerinde çözüyor: Node.js paketi hazır ve CRUD destekli (daha riskli), Python yaklaşımı DIY ve varsayılan olarak read-only.

## Agentic BI'a katkısı
Datasphere/HANA/SAC tarafındaki okuma-ağırlıklı agentic BI MCP'lerine ek olarak, S/4HANA/ECC'de doğal dille CRUD (örn. "bank 123'ün sokak numarasını 5 yap", "John Doe adlı yeni müşteri oluştur") yapılmasını sağlıyor; yani agentic BI akışına operasyonel sistem yazma/güncelleme ayağı ekliyor. 3 seviyeli keşif mimarisi, çok sayıda OData servisi olan ortamlarda context şişmesini önlediği için büyük S/4 landscape'lerinde pratik.

Python/rule-based varyant ise servis governance'ını somutlaştırıyor: `/IWFND/CATALOGSERVICE` üzerinden okunan bir envanter script'i ile hangi OData servisinin aktif, hangisinin teknik kullanıcı tarafından okunabilir olduğu tespit edilip `SAP_ALLOWED_SERVICES` / `SAP_EXTRA_SERVICES` allow-list'ine besleniyor; SAP Basis bir servisi aktive ettiğinde ilgili tool kod değişikliği olmadan otomatik görünür hale geliyor. Bu, agent'lara açılan yüzeyi deployment sonrası da kontrol altında tutma ihtiyacı olan projelerde doğrudan uygulanabilir bir desen; ayrıca LLM/agent devreye girmeden önce bile "önce rule-based, sonra agentic" aşamalı bir yol haritası öneriyor.

## Kurulum
Yerelde test için: `npm install` sonrası `example-default-env.json` içeriğini `.env`'e uyarlayıp çalıştırın; BTP'ye dağıtım için `mta.yaml` ile Cloud Foundry'ye `cf deploy` yapın (detaylı adımlar repo içindeki `docs/LOCAL_RUN.md` ve `docs/DEPLOYMENT.md`'de).

Python/FastMCP (DIY) yaklaşımı için özet adımlar:
1. Tool'ları yaz — resmi `mcp` SDK, `@mcp.tool()` dekoratörlü async fonksiyonlar; docstring = tool açıklaması, parametreler = input schema:
```python
from mcp.server.fastmcp import FastMCP
mcp = FastMCP("S4HANA Server")

@mcp.tool()
async def count_sales_orders(customer: str = "") -> str:
    """Exact NUMBER of SAP sales orders. Give 'customer' to count only theirs."""
    flt = f"SoldToParty eq '{customer}'" if customer else ""
    total = await sap_count("API_SALES_ORDER_SRV", "A_SalesOrder", flt)
    return f"Count of sales orders: {total}"

if __name__ == "__main__":
    mcp.run(transport="streamable-http")
```
2. `pip install "mcp[cli]" httpx`
3. BTP servis instance'larını oluştur: `cf create-service destination lite <dest-instance>`, `cf create-service connectivity lite <conn-instance>`.
4. `manifest.yml` içinde üç servisi bağla, `SAP_ALLOW_WRITES: "false"` ile yazma kapalı başlat.
5. `cf set-env <app> SAP_DESTINATION <destination-name>` (sistem adı koddan ayrı tutulur, repo sistem-özgü değer içermez) ve `cf push`, `cf logs <app> --recent` ile doğrula.
6. Deploy edilen server'da önce bir test client ile tool listesini çek, her tool'u gerçek veriyle çalıştır; aktif olmayan servislerin tool'ları listede görünmemeli.

## Dikkat
- MIT lisanslı, son push 2026-05-22 — tek/küçük bakım ekibi görünümünde (136 star), topluluk projesi, resmi SAP desteği yok.
- Create/update/delete operasyonlarını LLM'in doğrudan tetikleyebilmesi riskli: `DISABLE_READ_ENTITY_TOOL=true` gibi kısıtlayıcı env değişkenleri var ama yazma operasyonlarını ayrıca kısıtlama/onay akışı eklemeden production'a almamak gerekir.
- BTP Destination/Connectivity/XSUAA kimlik bilgilerini üçüncü taraf bir MCP server'a (özellikle self-host değilse) tanımlamadan önce güvenlik incelemesi yapın; S/4 sistem erişimi doğrudan verilmiş oluyor.
- ⚠ Sürüm/olgunluk notu: proje nispeten yeni ve hızlı gelişiyor (v2.0.0 health endpoint'inde görülüyor), API/tool isimleri (örn. `r-`/`u-`/`c-`/`d-` prefiksli tool adları README'de geçiyor ama 3-tool mimarisiyle çelişkili görünüyor — güncel sürümde hangisinin geçerli olduğunu canlı kontrol edin.
- Python/DIY yaklaşımında sık görülen Cloud Connector/Destination HTTP hataları ve çözümleri:
  - **403 "No service found"** → servis aktive edilmemiş veya URL'deki teknik adla katalogdaki ad farklı; `/IWFND/MAINT_SERVICE` ile aktive et, servis katalogdaki URL adıyla çağır.
  - **406** metadata okurken → metadata yalnızca XML döner, JSON istenmemeli.
  - **400** bazı analitik entity set'lerinde → zorunlu parametreler eksik; bu entity'leri generic aramadan çıkarıp kendi parametreleriyle sorgula.
  - **500** → backend servis hatası, `/IWFND/ERROR_LOG`'da SAP Basis tarafından analiz edilmeli.
  - Boş sonuçlar → teknik kullanıcının yetkisi eksik (`S_SERVICE` + iş yetkileri, `SU01`/`PFCG`); envanter script'iyle erken kontrol edilmeli.
  - Yavaş yanıtlar → destination her çağrıda okunuyorsa birkaç dakika cache'le.
  - Açık uçlu "valid to 9999-12-31" tarihlerinde taşma hatası → tarih dönüştürme mantığında ayrıca ele alınmalı.
  - Production'da principal propagation olmadan her kullanıcı teknik kullanıcının yetkisiyle görür — row-level güvenlik isteniyorsa Cloud Connector + S/4 trust konfigürasyonu ile principal propagation şart.

## Benzerleri
`cds-mcp` (@cap-js/mcp-server, CAP/CDS servisleri için), kurulu `sap-datasphere` MCP server'ları (Datasphere veri katmanı), `hana-mcp-server` (HANA SQL katmanı), resmi `mcp` Python SDK ile sıfırdan yazılan rule-based/read-only S/4HANA OData MCP server deseni (BTP Destination/Connectivity/Cloud Connector + allow-list governance).

([[kaynaklar/2026-10-10-btp-sap-odata-to-mcp-server]]) ([[kaynaklar/2026-10-19-sap-s4hana-mcp-server-btp]])
