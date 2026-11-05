---
tur: kaynak
alan: btp
tarih: 2026-10-10
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/from-sap-sales-and-service-cloud-v2-apis-to-ai-building-an-mcp-server-with/ba-p/14475149
gozden_gecir: 2027-04-10
---

# From SAP Sales and Service Cloud V2 APIs to AI: Building an MCP Server with CAP Node.js

Link: https://community.sap.com/t5/technology-blog-posts-by-members/from-sap-sales-and-service-cloud-v2-apis-to-ai-building-an-mcp-server-with/ba-p/14475149

Yazı türü: tarif

CAP Node.js projesi oluşturulup SAP Sales Cloud V2 Case API'si external service olarak içe aktarılıyor. `caseservices.cds`'te listCases/getCaseById/createCase/patchCase operasyonları tanımlanıyor; `annotate caseservices with @protocol: ['odata-v4','mcp'];` ile aynı servis hem OData V4 hem MCP üzerinden açılıyor. `package.json`'da hybrid/production profilleri ile remote service credentials (lokal basic auth vs BTP destination) ayarlanıyor. `@cap-js/mcp` paketi eklenip `cds.mcp.per_action_tool: true` ile her action/function ayrı MCP tool olarak expose ediliyor; endpoint `/mcp/<servis-adi>`. Servis handler'ında `cds.connect.to` ile remote servise bağlanılıp SELECT/CREATE/UPDATE sorguları yürütülüyor. MCP client `tools/list` ile servisleri keşfedip doğal dil isteğini tool çağrısına çeviriyor (örn. "son 10 yüksek öncelikli case'i göster" → `listCases`). BTP Cloud Foundry'ye deploy ve xsuaa/mta eklenmesine değiniliyor fakat detay verilmiyor.

## Beslediği sayfalar
- [[araclar/cap-mcp-server-cx-case]]
- [[btp/baglanti/cap-nodejs-mcp-ile-dis-api-acma]]
