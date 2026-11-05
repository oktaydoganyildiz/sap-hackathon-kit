---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

# Joule Desktop + Custom MCP Server (BTP/OData → RAP) Bağlayıcısı

## Ne yapar
Joule Desktop'ı, SAP BTP üzerinde Cloud Foundry'de barındırılan özel bir MCP server üzerinden RAP tabanlı OData V4 servislerine bağlar. Joule, MCP server'ın sunduğu araçları (servis/tool discovery, business entity retrieval, query/operasyon çalıştırma) çağırarak backend'deki RAP business data'sını doğal dil sorularıyla okur ve sonucu interaktif dashboard'a dönüştürür. MCP server, Joule ile backend arasında kimlik doğrulama/yetkilendirme katmanını (BTP Destination üzerinden) kontrol eden bir köprü görevi görür; Joule backend'e doğrudan erişmez.

## Bende durumu
yeni — envanterde Joule Desktop için yapılandırılmış bir MCP connector veya bu amaca özel (RAP/OData V4 + BTP Destination) bir MCP server bulunmuyor. Kurulu `cds-mcp` (CAP/CDS) ve `hana-mcp-server` benzer bir işlev görüyor ama RAP/OData V4 + BTP Destination + Joule Desktop connector senaryosunu kapsamıyor. Yazının temel aldığı topluluk projesi (github.com/lemaiwo/btp-sap-odata-to-mcp-server) üçüncü taraf, kurulu değil.

## Agentic BI'a katkısı
Bu mimari "Joule Desktop → MCP → BTP → OData V4 → RAP" zincirini somutlaştırarak agentic BI akışına örnek teşkil ediyor: doğal dil sorgusu → tool discovery → backend sorgusu → sonuçtan dashboard üretimi. SAC/Datasphere tarafındaki agentic senaryolara paralel olarak, RAP/OData tarafında da benzer bir uçtan uca akışın kurulabileceğini gösteriyor. Önemli mimari ilke: MCP, SAP'nin mevcut güvenlik modelinin (destination, authentication, authorization) yerine geçmiyor, sadece Joule'un bu modelle kontrollü şekilde konuşabildiği protokol/arayüz katmanını sağlıyor.

## Kurulum
Topluluk projesini (github.com/lemaiwo/btp-sap-odata-to-mcp-server) fork/clone edip RAP/OData servisinize göre özelleştirin, ardından Cloud Foundry'ye `cf push` ile deploy edin; üretilen MCP endpoint'i Joule Desktop → Extensions → Connectors altında endpoint + authentication bilgileriyle tanımlayın (RAP OData V4 servisi için BTP Destination önceden hazır olmalı).

## Dikkat
- Üçüncü taraf topluluk projesi temel alınıyor — bakım durumu, son push tarihi ve lisansı bu yazıda belirtilmemiş; kullanmadan önce repo kontrol edilmeli.
- Üçüncü taraf MCP server'a BTP kimlik bilgisi/destination erişimi verirken yetkilendirme kapsamını minimumda tutun; MCP SAP'nin mevcut güvenlik modelinin yerine geçmiyor, sadece arayüz sağlıyor.
- Joule Desktop'ta connector yapılandırması (Extensions → Connectors) ve MCP endpoint + authentication detayları manuel olarak girilmeli, otomatik keşif yok.
- Bu özel implementasyon için Cloud Foundry zorunlu tutulmuş; farklı bir deployment hedefi (ör. Kyma) yazıda ele alınmamış.

## Benzerleri
- cds-mcp (CAP/CDS için MCP server, kurulu) — farklı model, RAP/OData V4 senaryosunu kapsamıyor
- hana-mcp-server (HANA için MCP server, kurulu) — veri tabanı katmanına odaklı, farklı amaç
- github.com/lemaiwo/btp-sap-odata-to-mcp-server — bu yazının temel aldığı topluluk projesi

([[kaynaklar/2026-10-09-joule-desktop-mcp-rap-odata]])
