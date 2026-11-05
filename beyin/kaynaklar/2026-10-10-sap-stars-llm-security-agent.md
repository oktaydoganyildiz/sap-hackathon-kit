---
tur: kaynak
alan: ai
tarih: 2026-10-10
guven: resmi
kaynak: https://github.com/SAP/STARS
gozden_gecir: 2027-04-10
---

# SAP/STARS

Link: https://github.com/SAP/STARS

Yazı türü: arac

STARS (Smart Threat AI Reporting Scanner), SAP AI Core, lokal deployment'lar veya HuggingFace'ten gelen LLM'lere karşı otomatik güvenlik açığı testleri yapan bir AI agent'tır. Proje bir backend (backend-agent) ve Angular tabanlı bir frontend'den oluşur; agent'a chat arayüzü üzerinden veya CLI ile erişilebilir, sadece CLI için yalnız backend yeterlidir. İçinde entegre edilmiş saldırı araçları: NLP tarafında TextAttack; LLM saldırıları tarafında Promptmap, GPTFuzz, PyRIT, CodeAttack, ArtPrompt ve Garak. Apache-2.0 lisanslı, SAP'nin resmi GitHub organizasyonu altında yayınlanmış, 46 star, son push 2026-08-23 — aktif bakımda görünüyor. Amaç, LLM tabanlı uygulamalarda (prompt injection, jailbreak, adversarial prompt vb.) potansiyel güvenlik zafiyetlerini tespit edip düzeltmeye yardımcı olmak. Kurulum docker-compose üzerinden yapılıyor; docs/Tutorial.md altında kullanım kılavuzu mevcut. SAP AI Core ile doğrudan entegrasyon belirtilmiş olması, SAP ekosisteminde barındırılan LLM'lerin güvenlik testi için projeyi doğrudan kullanılabilir kılıyor.

## Beslediği sayfalar
- [[araclar/sap-stars-llm-guvenlik-agenti]]
