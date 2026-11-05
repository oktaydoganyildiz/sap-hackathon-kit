---
tur: kaynak
alan: ai
tarih: 2026-10-10
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/step-by-step-implementing-generative-ai-with-sap-hana-cloud/ba-p/14231548
gozden_gecir: 2027-04-10
---

# Step-by-Step: Implementing Generative AI with SAP HANA Cloud

Link: https://community.sap.com/t5/technology-blog-posts-by-members/step-by-step-implementing-generative-ai-with-sap-hana-cloud/ba-p/14231548

Yazı türü: tarif

Özet:
- HANA Cloud calculation view üzerine RAG (Retrieval-Augmented Generation) pattern ile doğal dilde soru-cevap yapan bir AI Sales Assistant kurulumu anlatılıyor.
- HANA Cloud Vector Engine kullanılarak REAL_VECTOR tipinde embedding tablosu oluşturuluyor, harici vector DB gerekmiyor.
- OpenAI embeddings API ile calculation view verisi vektörleştirilip HANA'ya yazılıyor.
- Kullanıcı sorgusu embedding'e çevrilip, HANA'daki embedding'lerle cosine similarity (sklearn, uygulama tarafında) kıyaslanarak en alakalı kayıtlar bulunuyor, gpt-4o-mini ile cevap üretiliyor.
- Backend Flask (REST API), frontend Streamlit (chat arayüzü) ile yapılmış; Flask app Cloud Foundry'ye deploy edilip HANA service'e bind ediliyor (VCAP_SERVICES ile credential enjeksiyonu).
- BAS dev space ile HANA instance'ın aynı region'da olması gerektiği belirtiliyor (aksi halde bağlantı hatası).

## Beslediği sayfalar
- [[ai/diger/rag-ile-hana-sales-assistant]]
