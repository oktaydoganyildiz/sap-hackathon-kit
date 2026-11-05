---
tur: kaynak
alan: btp
tarih: 2026-10-10
guven: topluluk
kaynak: https://github.com/gavdilabs/cap-mcp-plugin
gozden_gecir: 2027-04-10
---

# gavdilabs/cap-mcp-plugin

https://github.com/gavdilabs/cap-mcp-plugin

Yazı türü: arac

## Özet

- `@gavdi/cap-mcp` npm paketi: SAP CAP (Node.js) servislerini `@mcp` annotation'ları ile otomatik MCP (Model Context Protocol) server'a çeviren açık kaynak plugin.
- CAP entity'leri MCP **resource** (OData v4 filter/orderby/select/top/skip/expand destekli), fonksiyon/action'lar MCP **tool**, ve prompt template'leri MCP **prompt** olarak expose ediliyor.
- Entity'leri `@mcp.wrap` ile query/get/create/update tool'larına sarmalama (wrapper tools) özelliği var; `@mcp.omit` ile hassas alanlar MCP çıktısından gizlenebiliyor (girdi olarak hâlâ kullanılabilir).
- `@mcp.hint` ile alan/parametre bazında LLM'e bağlam (açıklama) verilebiliyor; `elicit: ['confirm','input']` ile tool çağrısından önce kullanıcı onayı/girdi istenebiliyor.
- Auth modu `inherit` (CAP'in mevcut auth'u, ör. xsuaa) veya `none` (yalnız dev); endpoint `/mcp`, health check `/mcp/health`.
- Bilinen kısıt: `@modelcontextprotocol/sdk` bug'ı yüzünden dinamik resource sorgularında tüm query parametrelerinin verilmesi gerekiyor.
- Node.js 18+, CAP 10+, Express 5+ gerektiriyor. Apache-2.0 lisanslı, 61 yıldız, son push 2026-07-17.

## Beslediği sayfalar

- [[araclar/cap-mcp-plugin]]
