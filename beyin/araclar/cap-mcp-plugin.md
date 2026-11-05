---
tur: arac
alan: btp
urun_surumu: "CAP 10+, Node.js 18+, Express 5+"
tarih: 2026-10-10
guven: topluluk
gozden_gecir: 2027-04-10
---

# cap-mcp-plugin (gavdi/cap-mcp)

## Ne yapar

SAP CAP (Cloud Application Programming, Node.js) servislerini `@mcp` annotation'ları ile otomatik olarak Model Context Protocol (MCP) server'a dönüştüren açık kaynak bir CAP plugin'i (`npm install @gavdi/cap-mcp`).

- **Resource**: CAP entity'lerini OData v4 query desteğiyle (`$filter`, `$orderby`, `$top`, `$skip`, `$select`, `$expand`) MCP resource olarak expose eder.
- **Tool**: CAP function/action'ları çalıştırılabilir MCP tool'a çevirir; parametre `not null` ise tool şemasında `required`, değilse opsiyonel olur.
- **Entity wrapper tools**: `@mcp.wrap: { tools: true, modes: ['query','get','create','update'] }` ile entity'ler query/get/create/update tool'u olarak da sarmalanabilir (`<Service>_<Entity>_query` vb.).
- **@mcp.omit**: Hassas alanları tüm MCP çıktılarından gizler (girdi olarak create/update'te hâlâ kabul edilir).
- **@mcp.hint**: Alan/parametre bazında LLM'e açıklama ekler (ör. kısıtlar, FK ilişkileri, iş bağlamı).
- **elicit**: `['confirm']` ve/veya `['input']` ile tool çalıştırılmadan önce kullanıcı onayı veya parametre girişi istenir (yalnız direct tool'lar için, wrapped entity'lerde yok).
- **Prompt templates**: `@mcp.prompts` ile yeniden kullanılabilir prompt tanımlanabilir.
- Auth: `inherit` (CAP'in mevcut auth mekanizması, ör. xsuaa) veya `none` (yalnız dev/test — production'da kullanılmamalı).
- Endpoint: `http://<host>:4004/mcp`, health check: `/mcp/health`.

## Bende durumu

Kurulu olanın alternatifi: **`@cap-js/mcp-server`** (envanterdeki `cds-mcp` MCP server, plugin: `sap-cds-mcp@claude-plugins-official`, komut `npx -y @cap-js/mcp-server`). İki araç da CAP servislerini MCP'ye bağlıyor; `cap-mcp-plugin` CAP projesinin **içine** gömülen bir annotation-tabanlı plugin (server CAP uygulamasıyla birlikte çalışır), `@cap-js/mcp-server` ise ayrı bir MCP server süreci olarak dışarıdan CAP modeline bakar. Hangisinin ihtiyaca uyduğu proje bazında (annotation kontrolü mü, dış süreç mi) karşılaştırılmalı.

## Agentic BI'a katkısı

CAP tabanlı servisleri (ör. S/4, BTP üzerinde geliştirilen özel CAP uygulamaları) doğal dil ile sorgulanabilir MCP resource/tool'a çevirerek, Claude gibi ajanların CAP veri modeli ve iş mantığıyla doğrudan, OData v4 sorgu gücüyle konuşmasını sağlar. `@mcp.hint` ve `elicit` ile ajan tarafı daha güvenli ve bağlamlı tool çağrıları (ör. yazma işlemlerinden önce onay) mümkün olur — agentic BI senaryolarında hem okuma hem kontrollü yazma için kullanılabilir.

## Kurulum

```bash
npm install @gavdi/cap-mcp
```

Sonrasında `package.json` içine `cds.mcp` konfigürasyonu eklenir, servis/entity'lere `@mcp` annotation'ları yazılır ve `cds serve` ile `/mcp` endpoint'i açılır.

## Dikkat

- Lisans: Apache-2.0 (license dosyasında NOASSERTION görünüyor olabilir, README Apache-2.0 diyor — kontrol edilmeli).
- Son push: 2026-07-17, 61 yıldız — küçük/topluluk projesi, bakım sürekliliği garanti değil.
- `auth: "none"` modu yalnız geliştirme içindir; production'da mutlaka `inherit` + CAP auth (xsuaa vb.) kullanılmalı, aksi halde MCP endpoint'i yetkisiz erişime açık kalır.
- Bilinen SDK bug'ı: dinamik resource sorgularında `@modelcontextprotocol/sdk` RFC template string sorunu nedeniyle tüm query parametrelerinin sağlanması gerekiyor.
- `@mcp.omit` yalnız MCP çıktısını filtreler; alan CAP servisinde sorgulanabilir kalmaya devam eder — gerçek erişim kontrolü için DAC/rol bazlı güvenlik ayrıca kurulmalı.
- Üçüncü taraf topluluk MCP server'ı olduğundan prod kimlik bilgilerini doğrudan bu plugin'e vermeden önce kod incelemesi yapılmalı.

## Benzerleri

- `@cap-js/mcp-server` (resmi/envanterde kurulu `cds-mcp`)
- SAP'nin kendi CAP MCP girişimleri (ör. sap-cds-mcp plugin'i)

([[kaynaklar/2026-10-10-cap-mcp-plugin]])
