---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-13
guven: topluluk
gozden_gecir: 2027-04-13
---
# mcp-sapcli

## Ne yapar
FastMCP tabanlı, sapcli (SAP CLI) komutlarını MCP tool'larına çeviren topluluk server'ı. ABAP Development Tools (ADT) üzerinden paket, program, class, interface, include, CDS view (DDL), DCL, BDEF, function group/module, dictionary nesneleri (table, structure, data element, domain), transaction ve gCTS repo işlemlerini okuma/yazma/aktivasyon şeklinde ajan üzerinden yapılabilir hale getirir. AUnit ve ATC çalıştırma da dahildir. "Verified" (production-tested, 12 tool, varsayılan) ve `--experimental` bayrağıyla açılan çok daha geniş bir ek tool seti (çoğu sandbox-tested, bazıları bilinen hatalı) sunar.

## Bende durumu
yeni — envanterde ABAP nesnelerini (program/class/CDS) ADT üzerinden yaratma/yazma/aktive etme işlevini doğrudan sağlayan bir MCP tool yok. `sap-abap`/`sap-abap-cds` (sap-skills plugin'i) birer rehberlik skill'i, sisteme yazmaz; `cds-mcp` (@cap-js/mcp-server) CAP CDS projelerine özgüdür, klasik ABAP sistem nesneleriyle çalışmaz. mcp-sapcli bu boşluğu dolduruyor.

## Agentic BI'a katkısı
BDC/BW4/Datasphere tarafında ajanla üretilen modelleme kararlarının ABAP tarafına (CDS view, class, program) ajan eliyle taşınmasını sağlar: ajan bir CDS view taslağı yazıp `abap_ddl_write` + `abap_ddl_activate` ile doğrudan sisteme basabilir, `abap_aunit_run`/`abap_atc_run` ile kaliteyi kontrol edebilir, `abap_gcts_*` tool'larıyla transport/commit adımlarına bağlayabilir. Böylece "analiz et → model öner → ABAP tarafında uygula → test et" döngüsü tek ajan oturumunda kapanır.

## Kurulum
```bash
git clone https://github.com/jfilak/mcp-sapcli && cd mcp-sapcli && pip install -e .[keyring]
```

## Dikkat
- Topluluk projesi (14 yıldız), Apache-2.0, son push 2026-10-12 — aktif bakımda görünüyor ama tek geliştiricili, üretim garantisi yok; prod sistemde dikkatli kullanılmalı.
- Kimlik bilgisi yönetimi: config dosyasında `keyring:<key>` (OS keyring), `$ENV_VAR` veya literal değer modları var; `--stdio` + config modunda kimlik bilgileri LLM'e hiç görünmez, tool'lara yalnız iş parametreleri (ör. class adı, sistem seçici) geçer. Legacy (config'siz) HTTP modunda ise her tool çağrısında ashost/user/password açıkça istenir — bu modda kimlik gizliliği yoktur, üçüncü taraf bir MCP istemcisine bu şekilde kimlik bilgisi geçirmekten kaçının.
- Cookie/session değeri bearer-equivalent'tir; `sapcli-mcp credential set` ile stdin'den (dosyadan veya prompttan) girilmeli, komut satırı argümanı olarak asla verilmemeli (ps çıktısı ve shell history'de açık kalır).
- `--experimental` bayrağı sandbox-tested ama production-tested olmayan çok sayıda tool açar; bazıları bilinen hatalı: `abap_datapreview_osql` (stdio'da kullanılamaz, UnicodeEncodeError), `abap_gcts_repo_tasks` (boş task listesinde çöküyor), `abap_gcts_system_config_get` (KeyError), `abap_config_*` komutları bağlantı tipi hatası veriyor. Prod ortamda yalnız "Verified" set ile başlamak daha güvenli.
- Python >= 3.12 gerektirir.

## Benzerleri
- `sap-abap` / `sap-abap-cds` (sap-skills plugin, envanterde kurulu) — ABAP/CDS geliştirme rehberliği sağlayan skill'ler, ADT'ye doğrudan yazma/aktivasyon yapmaz.
- `cds-mcp` (@cap-js/mcp-server, envanterde kurulu) — CAP CDS projeleri için MCP, klasik ABAP sistem nesneleriyle değil CAP modeliyle çalışır.

([[kaynaklar/2026-10-13-mcp-sapcli]])
