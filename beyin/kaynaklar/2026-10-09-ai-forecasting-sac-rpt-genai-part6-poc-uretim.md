---
tur: kaynak
alan: ai
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/ai-powered-forecasting-with-sac-sap-rpt-amp-gen-ai-part-6-from-proof-of/ba-p/14475849
gozden_gecir: 2027-04-09
---

# AI-Powered Forecasting with SAC, SAP RPT & Gen AI - Part 6: From Proof of Concept to Production

Link: https://community.sap.com/t5/technology-blog-posts-by-members/ai-powered-forecasting-with-sac-sap-rpt-amp-gen-ai-part-6-from-proof-of/ba-p/14475849

Yazı türü: arac

Serinin son yazısı: SAC + SAP RPT (Relational Pretrained Transformer) + Gen AI ile proje marj/spread tahmini yapan bir pipeline'ın POC'tan üretime geçiş kontrol listesi.

- Doğrulama yöntemi olarak **backtesting** (PROJECTSTART'ı geçmiş bir projenin gerçek başlangıç tarihine çekip o andaki point-in-time karşılaştırılabilir havuzla hindsight'sız tahmin üretmek) ve **shadow mode** (yeni projelerde formül tabanlı değer planlamacıya gösterilmeye devam ederken AI tahmini paralelde, görünmez ve bağlayıcı olmadan loglanır) öneriliyor.
- Trial-tier'dan enterprise'a geçişte kimlik doğrulama katman katman değişiyor: backend'de paylaşılan statik X-Api-Key yerine XSUAA; SAC widget'ındaki client-side API key (dev tools'tan görünür) yerine OAuth; AI Core servis-key tabanlı OAuth; Datasphere zaten OAuth2 Client Credentials + Technical User kullanıyor (doğru pattern, sadece trial kısıtları kalkmalı).
- Sertleştirme listesi: Credential Store servisi, yapılandırılmış loglama/gözlemlenebilirlik, broad `except Exception` yerine hata sınırları, rate limiting/input validation, yük testi ve yatay ölçekleme, security scanning içeren gerçek CI/CD (manuel `cf push` yerine).
- Ölçekte mimari: Datasphere için veri saklama/arşivleme politikası, Cloud Foundry yerine Kyma, model versiyon takibi, audit logging, maliyet/SLA yönetimi.
- Teknoloji seçimini destekleyen kanıtlar: bağımsız bir benchmark SAP-RPT'nin küçük/veri-kıt datasetlerde LightGBM/CatBoost'u geçtiğini gösteriyor; SAP Global AI Ethics politikası human-in-the-loop/escalation tasarımını zorunlu kılıyor.
- Knowledge Graph, Company Memory, MCP ve A2A'nın bu use case'e ileride neler katabileceği (ama bu POC'ta gerekli olmadığı) tartışılıyor.

## Beslediği sayfalar
- [[araclar/ai-forecasting-sac-rpt-genai-pipeline]]
- [[ai/guvenlik/poc-uretim-kimlik-dogrulama-sertlestirme]]
