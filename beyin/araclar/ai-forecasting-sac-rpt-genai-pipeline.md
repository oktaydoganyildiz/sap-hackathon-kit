---
tur: arac
alan: ai
urun_surumu: "SAP RPT, SAC, AI Core, Datasphere, BTP Cloud Foundry (trial tier)"
tarih: 2026-10-09
guven: topluluk
gozden_gecir: 2027-04-09
---

# AI Destekli Forecasting Pipeline: SAC + SAP RPT + Gen AI (agentic BI örneği)

## Ne yapar
Proje bazlı marj/spread tahmini için formül tabanlı (tarihsel ortalama) yaklaşımı AI ile destekleyen uçtan uca bir pipeline: Datasphere karşılaştırılabilir proje havuzunu point-in-time filtreleriyle (PROJECTSTART) sağlıyor, SAP RPT (Relational Pretrained Transformer) bu havuz üzerinden tahmin ve top_column_scores/top_relevant_context_rows ile açıklanabilirlik üretiyor, bir Gen AI katmanı (örnekte kişisel Gemini key) bunu anlatı/yorum metnine çeviriyor. Sonuç üç kanaldan planlamacıya ulaşıyor: Joule Skill, gömülü SAC custom widget, zamanlanmış bildirim. Escalation-trigger mekanizması ile insan her zaman kontrolü elinde tutuyor (human-in-the-loop).

## Bende durumu
Yeni — tek bir kurulu MCP/plugin değil, envanterdeki `sap-ai-core`, `sap-sac-custom-widget`, `sap-sac-scripting`, `sap-sac-planning` ve iki ayrı `sap-datasphere` (plugin: datasphere@sap-datasphere-cowork ve sap-datasphere@sap-skills) bileşenlerinin bir araya getirilişine dair somut bir mimari örnek (agentic BI örneği). Mevcut envanterdeki bu pluginlerle birebir uygulanabilir; ek bir araç kurulumu gerekmiyor, sadece orkestrasyon/kod (app.py, Joule Action, widget JS) eklenmesi gerekiyor.

## Agentic BI'a katkısı
- Doğrulama disiplini: Yeni bir AI tahmin modelini üretime sokmadan önce **backtest** (geçmiş projede PROJECTSTART'ı o projenin gerçek başlangıcına çekip o andaki karşılaştırılabilir havuzla tahmin üretmek — hindsight'sız) ve **shadow mode** (formül tabanlı değer planlamacıya gösterilmeye devam ederken AI tahmini paralelde, görünmez ve bağlayıcı olmadan loglanır) ile kanıt topluyor.
- Escalation-trigger tasarımı, SAP'nin Global AI Ethics politikasındaki "otomatik karar süreçleri insan müdahalesine izin vermeli" ilkesini doğrudan uyguluyor — nice-to-have değil, AI sayısının "işleme güvenle alınabilir" hale gelmesinin mekanizması.
- SAP-RPT seçimi, bağımsız bir benchmark'ın (17 dataset, LightGBM/CatBoost karşı) küçük/veri-kıt senaryolarda RPT'nin öne çıktığı bulgusuna dayanıyor — çoğu kurumsal "az sayıda karşılaştırılabilir proje" senaryosu için ilgili.
- Joule Skill + gömülü SAC widget + zamanlanmış bildirim: aynı pipeline'a üç farklı agentic giriş noktası, tek backend.

## Kurulum
Tek kurulum komutu yok (bu bir mimari örnek, paketlenmiş bir araç değil); backend örnek olarak Cloud Foundry trial'da şu şekilde yayınlanıyor: `cf push` (app.py — X-Api-Key korumalı REST endpoint, AI Core RPT bağlantısı Bearer token ile).

## Dikkat
- **Trial-tier güvenlik açıkları prod'a taşınmamalı:** backend'de paylaşılan statik `X-Api-Key`, SAC widget'ın client-side JavaScript'inde düz metin API key (dev tools ile görünür) — ikisi de üretimde XSUAA tabanlı OAuth ile değiştirilmeli.
- Kod tabanında `except Exception` genel yakalayıcı stack trace/iç detay sızdırabilir; rate limiting ve input validation yok (API, kendisine verilen proje ID'sine güveniyor).
- Narrative katmanı kişisel Gemini API key kullanıyor — üretimde Generative AI Hub (AI Core ile aynı governance) veya müşterinin zaten kurumsal erişimi olan LLM servisi tercih edilmeli; kişisel key'i üretime taşımamak gerekir.
- Kaynak bir topluluk blog yazısı dizisinin son parçası (guven: topluluk), kod POC niteliğinde; verilen "enterprise-ready" kontrol listesi henüz uygulanmış/doğrulanmış değil.
- Datasphere bağlantısı zaten OAuth2 Client Credentials + Technical User kullanıyor — diğer bileşenlere göre üretime en yakın parça.

## Benzerleri
- Joule Skill ile farklı bir agentic giriş noktası olarak genel Joule Action geliştirme.
- SAC canlı bağlantı + analytic model üzerinden klasik (formül tabanlı) forecasting yaklaşımları (bu pipeline'ın karşılaştırıldığı temel).
- MCP tabanlı standardize pipeline (yazıda "ileride eklenebilir" olarak belirtiliyor, bu POC'ta yok).

([[kaynaklar/2026-10-09-ai-forecasting-sac-rpt-genai-part6-poc-uretim]])
