---
tur: kaynak
alan: ai
urun_surumu: ""
tarih: 2026-10-11
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/beyond-poc-how-sovanta-detects-purchasing-anomalies-with-a-custom-joule/ba-p/14257926
gozden_gecir: 2027-04-11
---

# Beyond PoC: Joule Studio agent builder ile satın alma anomalisi tespiti

Link: https://community.sap.com/t5/technology-blog-posts-by-members/beyond-poc-how-sovanta-detects-purchasing-anomalies-with-a-custom-joule/ba-p/14257926

Yazı türü: tarif (topluluk blog yazısı, yazı tarihi 2025-11-05)

## Özet
- Joule Studio agent builder ile satış temsilcilerinin müşteri satın alma davranışındaki anormallikleri doğal dille sorguladığı bir agent anlatılıyor.
- Operasyonel veri SAP HANA Cloud üzerindeki BDIH'te (Business Data and Integration Hub), ürün dokümanı ise dahili bir RAG sisteminde duruyor.
- Text-to-SQL için agent, document grounding ile üç şeyle besleniyor: ilgili tabloların şeması, örnek SQL sorguları, veritabanı yapısı ve iş bağlamı dokümantasyonu.
- SQL'i çalıştıran custom Joule Skill, sorguyu girdi olarak alıp veriyi veritabanına giden bir proxy endpoint üzerinden çekiyor.
- SAP Build Actions dinamik çıktıyı tam desteklemediği için dinamik sorgu sonuçlarında bir workaround uygulanmış; workaround'un ayrıntısı yazıda verilmiyor.
- Ürün bilgi tabanı ayrı bir Joule Skill ile bağlanıyor; agent soruya göre kaynağı seçip sonuçları birleştiriyor.
- Yazar, ileride native bir database tool gelirse text-to-SQL hattının gereksiz kalabileceğini söylüyor (şu an mevcut olarak sunulmuyor).
- Yazıda kod veya SQL örneği yok; yalnızca mimari ve akış var.

## Beslediği sayfalar
- [[ai/diger/joule-studio-text-to-sql-agent|Joule Studio text-to-SQL agent (HANA Cloud + RAG)]]
