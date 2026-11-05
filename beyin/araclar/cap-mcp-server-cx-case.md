---
tur: arac
alan: btp
urun_surumu: "SAP CAP Node.js, @cap-js/mcp"
tarih: 2026-10-10
guven: topluluk
gozden_gecir: 2027-04-10
---

# CAP Node.js MCP Server – SAP Sales and Service Cloud V2 Case API

## Ne yapar
CAP Node.js servisi, SAP Sales Cloud V2 Case API'sini (listCases, getCaseById, createCase, patchCase) CDS service olarak modelleyip `@protocol: ['odata-v4','mcp']` annotasyonuyla aynı anda hem OData V4 hem MCP endpoint'i (`/mcp/<servis>`) olarak açar. `@cap-js/mcp` paketi her action/function'ı ayrı bir MCP tool'a çevirir; MCP-uyumlu bir AI client (ör. Claude) `tools/list` ile bu tool'ları keşfedip doğal dil isteklerini (örn. "son 10 yüksek öncelikli case'i göster") tool çağrısına dönüştürebilir.

## Bende durumu
yeni

## Agentic BI'a katkısı
SAP CX (Sales/Service Cloud) case verisini bir ajana araç olarak açan somut, genellenebilir bir desen sunuyor: CAP = entegrasyon katmanı, aynı CDS servis tanımından hem OData hem MCP türetiliyor. Bu desen başka SAP business object'leri (S/4, C4C diğer API'ler) için de tekrarlanabilir — Datasphere/BW tarafında agentic BI için "SAP verisini MCP tool'u olarak açma" referans mimarisi olarak kullanılabilir.

## Kurulum
```
cds init cx-mcp --nodejs && cd cx-mcp && npm install && npm add @cap-js/mcp
```
(ardından external service import, `caseservices.cds`/`.js` yazımı ve `package.json`'da `cds.mcp.per_action_tool: true` ayarı gerekir — bkz. [[btp/baglanti/cap-nodejs-mcp-ile-dis-api-acma]])

## Dikkat
- `@cap-js/mcp` paketinin sürüm/bakım durumu ve son push tarihi kontrol edilmeli, yazıda belirtilmiyor.
- Production'da credentials `package.json`'a hard-code edilmemeli, BTP destination (`CX-SALES-CLOUD-V2`) kullanılmalı.
- Remote entity adı/key alanları (`c4c.entities.Case`) external service metadata'sına göre değişir, kör kopyalanmamalı.
- Deploy adımı (Cloud Foundry) yazıda detaylandırılmamış, sadece "local agent için desktop'a ekle" notu var.

## Benzerleri
Resmi SAP MCP sunucuları ve diğer topluluk MCP server implementasyonları — bu kart, CAP tabanlı, dış CX API'sini sarmalayan özel bir yaklaşımı gösteriyor.

([[kaynaklar/2026-10-10-cap-nodejs-mcp-server-sales-cloud]])
