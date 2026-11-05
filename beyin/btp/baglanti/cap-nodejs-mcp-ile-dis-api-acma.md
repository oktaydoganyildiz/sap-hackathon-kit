---
tur: tarif
alan: btp
kategori: baglanti
urun_surumu: "SAP CAP Node.js, @cap-js/mcp"
tarih: 2026-10-10
guven: topluluk
gozden_gecir: 2027-04-10
---

# CAP Node.js servisini hem OData hem MCP ile dış SAP API'sine bağlama

## Use case
Bir SAP dış API'sini (ör. SAP Sales Cloud V2 Case API) CAP Node.js üzerinden hem OData V4 servisi hem de MCP-uyumlu AI ajanları için tool olarak açmak.

## Varyantlar

### CAP remote service + @protocol: ['odata-v4','mcp'] + @cap-js/mcp
1. Proje oluştur: `cds init cx-mcp --nodejs && cd cx-mcp && npm install`
2. Dış API'yi external service olarak içe aktar: `srv/external/SalesSvcCloudV2_case.cds` (Case API metadata'sından türetilir).
3. Kendi servisini tanımla, `srv/caseservices.cds`:
```cds
using { Service as c4c } from './external/SalesSvcCloudV2_case';

service caseservices {
  type CaseItem { id: UUID; displayId: String(35); subject: String; priority: String;
    status: String; lifeCycleStatus: String; caseType: String;
    createdOn: Timestamp; updatedOn: Timestamp; }
  type CaseInput { subject: String; priority: String; status: String;
    caseType: String; communicationLanguage: String; }

  function listCases(_top: Integer, _skip: Integer, _filter: String, _search: String)
    returns many CaseItem;
  function getCaseById(id: UUID) returns CaseItem;
  action createCase(body: CaseInput) returns CaseItem;
  action patchCase(id: UUID, body: CaseInput) returns CaseItem;
}

annotate caseservices with @protocol: ['odata-v4', 'mcp'];
```
   Kritik satır: `@protocol: ['odata-v4', 'mcp']` — aynı CDS servisini iki protokolden aynı anda açar.
4. Remote service bağlantısını `package.json`'da tanımla (lokal/hybrid ve production için farklı credential):
```json
{
  "cds": {
    "requires": {
      "SalesSvcCloudV2_case": {
        "kind": "odata-v4",
        "model": "srv/external/SalesSvcCloudV2_case",
        "[hybrid]": {
          "credentials": {
            "url": "<SALES-CLOUD-V2-URL>",
            "authentication": "BasicAuthentication",
            "username": "<USERNAME>",
            "password": "<PASSWORD>"
          }
        },
        "[production]": {
          "credentials": {
            "destination": "CX-SALES-CLOUD-V2",
            "path": "<CASE-API-PATH>"
          }
        }
      }
    }
  }
}
```
5. Servis handler'ı yaz, `srv/caseservices.js`:
```js
const cds = require("@sap/cds");

class CaseService extends cds.ApplicationService {
  async init() {
    const c4c = await cds.connect.to("SalesSvcCloudV2_case");

    this.on("listCases", async (req) => {
      const { _top, _skip, _filter } = req.data;
      let query = SELECT.from(c4c.entities.Case);
      if (_filter) query.where(_filter);
      if (_top) query.limit(_top, _skip || 0);
      return c4c.run(query);
    });
    // getCaseById, createCase, patchCase için benzer şekilde implemente edilir
    return super.init();
  }
}

module.exports = { caseservices: CaseService };
```
6. MCP desteğini ekle: `npm add @cap-js/mcp`. BTP'ye deploy edilecekse `cds add xsuaa` ve `cds add mta`.
7. `package.json`'da MCP'yi aç:
```json
{ "cds": { "mcp": { "per_action_tool": true } } }
```
8. `cds watch` ile çalıştır. Uçlar:
   - OData: `http://localhost:4004/odata/v4/caseservices`
   - Metadata: `.../caseservices/$metadata`
   - MCP: `http://localhost:4004/mcp/caseservices`
9. MCP client `tools/list` ile `listCases`, `getCaseById`, `createCase`, `patchCase` tool'larını keşfeder; doğal dil isteğini (ör. "son 10 açık yüksek öncelikli case'i göster") `listCases(_top=10, _filter="status eq 'open'")` çağrısına çevirir.

Ne zaman seçilir: Mevcut bir SAP dış API'sini (C4C/Sales Cloud, S/4 OData, vb.) hem geleneksel OData tüketicilerine hem de AI ajanlarına tek CDS servis tanımından açmak isteniyorsa.

([[kaynaklar/2026-10-10-cap-nodejs-mcp-server-sales-cloud]])

## Tuzaklar
- Remote entity adı ve key alanı (`c4c.entities.Case`) external service'in gerçek metadata'sına göre değişir; kopyala-yapıştır her zaman çalışmaz.
- Credentials'ı production'da `package.json`'a hard-code etmek yerine BTP destination kullanılmalı (`"[production]": {"credentials": {"destination": ...}}`).
- Yazıda Cloud Foundry'ye deploy adımı detaylandırılmamış, sadece "desktop'ta local agent olarak ekle" notu var — production deploy için ek araştırma gerekir.

## İlgili
- [[araclar/cap-mcp-server-cx-case|CAP Node.js MCP Server – SAP CX Case API]]
