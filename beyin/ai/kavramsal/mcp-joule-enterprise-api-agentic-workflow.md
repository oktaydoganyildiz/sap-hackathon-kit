---
tur: konu
alan: ai
kategori: kavramsal
urun_surumu: ""
tarih: 2026-10-26
guven: resmi
gozden_gecir: 2027-04-26
---

# MCP Server ile Joule Work Desktop'ı doğal dilde kurumsal API'ye bağlama

## Özet
SAP Integration Suite üzerinde var olan bir OData API'si (ör. Business Partner A2X) MCP Server olarak expose edilip Developer Hub üzerinden publish edildikten sonra, Joule Work Desktop (JWD) bu MCP Server'a bir MCP client olarak bağlanabilir. Kullanıcı artık endpoint, entity adı, filter syntax'ı bilmeden doğal dille soru sorar ("Find business partners in Germany and show me their names and cities"), JWD konuşma bağlamını koruyarak takip soruları ("tell me more about the first one") ve özetleme gibi iş odaklı çıktılar üretebilir. Mimari: JWD → MCP → SAP Integration Suite → MCP Server → Integration Cell Runtime → OData → Business Partner API. Alttaki API hiç değişmez; değişen tüketim deneyimidir.

## Ne zaman kullanılır
- Zaten SAP Integration Suite'te expose edilmiş bir OData/REST API'yi Joule veya başka bir MCP client'a (ör. Claude) doğal dil arayüzüyle açmak istediğinizde.
- Kullanıcının API detaylarını (entity, filter, response yapısı) bilmesine gerek kalmadan kurumsal veriye erişmesi gereken agentic BI / self-servis senaryolarında.
- Çok adımlı, konuşma bağlamı gerektiren akışlarda (önce veri bul, sonra detay iste, sonra özet çıkar) — tek seferlik API çağrısı yerine.

## Tuzaklar
- MCP Server için credentials'ı doğrudan oluşturmaya çalışmak JWD bağlantısını kurmaz; Developer Hub adımı atlanırsa bağlantı tamamlanmaz (yazarın ilk denemesi "focused too much on creating credentials directly" olarak başarısız oluyor).
- MCP authentication (JWD ↔ Integration Suite) ile backend authentication (Integration Suite ↔ Business Partner API) ayrı katmanlardır; bunları karıştırmak troubleshooting'i zorlaştırır. Biri çalışıyor diye diğerinin de doğru yapılandırıldığı varsayılmamalı.
- Bu akış, MCP Server mimarisi (OData API → API artifact → MCP Server → Developer Hub publish) önceden kurulmadan çalışmaz; bu sayfa yalnızca JWD bağlantısı ve doğal dil kullanımı adımlarını kapsar, MCP Server oluşturma ayrı bir konudur.

## Çözümler
Başarılı JWD bağlantısı için izlenmesi gereken sıra (Developer Hub tüketim modeli):
```
Deploy → Publish through Developer Hub → Subscribe → Retrieve credentials → Connect JWD
```
- MCP Server'ı Integration Cell'de deploy edin.
- Developer Hub üzerinden publish edin.
- Developer Hub'dan subscribe olun.
- Subscribe sonrası üretilen OAuth credentials'ı (MCP endpoint + OAuth bilgisi) alın.
- Bu endpoint ve OAuth bilgisiyle JWD'de MCP client konfigürasyonunu yapın.

İki authentication akışını ayrı değerlendirerek troubleshooting'i netleştirin:
```
JWD ──(MCP authentication)──► SAP Integration Suite ──(Backend authentication)──► Business Partner API
```

## Tarifler
(Bu konuya özel ayrı bir tarif sayfası henüz yok; MCP Server oluşturma ve Developer Hub publish adımları için seri yazısının Part 1'ine bakın.)

## Cevapladığı sorular
- Developer Hub yerine doğrudan credentials ile Joule Work Desktop'a MCP Server bağlantısı neden başarısız olur ve doğru subscribe-credentials-connect flow nedir?
- JWD'yi MCP client olarak SAP Integration Suite'teki bir MCP Server'a nasıl bağlarım?
- MCP authentication ile backend (OData) authentication arasındaki fark nedir, neden ayrı yönetilmeli?
- Doğal dil ile sorgulanan bir Business Partner API, konuşma bağlamını (ör. "the first one") nasıl korur?

## Sürüm notu
Yazı 2026 tarihli ve SAP Integration Suite + Joule Work Desktop'ın MCP Server/Developer Hub entegrasyonunu temel alıyor; bu özellikler aktif geliştirme altında olabilir, güncel davranış için resmi SAP Integration Suite MCP dokümantasyonunu (help.sap) kontrol edin.

([[kaynaklar/2026-10-26-mcp-joule-natural-language-business-partner]])
