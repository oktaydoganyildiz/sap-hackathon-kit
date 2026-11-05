---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-10
guven: resmi
gozden_gecir: 2027-04-10
---

# SAP STARS - LLM Güvenlik Test Agent'ı

## Ne yapar
STARS (Smart Threat AI Reporting Scanner), SAP AI Core üzerinden, lokal deploy edilmiş veya HuggingFace'ten gelen LLM'lere karşı otomatik güvenlik açığı (vulnerability) testleri yürüten bir AI agent'tır. Chat tabanlı frontend veya CLI üzerinden çalıştırılabilir; arka planda TextAttack, Promptmap, GPTFuzz, PyRIT, CodeAttack, ArtPrompt ve Garak gibi bilinen saldırı/fuzzing araçlarını orkestre ederek prompt injection, jailbreak ve benzeri LLM zafiyetlerini tespit eder.

## Bende durumu
Envanterde LLM/AI güvenlik testine yönelik kurulu bir araç veya MCP server bulunmuyor (sap-ai-core skill'i var ama bu entegrasyon amaçlı, güvenlik testi değil). Bu nedenle **yeni**.

## Agentic BI'a katkısı
Joule/SAC agentic senaryolarında veya Datasphere/BW üzerine kurulan özel AI agent'larda (RAG, doğal dil sorgu, otomatik model üretimi) kullanılan LLM'lerin prompt injection ve veri sızdırma gibi risklere karşı test edilmesini sağlar. Özellikle SAP AI Core üzerinde barındırılan modellerin production'a alınmadan önce güvenlik validasyonu için kullanılabilir — agentic BI mimarisinde eksik olan güven/doğrulama katmanını tamamlar.

## Kurulum
```bash
git clone https://github.com/SAP/STARS.git && cd STARS && docker-compose up
```
(Backend `backend-agent` + Angular `frontend` birlikte kurulur; yalnız CLI kullanımı için sadece backend yeterlidir. Detaylı adımlar için docs/Tutorial.md.)

## Dikkat
- Apache-2.0 lisanslı, SAP resmi repo, son push 2026-08-23 (aktif bakım görünüyor).
- Henüz küçük bir proje (46 star) — production güvenilirliği kendi testinizle doğrulanmalı.
- SAP AI Core kimlik bilgileri (service key) bu araca verilecekse izole/test ortamı credential'ı kullanılması önerilir; az bilinen üçüncü taraf bir agent'a production AI Core kimlik bilgisi vermekten kaçının.
- İçerdiği alt araçlar (Promptmap, GPTFuzz, PyRIT, Garak vb.) kendi lisanslarına sahip — toplu kullanım öncesi lisans uyumluluğu kontrol edilmeli.

## Benzerleri
- Garak, PyRIT (STARS'ın içinde zaten orkestre edilen, bağımsız kullanılabilen LLM red-teaming araçları)

([[kaynaklar/2026-10-10-sap-stars-llm-security-agent]])
