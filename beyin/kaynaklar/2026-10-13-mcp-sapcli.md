---
tur: kaynak
alan: ai
tarih: 2026-10-13
guven: topluluk
kaynak: https://github.com/jfilak/mcp-sapcli
gozden_gecir: 2027-04-13
---
# jfilak/mcp-sapcli

https://github.com/jfilak/mcp-sapcli

tür: arac

FastMCP üzerine kurulu bir topluluk MCP server'ı; sapcli (SAP CLI) komutlarını otomatik olarak MCP tool'larına çeviriyor. ABAP Development Tools (ADT) nesnelerini — program, class, interface, include, CDS view (DDL), DCL, BDEF, function group/module, dictionary nesneleri (table, structure, data element, domain), transaction — ajan üzerinden okuma, yazma ve aktive etme imkânı veriyor. AUnit/ATC testleri ve gCTS repo işlemlerini de tool olarak sunuyor. Tool'lar iki kademede: üretimde test edilmiş 12 adet "Verified" tool (varsayılan açık) ve `--experimental` bayrağıyla açılan çok daha geniş, çoğu sandbox-tested bir set. Kimlik bilgisi yönetimi için OS keyring (`keyring:<key>`), ortam değişkeni (`$ENV_VAR`) ve literal değer modları var; `--stdio` + config modunda kimlik bilgileri LLM'e hiç görünmüyor, tool'lara yalnız iş parametreleri (ör. class adı) geçiyor. Lisans Apache-2.0, 14 yıldız, son push 2026-10-12.

## Beslediği sayfalar
- [[araclar/mcp-sapcli]]
