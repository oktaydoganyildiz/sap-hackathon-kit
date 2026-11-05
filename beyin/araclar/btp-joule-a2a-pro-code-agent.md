---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-11
guven: resmi
gozden_gecir: 2027-04-11
---

# btp-joule-a2a-pro-code-agent

## Ne yapar
SAP-samples'ın referans uygulaması: Joule, A2A (Agent-to-Agent) protokolüyle BTP'de (veya uzakta) barındırılan pro-code ajanı çağırır. Joule istemci, ajan sunucu rolündedir. Modüller:

- `a2a-agent`: A2A uyumlu ajan. TypeScript, CAP, LangGraph. Modellere SAP Cloud SDK for AI ile Generative AI Hub üzerinden erişir. Human-in-the-Loop deseni içerir. Test için LLM üretimini atlayıp sahte (mock) yanıt dönen extension örneği var.
- `joule-integration`: Joule'u ajana bağlar. Action type `agent-request` kullanılır; örnek: `joule-integration/sales-optimization-agent/functions/call_agent.yaml`.
- `webhook-server`: A2A PushNotification için WebSocket tabanlı CAP sunucusu. Ajandan gelen `StatusUpdates` canlı React arayüzünde görünür.
- `terraform`: Uçtan uca BTP kurulumu: subaccount, Cloud Foundry, IAS trust, Joule, AI Core, HANA ve tüm servis binding'leri. SAP BTP, Cloud Foundry ve SCI Terraform provider'ları kullanılır.
- SAP-RPT-1 ajanın tool'u olarak forecasting (ödeme gecikmesi, yeni ürün tanıtımı) ve simülasyon için çalışır. Örnek senaryoda RPT-1 teklif varyantlarını dönüşüm olasılığı, ödeme gecikmesi ve win/win puanına göre skorlar.

Örnek senaryo (satış talebi optimizasyonu): kullanıcı Joule'a "son satış talebini optimize et" der. Joule uygun ajanı seçip A2A ile devreder. Ajan eksik veri varsa (ör. talep ID) kullanıcıya sorar. Sonra ödeme koşulu, iskonto ve ana veriyi çeker, `createFictionalSalesQuotations` tool'uyla varyant üretir, RPT-1 ile skorlar. İlk 3 teklif gerekçesiyle Joule'a döner. İşlem uzun sürerse Joule arka planda çalıştığını söyler ve sonuç hazır olunca push notification gelir.

Soru: Joule'dan A2A protokolüyle BTP'de barındırılan pro-code ajanı nasıl çağırırım?
Cevap: Ajanı `a2a-agent` gibi A2A uyumlu kurup Cloud Foundry'ye deploy et. Joule tarafında `agent-request` tipinde action içeren bir function (`call_agent.yaml`) tanımla. Adım adım yol için repodaki `a2a-agent` ve `joule-integration` README'lerine bak.

## Bende durumu
**yeni.** ENVANTER'de Joule, A2A veya agent-request ile ilgili plugin, skill ya da MCP yok. Kısmen komşu olanlar: `sap-ai-core` ve `sap-cloud-sdk-ai` skill'leri (AI Core / Cloud SDK for AI) ile `cds-mcp` (CAP). Bunlar A2A ve Joule entegrasyonunu kapsamaz.

## Agentic BI'a katkısı
Joule'un 3. parti pro-code ajana A2A ile devrettiği kalıbı uçtan uca gösterir: ajan, tool olarak RPT-1 tahmini, asenkron iş için webhook push notification, Human-in-the-Loop ve Terraform ile tekrarlanabilir BTP kurulumu. Datasphere/BW verisini tool olarak kullanan, Joule'dan çağrılan bir analitik ajan kurmak için şablon olur. RPT-1'i tool olarak bağlama örneği, tahmine dayalı BI senaryoları (ödeme gecikmesi gibi) için doğrudan uyarlanabilir.

## Kurulum
```
git clone https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent.git
```
Sonrası için repo README'leri: yerel kurulum `a2a-agent/README.md`, altyapı `terraform/README.md`, Cloud Foundry deploy `a2a-agent/README.md#10-deployment-to-cloud-foundry`, Joule bağlantısı `joule-integration/README.md`.

## Dikkat
- Lisans Apache-2.0 (REUSE uyumlu). SAP-samples "örnek" statüsünde; resmi destek ve üretim SLA'sı yok.
- Son push 2026-05-20, 21 yıldız: bakım sürekliliği garanti değil. Üretimde kullanmadan önce uyarlayıp test et.
- Ana README'deki Terraform bağlantısı `README.mdt` yazılmış (yazım hatası). Doğru dosya `terraform/README.md`.
- Terraform subaccount, IAS trust, Joule, AI Core ve HANA'yı birlikte açar. Kurulumdan önce BTP entitlement ve maliyeti kontrol et. Terraform state ve service key'leri repoya commit etme.
- Üçüncü taraf MCP server değil, resmi SAP-samples reposu. Yine de BTP/IAS kimlik bilgilerini scriptlere gömme.

## Benzerleri
- [[araclar/cap-agentic-engineered]]: CAP tarafında MCP ve skill ile ajan destekli geliştirme metodolojisi.
- Resmi SAP Architecture Center referans mimarileri: Integrating AI Agents with Joule ve Pro-Code AI Agents on SAP BTP (repo bunlara dayanır).

([[kaynaklar/2026-10-11-btp-joule-a2a-pro-code-agent]])
