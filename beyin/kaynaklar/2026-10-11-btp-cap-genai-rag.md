---
tur: kaynak
alan: ai
urun_surumu: ""
tarih: 2026-10-11
guven: resmi
kaynak: https://github.com/SAP-samples/btp-cap-genai-rag
gozden_gecir: 2027-04-11
---

# SAP-samples/btp-cap-genai-rag

Link: https://github.com/SAP-samples/btp-cap-genai-rag

Yazı türü: arac (GitHub örnek repo tanıtımı; README içeriği)

## Özet
- SAP-samples altında, Apache-2.0 lisanslı, resmi ama "örnek" statüsünde bir repo. 141 yıldız, son push 2026-08-05.
- "GenAI Mail Insights" adlı referans uygulama: SAP BTP üzerinde CAP ile GenAI ve RAG.
- LLM'lere Generative AI Hub (SAP AI Core) üzerinden erişir. CAP içinde LangChain kullanır. Çıktıyı özel şemaya göre parse eder.
- RAG için embedding ve SAP HANA Cloud Vector Engine kullanır. Benzer geçmiş e-postaları bulmakta kullanılır.
- İş senaryosu: seyahat acentesi müşteri desteği. E-postadan kategori, duygu ve aciliyet çıkarılır. Özet, çeviri ve yanıt taslağı üretilir. SAP Concur gibi sistemlerle bağlanabilir.
- Tek kiracılı (single-tenant) ve çok kiracılı (multitenant) sürüm içerir. Adım adım tutorial var: giriş, landscape kurulumu, deploy, test, genişletme.
- Yalnız backend içeren hafif bir örnek için ayrı bir branch var.
- Bilinen tek sorun: paketo build sırasında @cap-js/sqlite kaynaklı hata. Repo bir workaround veriyor.
- Yazı repo tanıtımıdır. Tarif veya sahadan çözüm içermiyor.

## Beslediği sayfalar
- [[ai/diger/btp-cap-genai-rag]]
