---
tur: kaynak
alan: ai
tarih: 2026-10-26
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/part-2-from-mcp-to-natural-language-sap-integration-suite-and-joule-work/ba-p/14507707
gozden_gecir: 2027-04-26
---

# Part 2: From MCP to Natural Language: SAP Integration Suite and Joule Work Desktop

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/part-2-from-mcp-to-natural-language-sap-integration-suite-and-joule-work/ba-p/14507707

Yazı türü: tarif

## Özet
- Part 1'de bir OData Business Partner (A2X) API'si SAP Integration Suite'te API artifact olarak alınıp Integration Cell üzerinde MCP Server olarak expose edilmiş ve Developer Hub üzerinden publish edilmişti.
- Bu yazıda Joule Work Desktop (JWD), Developer Hub'dan alınan MCP endpoint ve OAuth bilgisiyle MCP client olarak bağlanıyor.
- Mimari: JWD → MCP → SAP Integration Suite → MCP Server → Integration Cell Runtime → OData → Business Partner API.
- Kullanıcı doğal dille soru soruyor ("Find business partners in Germany..."), ardından konuşma bağlamını koruyarak takip sorusu ("tell me more about the first one") ve iş odaklı özet ("summarize... before a customer call") istiyor — hiçbir adımda endpoint/entity/filter bilgisi gerekmiyor.
- Yazar üç önemli gözlem paylaşıyor: (1) mevcut API'ler MCP ile değersizleşmiyor, yeni bir tüketici sınıfı (AI client/ajan) kazanıyor; (2) kullanıcı deneyimi API-merkezli akıştan niyet-merkezli akışa dönüşüyor; (3) MCP authentication (JWD↔Integration Suite) ile backend authentication (Integration Suite↔Business Partner API) ayrı katmanlardır, bunları ayırmak troubleshooting'i kolaylaştırıyor.
- Kritik pratik bulgu: JWD bağlantısını doğrudan credentials oluşturarak kurmaya çalışmak başarısız oluyor; doğru sıra Deploy → Publish through Developer Hub → Subscribe → Retrieve credentials → Connect JWD.

## Beslediği sayfalar
- [[ai/kavramsal/mcp-joule-enterprise-api-agentic-workflow]]
