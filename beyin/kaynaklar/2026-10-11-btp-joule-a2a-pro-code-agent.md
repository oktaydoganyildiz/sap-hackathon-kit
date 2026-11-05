---
tur: kaynak
alan: ai
urun_surumu: ""
tarih: 2026-10-11
guven: resmi
kaynak: https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent
gozden_gecir: 2027-04-11
---

# SAP-samples/btp-joule-a2a-pro-code-agent

Link: https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent

Yazı türü: arac (GitHub referans uygulaması)

## Özet
- SAP-samples altında Apache-2.0 lisanslı referans uygulama; 21 yıldız, son push 2026-05-20.
- Joule, A2A (Agent-to-Agent) protokolüyle BTP'de barındırılan 3. parti (pro-code) ajanı çağırıyor; Joule istemci rolünde.
- Ajan TypeScript + LangGraph ile CAP üzerinde yazılmış; modellere SAP Cloud SDK for AI ve Generative AI Hub üzerinden erişiyor; Human-in-the-Loop deseni var.
- SAP-RPT-1, ajanın tool'u olarak forecasting (ödeme gecikmesi, yeni ürün tanıtımı) ve simülasyon için kullanılıyor.
- Uzun süren işler için A2A PushNotification webhook'u var: WebSocket tabanlı CAP sunucusu ve React arayüzü.
- Terraform ile uçtan uca kurulum: subaccount, Cloud Foundry, IAS trust, Joule, AI Core, HANA ve servis binding'leri.
- Örnek senaryo: satış talebi optimizasyonu. Joule isteği ajana devreder, ajan teklif varyantları üretir, RPT-1 skorlar, ilk 3 teklif döner.
- Dizinler: a2a-agent, joule-integration, webhook-server, terraform, docs.

## Beslediği sayfalar
- [[araclar/btp-joule-a2a-pro-code-agent]]
